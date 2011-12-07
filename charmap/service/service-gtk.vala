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
namespace IBusCharmap {
    public class GtkService : Service {
        // const values
        const int INITIAL_WIDTH = 320;
        const int INITIAL_HEIGHT = 240;

        Gtk.Window window;
        IBus.WindowPlacement placement;

        Gtk.Container panel;
        CharmapPanel charmap_panel;
        SearchPanel search_panel;

        internal static IBus.Config config;

        public GtkService (DBusConnection conn) {
            window = new Gtk.Window (Gtk.WindowType.TOPLEVEL);
            window.set_size_request (INITIAL_WIDTH, INITIAL_HEIGHT);
            window.set_can_focus (false);
            window.set_accept_focus (false);
            window.set_keep_above (true);
            window.set_title (_("Character Map"));
            charmap_panel = new CharmapPanel (config);
            charmap_panel.character_activated.connect ((uc) => {
                    character_activated (uc);
                });

            search_panel = new SearchPanel ();
            search_panel.character_activated.connect ((uc) => {
                    cancel_search ();
                    charmap_panel.select_character (uc);
                    character_activated (uc);
                });

            panel = charmap_panel;
            window.add (panel);

            // Pass around "hide" signal to charmap panel, to tell
            // that the toplevel window is hidden - this is necessary
            // to clear zoom window (see CharmapPanel#on_hide()).
            window.hide.connect (() => charmap_panel.hide ());
            window.delete_event.connect (window.hide_on_delete);

            window.notify["visible"].connect ((s, p) => {
                    send_visible_changed (conn);
                });

            placement = new IBus.WindowPlacement ();

            register_charmap (conn);
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
                    "/org/freedesktop/IBus/Charmap",
                    "org.freedesktop.DBus.Properties",
                    "PropertiesChanged",
                    new Variant ("(sa{sv}as)",
                                 "org.freedesktop.IBus.Charmap",
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

        public override void move_cursor (IBus.MovementStep step, int count)
        {
            ((IBus.Selectable)panel).move_cursor (step, count);
        }

        public override void select_character (unichar uc) {
            if (panel == charmap_panel)
                charmap_panel.select_character (uc);
        }

        public override void activate_selected () {
            ((IBus.Selectable)panel).activate_selected ();
        }

        public override void popup_chapters () {
            if (panel == charmap_panel)
                charmap_panel.popup_chapters ();
        }

        public override void start_search (string name, uint max_matches) {
            search_panel.start_search (name, max_matches);
            window.remove (window.get_child ());
            panel = search_panel;
            window.add (panel);
            if (window.get_visible ())
                window.show_all ();
        }

        public override void cancel_search () {
            search_panel.cancel_search ();
            window.remove (window.get_child ());
            panel = charmap_panel;
            window.add (panel);
        }
    }
}
