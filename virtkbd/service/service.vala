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

namespace IBusVirtkbd {
    [DBus(name = "org.freedesktop.IBus.Virtkbd")]
    public abstract class Service : Object {
        public bool visible { get; protected set; }
        public abstract void show ();
        public abstract void hide ();
        public abstract void set_cursor_location (int x, int y, int w, int h);

        public abstract void set_keyboard (string keyboard);

        public signal void text_activated (string text);

        protected void register_virtkbd (DBusConnection conn) {
            try {
                // start service and register it as dbus object
                conn.register_object ("/org/freedesktop/IBus/Virtkbd", this);
            } catch (IOError e) {
                stderr.printf ("Could not register service: %s\n", e.message);
            }
            Bus.own_name_on_connection (conn,
                                        "org.freedesktop.IBus.Virtkbd",
                                        BusNameOwnerFlags.NONE,
                                        () => {},
                                        () => stderr.printf ("Could not aquire name\n"));
        }
    }
}