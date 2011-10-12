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

namespace IBusCharmap {
    // translated from keycapturedialog.py in ibus-hangul
    class KeyCaptureDialog {
        private Gtk.MessageDialog dialog;
        private StringBuilder keystr = new StringBuilder ();
		public string key {
			get {
				return keystr.str;
			}
		}

        public KeyCaptureDialog (string title, Gtk.Window? parent) {
            dialog = new Gtk.MessageDialog (parent,
                                            Gtk.DialogFlags.MODAL,
                                            Gtk.MessageType.INFO,
                                            Gtk.ButtonsType.OK_CANCEL,
                                            "");
            dialog.set_markup (
                Markup.printf_escaped (
					"Press any key which you want to use as %s. " +
					"The key you pressed is displayed below.\n" +
					"If you want to use it, click \"Ok\" or click \"Cancel\"",
					title));
            dialog.format_secondary_markup (" ");
            dialog.key_press_event.connect (on_keypress);
        }

		public void destroy () {
			dialog.destroy ();
		}

        public int run () {
            return dialog.run ();
        }

        private bool on_keypress (Gtk.Widget widget, Gdk.EventKey event) {
            keystr.erase ();
            if ((event.state & Gdk.ModifierType.CONTROL_MASK) != 0)
                keystr.append ("Control+");
            if ((event.state & Gdk.ModifierType.MOD1_MASK) != 0)
                keystr.append ("Alt+");
            if ((event.state & Gdk.ModifierType.SHIFT_MASK) != 0)
                keystr.append ("Shift+");
            keystr.append (Gdk.keyval_name (event.keyval));
            dialog.format_secondary_markup (
                "<span size=\"large\" weight=\"bold\">%s</span>".
				printf (keystr.str));
			return true;
        }
    }
}
