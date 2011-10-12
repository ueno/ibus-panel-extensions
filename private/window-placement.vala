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
	public class WindowPlacement : Object {
		private int saved_x;
		private int saved_y;

		public void restore_location (Gtk.Window window) {
			if (saved_x >= 0 && saved_y >= 0)
				window.move (saved_x, saved_y);
		}

		public void set_location_from_cursor (Gtk.Window window, int x, int y, int w, int h) {
			// TODO: More precise placement calculation
			Gtk.Allocation allocation;
			window.get_allocation (out allocation);

			int rx, ry, rw, rh;
			var root_window = Gdk.get_default_root_window ();
			root_window.get_geometry (out rx, out ry, out rw, out rh);

			if (x + allocation.width > rw)
				x -= allocation.width;
			x = int.max (x, rx);
        
			if (y + h + allocation.height > rh)
				y -= allocation.height;
			else
				y += h;
			y = int.max (y, ry);

			if ((x != saved_x || y != saved_y)) {
				window.move (x, y);
				saved_x = x;
				saved_y = y;
			}
		}
	}
}
