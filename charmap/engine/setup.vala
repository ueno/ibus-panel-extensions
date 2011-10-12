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
    class Setup : Object {
        private Gtk.Dialog dialog;
        private Gtk.CheckButton use_system_font_checkbutton;
        private Gtk.FontButton fontbutton;
        private Gtk.SpinButton max_matches_spinbutton;
        private Gtk.Entry select_chapter_entry;
        private Gtk.Button select_chapter_button;
        private Gtk.Entry commit_character_entry;
        private Gtk.Button commit_character_button;
        private IBus.Config config;

        public bool use_system_font {
            get {
                return use_system_font_checkbutton.get_active ();
            }
            set {
                use_system_font_checkbutton.set_active (value);
            }
        }

        public string font {
            get {
                return fontbutton.get_font_name ();
            }
            set {
                fontbutton.set_font_name (value);
            }
        }

        public int max_matches {
            get {
                return (int)max_matches_spinbutton.value;
            }
            set {
                max_matches_spinbutton.set_value (value);
            }
        }

        public string select_chapter_shortcut {
            get {
                return select_chapter_entry.get_text ();
            }
            set {
                select_chapter_entry.set_text (value);
            }
        }

        public string commit_character_shortcut {
            get {
                return commit_character_entry.get_text ();
            }
            set {
                commit_character_entry.set_text (value);
            }
        }

        public Setup (IBus.Config config) {
            this.config = config;
            var builder = new Gtk.Builder ();
            builder.set_translation_domain ("ibus-charmap");
            builder.add_from_file (
                Path.build_filename (Config.SETUPDIR,
                                     "ibus-charmap-preferences.ui"));

            // Map widgets defined in ibus-charmap-preferences.ui into
            // instance variables.
            var object = builder.get_object ("dialog");
            dialog = (Gtk.Dialog)object;
            object = builder.get_object ("fontbutton");
            fontbutton = (Gtk.FontButton)object;
            object = builder.get_object ("use_system_font_checkbutton");
            use_system_font_checkbutton = (Gtk.CheckButton)object;
            object = builder.get_object ("max_matches_spinbutton");
            max_matches_spinbutton = (Gtk.SpinButton)object;
            object = builder.get_object ("select_chapter_entry");
            select_chapter_entry = (Gtk.Entry)object;
            object = builder.get_object ("select_chapter_button");
            select_chapter_button = (Gtk.Button)object;
            object = builder.get_object ("commit_character_entry");
            commit_character_entry = (Gtk.Entry)object;
            object = builder.get_object ("commit_character_button");
            commit_character_button = (Gtk.Button)object;

            // set signal handlers
            use_system_font_checkbutton.toggled.connect ((checkbutton) => {
                    fontbutton.set_sensitive (!checkbutton.active);
                });
            select_chapter_button.clicked.connect ((button) => {
                    var dialog = new KeyCaptureDialog ("chapter selection",
                                                       dialog);
                    if (dialog.run () == Gtk.ResponseType.OK)
                        select_chapter_entry.set_text (dialog.key);
                    dialog.destroy ();
                });
            commit_character_button.clicked.connect ((button) => {
                    var dialog = new KeyCaptureDialog ("commit character",
                                                       dialog);
                    if (dialog.run () == Gtk.ResponseType.OK)
                        commit_character_entry.set_text (dialog.key);
                    dialog.destroy ();
                });

            Variant? value;

            value = config.get_value ("charmap", "use_system_font");
            if (value != null) {
                use_system_font = value.get_boolean ();
            } else {
                use_system_font = true;
            }
            value = config.get_value ("charmap", "font");
            if (value != null) {
                font = value.get_string ();
            } else {
                font = "Sans 12";
            }
            value = config.get_value ("engines/charmap",
                                      "max_matches");
            if (value != null) {
                max_matches = value.get_int32 ();
            } else {
                max_matches = 100;
            }
            value = config.get_value ("engines/charmap",
                                      "select_chapter_shortcut");
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
        }

        private void save_settings () {
            use_system_font = use_system_font_checkbutton.active;
            font = fontbutton.font_name;
            max_matches = (int)max_matches_spinbutton.value;
            select_chapter_shortcut = select_chapter_entry.get_text ();
            commit_character_shortcut = commit_character_entry.get_text ();
            config.set_value ("charmap",
                              "use_system_font",
                              new Variant.boolean (use_system_font));
            config.set_value ("charmap",
                              "font",
                              new Variant.string (font));
            config.set_value ("engines/charmap",
                              "max_matches",
                              new Variant.int32 (max_matches));
            config.set_value ("engines/charmap",
                              "select_chapter_shortcut",
                              new Variant.string (select_chapter_shortcut));
            config.set_value ("engines/charmap",
                              "commit_character_shortcut",
                              new Variant.string (commit_character_shortcut));
        }

        public void run () {
            dialog.run ();
            save_settings ();
        }
    }
}
