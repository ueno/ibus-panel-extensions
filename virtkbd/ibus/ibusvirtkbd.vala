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
    [DBus(name = "org.freedesktop.IBus.Virtkbd")]
    interface IVirtkbd : Object {
        public abstract void show () throws IOError;
        public abstract void hide () throws IOError;
        public abstract void set_cursor_location (int x, int y, int w, int h) throws IOError;
        public abstract void set_keyboard (string keyboard) throws IOError;
        public signal void text_activated (string text);
    }

    /**
     * Proxy to access the virtual keyboard service.
     */
    public class Virtkbd : IBus.PanelExtension {
        /**
         * Keyboard type to be displayed.
         */
        public string keyboard_type { get; set; }

        IVirtkbd proxy;

        /**
         * Create a virtkbd instance.
         *
         * @param conn a DBusConnection
         *
         * @return a new Virtkbd
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
         * Set the keyboard type.
         *
         * @param keyboard name of keyboard
         */
        public void set_keyboard (string keyboard) {
            try {
                proxy.set_keyboard (keyboard);
            } catch (IOError e) {
                warning ("Error: %s", e.message);
            }
        }

        /**
         * Signal emitted each time a symbol text is activated.
         *
         * @param text a symbol text
         */
        public signal void text_activated (string text);
    }
}
