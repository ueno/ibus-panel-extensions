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

namespace IBusDrawing {
    public class GtkService : Service {
        // const values
        const int INITIAL_WIDTH = 320;
        const int INITIAL_HEIGHT = 240;

        Gtk.Window window;
        IBus.WindowPlacement placement;

        DrawingPanel drawing_panel;

        internal static IBus.Bus bus;
        internal static IBus.Config config;

        public GtkService (DBusConnection conn) {
            window = new Gtk.Window (Gtk.WindowType.POPUP);
            window.set_size_request (INITIAL_WIDTH, INITIAL_HEIGHT);
            drawing_panel = new DrawingPanel (config);

            window.add (drawing_panel);

            window.notify["visible"].connect ((s, p) => {
                    send_visible_changed (conn);
                });

            placement = new IBus.WindowPlacement ();

            register_drawing (conn);

            drawing_panel.stroke_added.connect ((coordinates) => {
                    var path = bus.current_input_context ();
                    if (path != null) {
                        var context =
                            IBus.InputContext.get_input_context (path, conn);
                        context.process_hand_writing_event (coordinates);
                    }
                });

            drawing_panel.stroke_removed.connect ((n_strokes) => {
                    var path = bus.current_input_context ();
                    if (path != null) {
                        var context =
                            IBus.InputContext.get_input_context (path, conn);
                        context.cancel_hand_writing (n_strokes);
                    }
                });
        }

        void send_visible_changed (DBusConnection conn) {
            var changed = new VariantBuilder (VariantType.ARRAY);
            var invalidated = new VariantBuilder (new VariantType ("as"));
            changed.add ("{sv}",
                         "visible",
                         new Variant.boolean (window.visible));
            try {
                conn.emit_signal (
                    null,
                    "/org/freedesktop/IBus/Drawing",
                    "org.freedesktop.DBus.Properties",
                    "PropertiesChanged",
                    new Variant ("(sa{sv}as)",
                                 "org.freedesktop.IBus.Drawing",
                                 changed,
                                 invalidated));
            } catch (Error e) {
                stderr.printf ("%s\n", e.message);
            }
        }

        public override void show () {
            window.show_all ();
            placement.restore_location (window);
        }

        public override void hide () {
            if (window != null) {
                window.hide ();
            }
        }

        public override void set_cursor_location (int x, int y, int w, int h) {
            placement.set_location_from_cursor (window, x, y, w, h);
        }
    }
}