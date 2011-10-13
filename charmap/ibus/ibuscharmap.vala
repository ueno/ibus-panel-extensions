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

namespace IBus {
    [DBus(name = "org.freedesktop.IBus.Charmap")]
    interface ICharmap : Object {
        public abstract void show () throws IOError;
        public abstract void hide () throws IOError;
        public abstract void set_cursor_location (int x, int y, int w, int h) throws IOError;
        public abstract void move_cursor (IBus.MovementStep step, int count) throws IOError;
        public abstract void select_character (unichar uc) throws IOError;
        public abstract void activate_selected () throws IOError;
        public abstract void popup_chapters () throws IOError;
        public signal void character_activated (unichar uc);

        public abstract void start_search (string name, uint max_matches) throws IOError;
        public abstract void cancel_search () throws IOError;
    }

    /**
     * SECTION:ibuscharmap
     * @short_description: Unicode character map support library for IBus
     *
     * The #IBusCharmap class is a proxy to access the character map service.
     */
    public class Charmap : IBus.PanelExtension {
        ICharmap proxy;

        /**
         * ibus_charmap_new:
         * @conn: a #DBusConnection
         * @error: an #GError
         *
         * Create an #IBusCharmap instance.
         * Returns: an #IBusCharmap
         */
        public Charmap (DBusConnection conn) throws IOError {
            proxy = conn.get_proxy_sync ("org.freedesktop.IBus.Charmap",
                                         "/org/freedesktop/IBus/Charmap");
            proxy.character_activated.connect ((uc) => {
                    character_activated (uc);
                });
            ((DBusProxy)proxy).g_properties_changed.connect ((c, i) => {
                    var v = c.lookup_value ("visible", VariantType.BOOLEAN);
                    this.visible = v.get_boolean ();
                });
        }

        ~Charmap () {
            hide ();
        }

        public override void show () {
            try {
                proxy.show ();
            } catch (IOError e) {
                warning ("Error: %s", e.message);
            }
        }

        public override void hide () {
            try {
                proxy.hide ();
            } catch (IOError e) {
                warning ("Error: %s", e.message);
            }
        }

        public override void set_cursor_location (int x, int y, int w, int h) {
            try {
                proxy.set_cursor_location (x, y, w, h);
            } catch (IOError e) {
                warning ("Error: %s", e.message);
            }
        }

        /**
         * ibus_charmap_move_cursor:
         * @self: an #IBusCharmap
         * @step: an #IBusMovementStep
         * @count: amount of the movement
         *
         * Move the cursor on the charmap window.
         */
        public void move_cursor (IBus.MovementStep step, int count) {
            try {
                proxy.move_cursor (step, count);
            } catch (IOError e) {
                warning ("Error: %s", e.message);
            }
        }

        /**
         * ibus_charmap_select_character:
         * @self: an #IBusCharmap
         * @uc: an Unicode character
         *
         * Select a character cell on the character map.
         */
        public void select_character (unichar uc) {
            try {
                proxy.select_character (uc);
            } catch (IOError e) {
                warning ("Error: %s", e.message);
            }
        }

        /**
         * ibus_charmap_activate_selected:
         * @self: an #IBusCharmap
         *
         * Activate selected character (if any).
         */
        public void activate_selected () {
            try {
                proxy.activate_selected ();
            } catch (IOError e) {
                warning ("Error: %s", e.message);
            }
        }

        /**
         * ibus_charmap_popup_chapters:
         * @self: an #IBusCharmap
         *
         * Pull down the chapters menu.
         */
        public void popup_chapters () {
            try {
                proxy.popup_chapters ();
            } catch (IOError e) {
                warning ("Error: %s", e.message);
            }
        }

        /**
         * ibus_charmap_start_search:
         * @self: an #IBusCharmap
         * @name: a substring of Unicode character name
         * @max_matches: maximum number of matches
         *
         * Start search by a Unicode character name.
         */
        public void start_search (string name, uint max_matches) {
            try {
                proxy.start_search (name, max_matches);
            } catch (IOError e) {
                warning ("Error: %s", e.message);
            }
        }

        /**
         * ibus_charmap_cancel_search:
         * @self: an #IBusCharmap
         *
         * Cancel search in progress.
         */
        public void cancel_search () {
            try {
                proxy.cancel_search ();
            } catch (IOError e) {
                warning ("Error: %s", e.message);
            }
        }

        /**
         * IBusCharmap::character-activated:
         * @ibuscharmap: an #IBusCharmap
         * @uc: a Unicode character
         *
         * The ::character-activated signal is emitted each time @uc
         * is activated on @ibuscharmap either by
         * ibus_charmap_activate_selected() or by clicking on the
         * character map.
         */
        public signal void character_activated (unichar uc);
    }
}
