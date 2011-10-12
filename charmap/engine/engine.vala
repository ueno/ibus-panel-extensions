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
    class Engine : IBus.Engine {
        string select_chapter_shortcut;
        string commit_character_shortcut;
        uint max_matches;

        private IBus.PropList prop_list;

        private StringBuilder preedit = new StringBuilder ();
        private IBus.Charmap charmap;
        internal static IBus.Config config;

        struct MoveBinding {
            uint keyval;
            uint state;
            IBus.MovementStep step;
            int count;
        }

        private const MoveBinding[] move_bindings = {
            { IBus.Up, 0, IBus.MovementStep.DISPLAY_LINES, -1 },
            { IBus.KP_Up, 0, IBus.MovementStep.DISPLAY_LINES, -1 },
            { IBus.Down, 0, IBus.MovementStep.DISPLAY_LINES, 1 },
            { IBus.KP_Down, 0, IBus.MovementStep.DISPLAY_LINES, 1 },
            { IBus.Home, 0, IBus.MovementStep.BUFFER_ENDS, -1 },
            { IBus.KP_Home, 0, IBus.MovementStep.BUFFER_ENDS, -1 },
            { IBus.End, 0, IBus.MovementStep.BUFFER_ENDS, 1 },
            { IBus.KP_End, 0, IBus.MovementStep.BUFFER_ENDS, 1 },
            { IBus.Page_Up, 0, IBus.MovementStep.PAGES, -1 },
            { IBus.KP_Page_Up, 0, IBus.MovementStep.PAGES, -1 },
            { IBus.Page_Down, 0, IBus.MovementStep.PAGES, 1 },
            { IBus.KP_Page_Down, 0, IBus.MovementStep.PAGES, 1 },
            { IBus.Left, 0, IBus.MovementStep.VISUAL_POSITIONS, -1 },
            { IBus.KP_Left, 0, IBus.MovementStep.VISUAL_POSITIONS, -1 },
            { IBus.Right, 0, IBus.MovementStep.VISUAL_POSITIONS, 1 },
            { IBus.KP_Right, 0, IBus.MovementStep.VISUAL_POSITIONS, 1 }
        };

        public override void enable () {
            charmap.show ();
            base.enable ();
        }

        public override void disable () {
            charmap.hide ();
            base.disable ();
        }

        public override void focus_in () {
            register_properties (prop_list);
            charmap.show ();
            base.focus_in ();
        }

        public override void focus_out () {
            charmap.hide ();
            base.focus_out ();
        }

        public override void property_activate (string prop_name,
                                                uint prop_state)
        {
            if (prop_name == "setup")
                Process.spawn_command_line_async (
                    Path.build_filename (Config.LIBEXECDIR,
                                         "ibus-setup-charmap"));
        }

        private static bool isascii (uint keyval) {
            return 0x20 <= keyval && keyval <= 0x7E;
        }

        private bool parse_keystr (string keystr,
                                   out uint keyval,
                                   out uint state)
        {
            var buffer = new StringBuilder (keystr);
            state = 0;
            if (buffer.str.has_prefix ("Control+")) {
                state |= IBus.ModifierType.CONTROL_MASK;
                buffer.erase (0, "Control+".length);
            }
            if (buffer.str.has_prefix ("Alt+")) {
                state |= IBus.ModifierType.MOD1_MASK;
                buffer.erase (0, "Alt+".length);
            }
            if (buffer.str.has_prefix ("Shift+")) {
                state |= IBus.ModifierType.SHIFT_MASK;
                buffer.erase (0, "Shift+".length);
            }
            keyval = IBus.keyval_from_name (buffer.str);
            return true;
        }

        private void move_cursor (IBus.MovementStep step, int count) {
            charmap.move_cursor (step, count);
        }

        public override bool process_key_event (uint keyval,
                                                uint keycode,
                                                uint state)
        {
            uint shortcut_keyval;
            uint shortcut_state;

            // ignore release event
            if ((IBus.ModifierType.RELEASE_MASK & state) != 0)
                return false;

            // process chartable move bindings
            foreach (var binding in move_bindings) {
                if (binding.keyval == keyval && binding.state == state) {
                    move_cursor (binding.step, binding.count);
                    return true;
                }
            }

            // process return - activate current character in chartable
            parse_keystr (commit_character_shortcut,
                          out shortcut_keyval,
                          out shortcut_state);
            if (keyval == shortcut_keyval && state == shortcut_state) {
                charmap.activate_selected ();
                return true;
            }

            // process alt+Down to popup the chapters combobox
            parse_keystr (select_chapter_shortcut,
                          out shortcut_keyval,
                          out shortcut_state);
            if ((shortcut_state & state) != 0 &&
                keyval == shortcut_keyval) {
                charmap.popup_chapters ();
                return true;
            }

            if (state == 0 && isascii (keyval)) {
                char c = (char)keyval;
                preedit.append_c (c);
                charmap.start_search (preedit.str, max_matches);
                return true;
            }

            if (preedit.len > 0) {
                if (keyval == IBus.BackSpace) {
                    preedit.truncate (preedit.len - 1);
                    if (preedit.len == 0) {
                        charmap.cancel_search ();
                        charmap.show ();
                    } else {
                        charmap.start_search (preedit.str, max_matches);
                    }

                    return true;
                }

                if (keyval == IBus.Escape) {
                    preedit.erase ();
                    charmap.cancel_search ();
                    charmap.show ();
                    return true;
                }
            }

            return true;
        }

        public override void set_cursor_location (int x, int y, int w, int h) {
            charmap.set_cursor_location (x, y, w, h);
            base.set_cursor_location (x, y, w, h);
        }

        public override void destroy () {
            charmap.hide ();
            base.destroy ();
        }

        private void on_character_activated (unichar uc) {
            if (uc > 0)
                commit_text (new IBus.Text.from_string (uc.to_string ()));
        }

        construct {
            try {
                DBusConnection conn = get_connection ();
                charmap = new IBus.Charmap (conn);
                charmap.character_activated.connect (on_character_activated);
            } catch (IOError e) {
                stderr.printf ("%s\n", e.message);
            }

            prop_list = new IBus.PropList ();
            var prop = new IBus.Property ("setup",
                                          IBus.PropType.NORMAL,
                                          new IBus.Text.from_string ("Setup"),
                                          "gtk-preferences",
                                          new IBus.Text.from_string ("Configure Charmap engine"),
                                          true,
                                          true,
                                          IBus.PropState.UNCHECKED,
                                          new IBus.PropList ()); // dummy
            prop_list.append (prop);

            Variant? value;
            value = config.get_value ("engines/charmap",
                                      "selet_chapter_shortcut");
            if (value != null) {
                select_chapter_shortcut = value.get_string ();
            } else {
                select_chapter_shortcut = "Alt+Down";
            }

            value = config.get_value ("engines/charmap",
                                      "commit_character_shortcut");
            if (value != null) {
                commit_character_shortcut = value.get_string ();
            } else {
                commit_character_shortcut = "Return";
            }

            value = config.get_value ("engines/charmap",
                                      "max_matches");
            if (value != null) {
                max_matches = value.get_int32 ();
            } else {
                max_matches = 100;
            }
        }
    }
}
