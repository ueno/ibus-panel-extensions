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
    [DBus(name = "org.freedesktop.IBus.Drawing")]
    interface IDrawing : Object {
        public abstract void show () throws IOError;
        public abstract void hide () throws IOError;
        public abstract void set_cursor_location (int x, int y, int w, int h) throws IOError;

        public signal void stroke_added (double[] coordinates);
        public signal void stroke_removed (uint n_strokes);
    }

    /**
     * SECTION:ibusdrawing
     * @short_description: drawing pad support library for IBus, for hand-writing
     *
     * The #IBusDrawing class is a proxy to access the handwriting pad service.
     */
    public class Drawing : Object {
        /**
         * IBusDrawing:visible:
         *
         * Whether the drawing window is visible.
         */
        public bool visible { get; private set; }

        IDrawing proxy;

        /**
         * ibus_drawing_new:
         * @conn: a #DBusConnection
         * @error: an #GError
         *
         * Create an #IBusDrawing instance.
         * Returns: an #IBusDrawing
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
         * ibus_drawing_show:
         * @self: an #IBusDrawing
         *
         * Show a character map.
         */
        public void show () {
            try {
                proxy.show ();
            } catch (IOError e) {
                warning ("Error: %s", e.message);
            }
        }

        /**
         * ibus_drawing_hide:
         * @self: an #IBusDrawing
         *
         * Hide a character map.
         */
        public void hide () {
            try {
                proxy.hide ();
            } catch (IOError e) {
                warning ("Error: %s", e.message);
            }
        }

        /**
         * ibus_drawing_set_cursor_location:
         * @self: an #IBusDrawing
         * @x: X coordinate of the cursor
         * @y: Y coordinate of the cursor
         * @w: width of the cursor
         * @h: height of the cursor
         *
         * Tell the cursor location of the IBus input context to the
         * drawing service.
         */
        public void set_cursor_location (int x, int y, int w, int h) {
            try {
                proxy.set_cursor_location (x, y, w, h);
            } catch (IOError e) {
                warning ("Error: %s", e.message);
            }
        }

        /**
         * IBusDrawing::stroke-added
         * @ibusdrawing: an #IBusDrawing
         * @coordinates: an array of double (0.0 to 1.0) which
         * represents a stroke (i.e. [x1, y1, x2, y2, x3, y3, ...]).
         *
         * The ::stroke-added signal is emitted each time a stroke is
         * added on @ibusdrawing.
         */
        public signal void stroke_added (double[] coordinates);

        /**
         * IBusDrawing::stroke-removed
         * @ibusdrawing: an #IBusDrawing
         * @n_strokes: the number of strokes to be removed.  0 is
         * passed when all the strokes are removed.
         *
         * The ::stroke-removed signal is emitted each time a stroke is
         * removed from @ibusdrawing.
         */
        public signal void stroke_removed (uint n_strokes);
    }
}
