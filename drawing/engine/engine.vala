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
    class Engine : IBus.Engine {
        private StringBuilder preedit = new StringBuilder ();
        private IBus.Drawing drawing;
        internal static IBus.Config config;

        public override void enable () {
            drawing.show ();
            base.enable ();
        }

        public override void disable () {
            drawing.hide ();
            base.disable ();
        }

        public override void focus_in () {
            drawing.show ();
            base.focus_in ();
        }

        public override void focus_out () {
            drawing.hide ();
            base.focus_out ();
        }

        public override void set_cursor_location (int x, int y, int w, int h) {
            drawing.set_cursor_location (x, y, w, h);
            base.set_cursor_location (x, y, w, h);
        }

        public override void destroy () {
            drawing.hide ();
            base.destroy ();
        }

        construct {
            try {
                DBusConnection conn = get_connection ();
                drawing = new IBus.Drawing (conn);
            } catch (IOError e) {
                stderr.printf ("%s\n", e.message);
            }
        }
    }
}
