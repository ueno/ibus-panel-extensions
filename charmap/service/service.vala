/*
 * Copyright (C) 2011  Daiki Ueno
 * Copyright (C) 2011  Red Hat, Inc.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
 * 02110-1301, USA.
 */
namespace IBusCharmap {
    [DBus(name = "org.freedesktop.IBus.Charmap")]
    public abstract class Service : Object {
        public bool visible { get; protected set; }
        public abstract void show ();
        public abstract void hide ();
        public abstract void set_cursor_location (int x, int y, int w, int h);

        // common
        public abstract void move_cursor (IBus.MovementStep step, int count);

        // charmap
        public abstract void select_character (unichar uc);
        public abstract void activate_selected ();
        public abstract void popup_chapters ();
        public signal void character_activated (unichar uc);

        // search
        public abstract void start_search (string name, uint max_matches);
        public abstract void cancel_search ();

        protected void register_charmap (DBusConnection conn) {
            try {
                // start service and register it as dbus object
                conn.register_object ("/org/freedesktop/IBus/Charmap", this);
            } catch (IOError e) {
                stderr.printf ("Could not register service: %s\n", e.message);
            }
            Bus.own_name_on_connection (conn,
                                        "org.freedesktop.IBus.Charmap",
                                        BusNameOwnerFlags.NONE,
                                        () => {},
                                        () => stderr.printf ("Could not aquire name\n"));
        }
    }
}