/* 
 * Copyright (C) 2011 Daiki Ueno <ueno@unixuser.org>
 * Copyright (C) 2011 Red Hat, Inc.
 * 
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public License
 * as published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 * 
 * This library is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
 * 02110-1301 USA
 */
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
     * Proxy to access the character map service.
     */
    public class Charmap : IBus.PanelExtension {
        ICharmap proxy;

        /**
         * Create a new charmap proxy
         *
         * @param conn a DBusConnection
         *
         * @return a new Charmap
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

        /**
         * {@inheritDoc}
         */
        public override void show () {
            try {
                proxy.show ();
            } catch (IOError e) {
                warning ("Error: %s", e.message);
            }
        }

        /**
         * {@inheritDoc}
         */
        public override void hide () {
            try {
                proxy.hide ();
            } catch (IOError e) {
                warning ("Error: %s", e.message);
            }
        }

        /**
         * {@inheritDoc}
         */
        public override void set_cursor_location (int x, int y, int w, int h) {
            try {
                proxy.set_cursor_location (x, y, w, h);
            } catch (IOError e) {
                warning ("Error: %s", e.message);
            }
        }

        /**
         * Move the cursor on the charmap window.
         *
         * @param step a MovementStep
         * @param count amount of the movement
         */
        public void move_cursor (IBus.MovementStep step, int count) {
            try {
                proxy.move_cursor (step, count);
            } catch (IOError e) {
                warning ("Error: %s", e.message);
            }
        }

        /**
         * Select a character cell on the character map.
         *
         * @param uc an Unicode character
         */
        public void select_character (unichar uc) {
            try {
                proxy.select_character (uc);
            } catch (IOError e) {
                warning ("Error: %s", e.message);
            }
        }

        /**
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
         * Start search by a Unicode character name.
         *
         * @param name a substring of Unicode character name
         * @param max_matches maximum number of matches
         */
        public void start_search (string name, uint max_matches) {
            try {
                proxy.start_search (name, max_matches);
            } catch (IOError e) {
                warning ("Error: %s", e.message);
            }
        }

        /**
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
         * Signal emitted each time a character is activated on
         * charmap.
         *
         * @param uc a Unicode character
         */
        public signal void character_activated (unichar uc);
    }
}
