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
    [DBus(name = "org.freedesktop.IBus.Virtkbd")]
    interface IVirtkbd : Object {
        public abstract void show () throws IOError;
        public abstract void hide () throws IOError;
        public abstract void set_cursor_location (int x, int y, int w, int h) throws IOError;
        public abstract void set_keyboard (string keyboard) throws IOError;
        public signal void text_activated (string text);
    }

    /**
     * SECTION:ibusvirtkbd
     * @short_description: Virtual keyboard support library for IBus
     *
     * The #IBusVirtkbd class is a proxy to access the virtual keyboard service.
     */
    public class Virtkbd : IBus.PanelExtension {
        /**
         * IBusVirtkbd:keyboard-type:
         *
         * Keyboard type to be displayed.
         */
        public string keyboard_type { get; set; }

        IVirtkbd proxy;

        /**
         * ibus_virtkbd_new:
         * @conn: a #DBusConnection
         * @error: an #GError
         *
         * Create an #IBusVirtkbd instance.
         * Returns: an #IBusVirtkbd
         */
        public Virtkbd (DBusConnection conn) throws IOError {
            proxy = conn.get_proxy_sync ("org.freedesktop.IBus.Virtkbd",
                                         "/org/freedesktop/IBus/Virtkbd");
            proxy.text_activated.connect ((text) => {
                    text_activated (text);
                });
            ((DBusProxy)proxy).g_properties_changed.connect ((c, i) => {
                    var v = c.lookup_value ("visible", VariantType.BOOLEAN);
                    this.visible = v.get_boolean ();
                });
        }

        ~Virtkbd () {
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
         * ibus_virtkbd_set_keyboard:
         * @self: an #IBusVirtkbd
         * @keyboard: name of keyboard
         *
         * Set the keyboard type to @keyboard.
         */
        public void set_keyboard (string keyboard) {
            try {
                proxy.set_keyboard (keyboard);
            } catch (IOError e) {
                warning ("Error: %s", e.message);
            }
        }

        /**
         * IBusVirtkbd::text-activated:
         * @ibusvirtkbd: an #IBusVirtkbd
         * @text: a text
         *
         * The ::text-activated signal is emitted each time @text is
         * activated on @ibusvirtkbd by clicking on the character map.
         */
        public signal void text_activated (string text);
    }
}
