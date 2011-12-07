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
namespace IBusDrawing {
	public class Point {
		public double x;
		public double y;
		public Point (double x, double y) {
			this.x = x;
			this.y = y;
		}
	}

	public class Path {
		public List<Point> points = null;
	}

	public class DrawingArea : Gtk.DrawingArea {
		List<Path> paths = new List<Path> ();
		Path current_path = null;

		public DrawingArea () {
			add_events (Gdk.EventMask.BUTTON_PRESS_MASK |
						Gdk.EventMask.BUTTON_RELEASE_MASK |
						Gdk.EventMask.BUTTON_MOTION_MASK);
		}

		public signal void stroke_added (double[] coordinates);
		public signal void stroke_removed (uint n_strokes);

		public override bool button_press_event (Gdk.EventButton event) {
			current_path = new Path ();
			current_path.points.append (new Point (event.x, event.y));
			paths.append (current_path);
			return false;
		}

		public override bool button_release_event (Gdk.EventButton event) {
			// rescale coordinates against allocation box
			Gtk.Allocation allocation;
			get_allocation (out allocation);
			double[] coordinates = new double[current_path.points.length () * 2];
			// coordinates are folded in the form {x1, y1, x2, y2, ...} 
			int i = 0;
			foreach (var point in current_path.points) {
				coordinates[i] = point.x / (double)allocation.width;
				coordinates[i + 1] = point.y / (double)allocation.height;
			}
			stroke_added (coordinates);

			current_path = null;
			return false;
		}

		public override bool motion_notify_event (Gdk.EventMotion event) {
			Gtk.Allocation allocation;
			get_allocation (out allocation);

			double x = event.x.clamp ((double)allocation.x,
									  (double)(allocation.x + allocation.width));
			double y = event.y.clamp ((double)allocation.y,
									  (double)(allocation.y + allocation.height));
			Point last = current_path.points.last ().data;
			double dx = x - last.x;
			double dy = y - last.y;
			if (Math.sqrt (dx * dx + dy * dy) > 10.0) {
				current_path.points.append (new Point (x, y));
				queue_draw ();
			}
			return false;
		}

		public override bool draw (Cairo.Context cr) {
			//Gtk.StyleContext style = get_style_context ();
			//Gdk.RGBA background = style.get_background_color (0);
			Gdk.RGBA background = Gdk.RGBA () {
				red = 1.0, green = 1.0, blue = 1.0, alpha = 1.0
			};
			Gdk.cairo_set_source_rgba (cr, background);
			cr.paint ();

			//color = style.get_color (0);
			Gdk.RGBA foreground = Gdk.RGBA () {
				red = 0.0, green = 0.0, blue = 0.0, alpha = 1.0
			};
			Gdk.cairo_set_source_rgba (cr, foreground);
			foreach (var path in paths) {
				Point first = path.points.first ().data;
				cr.move_to (first.x, first.y);
				foreach (var point in path.points.next) {
					cr.line_to (point.x, point.y);
				}
				cr.stroke ();
			}
			return false;
		}

		public void clear () {
			paths = null;
			current_path = null;
			queue_draw ();
			stroke_removed (0);
		}

		public void undo () {
			if (paths != null) {
				unowned List<Path> last = paths.last ();
				unowned List<Path> prev = last.prev;
				paths.delete_link (last);
				if (current_path != null) {
					if (prev != null)
						current_path = prev.data;
					else
						current_path = null;
				}
				queue_draw ();
				stroke_removed (1);
			}
		}
	}

	public class DrawingPanel : Gtk.Box {
		public signal void stroke_added (double[] coordinates);
		public signal void stroke_removed (uint n_strokes);

		public DrawingPanel (IBus.Config config) {
			var paned = new Gtk.VBox (false, 0);

			var area = new DrawingArea ();
			paned.pack_start (area, true, true, 0);

			var bbox = new Gtk.HButtonBox ();
			bbox.set_homogeneous (false);
			var undo_button = new Gtk.ToolButton.from_stock (Gtk.Stock.UNDO);
			undo_button.clicked.connect (() => { area.undo (); });
			bbox.pack_end (undo_button, false, false, 0);
			var clear_button = new Gtk.ToolButton.from_stock (Gtk.Stock.CLEAR);
			clear_button.clicked.connect (() => { area.clear (); });
			bbox.pack_end (clear_button, false, false, 0);
			paned.pack_end (bbox, false, false, 0);

			area.stroke_added.connect ((coordinates) => {
					stroke_added (coordinates);
				});
			area.stroke_removed.connect ((n_strokes) => {
					stroke_removed (n_strokes);
				});
			this.pack_start (paned, true, true, 0);
		}
	}
}