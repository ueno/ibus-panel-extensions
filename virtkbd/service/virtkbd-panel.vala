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
namespace IBusVirtkbd {
    const string VIRTKBD_DOMAIN = "virtkbd";
    const string DEFAULT_KEYBOARD = "us";

    class VirtkbdPanel : Gtk.Box {
        static const int INITIAL_WIDTH = 640;
        static const int INITIAL_HEIGHT = 430;

        Gtk.Box keyboard_box;
        Gtk.Widget keyboard_widget;
        Gtk.ListStore store;
        Gtk.ComboBox combobox;

        public signal void text_activated (string text);

        void on_key_released (Eek.Keyboard keyboard, Eek.Key key) {
            var symbol = key.get_symbol_with_fallback (0, 0);
            if (symbol is Eek.Keysym) {
                var keyval = ((Eek.Keysym)symbol).get_xkeysym ();
                if (keyval > 0) {
                    unichar uc = (unichar)Gdk.keyval_to_unicode (keyval);
                    text_activated (uc.to_string ());
                }
            } else if (symbol is Eek.Text) {
                text_activated (((Eek.Text)symbol).get_text ());
            }
        }

        string[] list_keyboards () {
            File dir = File.new_for_path (Config.KEYBOARDDIR);
            FileEnumerator enumerator =
                dir.enumerate_children ("standard::*",
                                        FileQueryInfoFlags.NONE);
            Gee.ArrayList<string> keyboards = new Gee.ArrayList<string> ();
            try {
                FileInfo info;
                while ((info = enumerator.next_file ()) != null) {
                    string name = info.get_name ();
                    if (name.has_suffix (".xml")) {
                        keyboards.add (name.substring (0, name.length - 4));
                    }
                }
            } catch (Error e) {
                stderr.printf ("Can't enumerate files under %s: %s",
                               Config.KEYBOARDDIR,
                               e.message);
            }
            return keyboards.to_array ();
        }

        void set_keyboard_widget (string name) {
            var path = "%s/%s.xml".printf (Config.KEYBOARDDIR, name);
            var file = File.new_for_path (path);
            Eek.Layout layout;
            try {
                var input = file.read ();
                layout = new Eek.XmlLayout (input);
            } catch (IOError e) {
                stderr.printf ("Can't load keyboard %s: %s\n",
                               name,
                               e.message);
                return;
            }
            var keyboard = new Eek.Keyboard (layout,
                                             INITIAL_WIDTH,
                                             INITIAL_HEIGHT);
            keyboard.set_modifier_behavior (Eek.ModifierBehavior.LATCH);
            keyboard.key_released.connect (on_key_released);

            if (keyboard_widget != null) {
                keyboard_box.remove (keyboard_widget);
            }

            keyboard_widget = new EekGtk.Keyboard (keyboard);
            Eek.Bounds bounds;
            keyboard.get_bounds (out bounds);
            keyboard_widget.set_size_request ((int)bounds.width,
                                              (int)bounds.height);
            keyboard_box.add (keyboard_widget);
            keyboard_box.show_all ();
        }

        void on_combobox_changed (Gtk.ComboBox combobox) {
            Gtk.TreeModel model;
            Gtk.TreeIter iter;
            string name;

            model = combobox.get_model ();
            combobox.get_active_iter (out iter);
            model.get (iter, 0, out name, -1);

            set_keyboard_widget (name);
        }

        public void select_keyboard (string name) {
            var model = combobox.get_model ();
            Gtk.TreeIter iter;
            model.get_iter_first (out iter);
            do {
                string _name;
                model.get (iter, 0, out _name, -1);
                if (_name == name) {
                    combobox.set_active_iter (iter);
                    break;
                }
            } while (model.iter_next (ref iter));
        }

        public VirtkbdPanel (IBus.Config config) {
            var paned = new Gtk.VBox (false, 0);

            string[] keyboards = list_keyboards ();
            Gtk.TreeIter iter;
            store = new Gtk.ListStore (1, typeof (string));
            foreach (var name in keyboards) {
                store.append (out iter);
                store.set (iter, 0, name, -1);
            }

            combobox = new Gtk.ComboBox.with_model (store);
            var renderer = new Gtk.CellRendererText ();
            combobox.pack_start (renderer, true);
            combobox.set_attributes (renderer, "text", 0);
            combobox.changed.connect (on_combobox_changed);

            paned.pack_start (combobox, false, false, 0);

            keyboard_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            select_keyboard (DEFAULT_KEYBOARD);

            paned.pack_end (keyboard_box, true, true, 0);

            paned.show_all ();

            this.pack_start (paned, true, true, 0);
        }
    }
}
