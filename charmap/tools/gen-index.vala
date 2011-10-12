// -*- mode: vala; indent-tabs-mode: nil -*-
// Copyright (C) 2011  Daiki Ueno
// Copyright (C) 2011  Red Hat, Inc.

// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
// 02110-1301, USA.

namespace IBusGucharmap {
    class IndexGenerator : Object {
        private string filename;

        const string create_schema = """
DROP TABLE IF EXISTS unicode_blocks;
CREATE TABLE unicode_blocks (
    id INTEGER PRIMARY KEY ASC,
    name TEXT,
    first_codepoint INTEGER,
    last_codepoint INTEGER
);

DROP INDEX IF EXISTS unicode_blocks_by_name;
CREATE INDEX unicode_blocks_by_name ON unicode_blocks (name);

DROP TABLE IF EXISTS unicode_names;
CREATE TABLE unicode_names (
    codepoint INTEGER PRIMARY KEY,
    name TEXT,
    block_id INTEGER
);

DROP INDEX IF EXISTS unicode_names_by_name;
CREATE INDEX unicode_names_by_name ON unicode_names (name);
""";

        public IndexGenerator (string filename) {
            this.filename = filename;
        }

        private bool insert_block (Sqlite.Database database,
                                   Gucharmap.BlockChaptersModel model,
                                   int block_id,
                                   uint first_codepoint,
                                   uint last_codepoint)
        {
            for (uint uc = first_codepoint; uc < last_codepoint; uc++) {
                if (!Gucharmap.unichar_isdefined (uc))
                    continue;

                string sql = "INSERT INTO unicode_names VALUES (?, ?, ?);";
                int rc;

                Sqlite.Statement stmt;
                rc = database.prepare (sql, sql.length, out stmt);
                if (rc != Sqlite.OK) {
                    stderr.printf ("can't prepare statement: %s\n",
                                   database.errmsg ());
                    return false;
                }

                rc = stmt.bind_int64 (1, uc);
                if (rc != Sqlite.OK) {
                    stderr.printf ("can't bind values: %s\n",
                                   database.errmsg ());
                    return false;
                }

                string name = Gucharmap.get_unicode_name (uc);
                rc = stmt.bind_text (2, name.dup ());
                if (rc != Sqlite.OK) {
                    stderr.printf ("can't bind values: %s\n",
                                   database.errmsg ());
                    return false;
                }

                rc = stmt.bind_int64 (3, block_id);
                if (rc != Sqlite.OK) {
                    stderr.printf ("can't bind values: %s\n",
                                   database.errmsg ());
                    return false;
                }
                
                rc = stmt.step ();
                if (rc != Sqlite.DONE) {
                    stderr.printf ("can't commit the change: %s\n",
                                   database.errmsg ());
                    return false;
                }
            }
            return true;
        }

        private bool insert_blocks (Sqlite.Database database) {
            var model = new Gucharmap.BlockChaptersModel ();
            Gtk.TreeIter iter;
            int block_id;

            if (!model.get_iter_first (out iter)) {
                return false;
            }

            block_id = 1;
            do {
                string name;
                model.get (iter, 0, out name);
                if (name == "All") {
                    block_id++;
                    continue;
                }

                string sql = "INSERT INTO unicode_blocks VALUES (?, ?, ?, ?);";
                int rc;

                Sqlite.Statement stmt;
                rc = database.prepare (sql, sql.length, out stmt);
                if (rc != Sqlite.OK) {
                    stderr.printf ("can't prepare statement: %s\n",
                                   database.errmsg ());
                    return false;
                }

                rc = stmt.bind_text (2, name.dup ());
                if (rc != Sqlite.OK) {
                    stderr.printf ("can't bind values: %s\n",
                                   database.errmsg ());
                    return false;
                }

                var codepoint_list = (Gucharmap.BlockCodepointList)model.get_codepoint_list (iter);
                rc = stmt.bind_int64 (3, codepoint_list.first_codepoint);
                if (rc != Sqlite.OK) {
                    stderr.printf ("can't bind values: %s\n",
                                   database.errmsg ());
                    return false;
                }

                rc = stmt.bind_int64 (4, codepoint_list.last_codepoint);
                if (rc != Sqlite.OK) {
                    stderr.printf ("can't bind values: %s\n",
                                   database.errmsg ());
                    return false;
                }

                rc = stmt.step ();
                if (rc != Sqlite.DONE) {
                    stderr.printf ("can't commit the change: %s\n",
                                   database.errmsg ());
                    return false;
                }

                insert_block (database,
                              model,
                              block_id++,
                              codepoint_list.first_codepoint,
                              codepoint_list.last_codepoint);

            } while (model.iter_next (ref iter));

            return true;
        }

        public bool generate () {
            Sqlite.Database database;
            int rc;

            rc = Sqlite.Database.open (filename, out database);
            if (rc != Sqlite.OK) {
                stderr.printf ("can't open database\n");
                return false;
            }

            rc = database.exec (create_schema);
            if (rc != Sqlite.OK) {
                stderr.printf ("can't create tables: %s\n",
                               database.errmsg ());
                return false;
            }

            rc = database.exec ("BEGIN;");
            if (rc != Sqlite.OK) {
                stderr.printf ("can't start transaction: %s\n",
                               database.errmsg ());
                return false;
            }

            if (!insert_blocks (database)) {
                return false;
            }

            rc = database.exec ("COMMIT;");
            if (rc != Sqlite.OK) {
                stderr.printf ("can't complete transaction: %s\n",
                               database.errmsg ());
                return false;
            }

            return true;
        }
    }

    public static int main (string[] args) {
        // Don't exit when display cannot be opened
        if (!Gtk.init_check (ref args)) {
            warning ("Can't init GTK, but ignoring the error");
        }
            

        if (args.length < 2) {
            stderr.printf ("Usage: gen-index FILENAME\n");
            return 1;
        }

        IndexGenerator generator = new IndexGenerator (args[1]);
        generator.generate ();

        return 0;
    }
}
