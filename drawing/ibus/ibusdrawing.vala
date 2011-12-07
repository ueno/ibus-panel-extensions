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
    [DBus(name = "org.freedesktop.IBus.Drawing")]
    interface IDrawing : Object {
        public abstract void show () throws IOError;
        public abstract void hide () throws IOError;
        public abstract void set_cursor_location (int x, int y, int w, int h) throws IOError;

        public signal void stroke_added (double[] coordinates);
        public signal void stroke_removed (uint n_strokes);
    }

    /**
     * Proxy to access the handwriting pad service.
     */
    public class Drawing : IBus.PanelExtension {
        /**
         * Whether the drawing window is visible.
         */
        public bool visible { get; private set; }

        IDrawing proxy;

        /**
         * Create a drawing pad instance.
         *
         * @param conn a DBusConnection
         *
         * @return a new Drawing instance
         */
        public Drawing (DBusConnection conn) throws IOError {
            proxy = conn.get_proxy_sync ("org.freedesktop.IBus.Drawing",
                                         "/org/freedesktop/IBus/Drawing");
            ((DBusProxy)proxy).g_properties_changed.connect ((c, i) => {
                    var v = c.lookup_value ("visible", VariantType.BOOLEAN);
                    this.visible = v.get_boolean ();
                });
        }

        ~Drawing () {
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
         * Signal emitted each time a stroke is added.
         *
         * @param coordinates an array of double (0.0 to 1.0) which
         * represents a stroke (i.e. [x1, y1, x2, y2, x3, y3, ...]).
         */
        public signal void stroke_added (double[] coordinates);

        /**
         * Signal emitted each time a stroke is removed.
         *
         * @param n_strokes the number of strokes to be removed.  0 is
         * passed when all the strokes are removed.
         */
        public signal void stroke_removed (uint n_strokes);
    }
}
