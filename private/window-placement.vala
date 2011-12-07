namespace IBus {
	public class WindowPlacement : Object {
		int saved_x;
		int saved_y;

		public void restore_location (Gtk.Window window) {
			if (saved_x >= 0 && saved_y >= 0)
				window.move (saved_x, saved_y);
		}

		public void set_location_from_cursor (Gtk.Window window,
											  int x,
											  int y,
											  int w,
											  int h)
		{
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
