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
    private const string CHARMAP_DOMAIN = "charmap";

    class ChapterCellRenderer : Gtk.CellRendererText {
        private string _untranslated;
        public string untranslated {
            get {
                return _untranslated;
            }
            set {
                _untranslated = value;
                text = dgettext (CHARMAP_DOMAIN, _untranslated);
            }
        }
    }

    class CharmapPanel : Gtk.Box, IBus.Selectable {
        private Gtk.ComboBox chapters;
        private Gucharmap.Chartable chartable;
        private Gtk.Statusbar statusbar;
        private uint statusbar_context_id;

        private bool _use_system_font;
        public bool use_system_font {
            get {
                return _use_system_font;
            }
            set {
                _use_system_font = value;
                set_chartable_font ();
            }
        }

        private string _font;
        public string font {
            get {
                return _font;
            }
            set {
                _font = value;
                set_chartable_font ();
            }
        }

        public void move_cursor (IBus.MovementStep step, int count) {
            chartable.move_cursor ((Gtk.MovementStep)step, count);
        }

        public void popup_chapters () {
            chapters.popup ();
        }

        public void activate_selected () {
            var uc = chartable.get_active_character ();
            select_character (uc);
            character_activated (uc);
        }

        public void select_character (unichar uc) {
            var model = (Gucharmap.ChaptersModel)chapters.get_model ();
            Gtk.TreeIter iter;
            if (model.character_to_iter (uc, out iter)) {
                chapters.set_active_iter (iter);
                chartable.set_active_character (uc);
            }
        }

        private void on_chapter_changed (Gtk.ComboBox combo) {
            Gtk.TreeIter iter;
            if (combo.get_active_iter (out iter)) {
                var model = (Gucharmap.ChaptersModel)chapters.get_model ();
                var codepoint_list = model.get_codepoint_list (iter);
                chartable.set_codepoint_list (codepoint_list);
            }
        }

        private void on_hide (Gtk.Widget widget) {
            // Toggling zoom enabled will cause hiding the zoom window.
            if (chartable.get_zoom_enabled ()) {
                chartable.set_zoom_enabled (false);
                chartable.set_zoom_enabled (true);
            }
        }

        private void on_chartable_notify_active_character (Object source,
                                                           ParamSpec param)
        {
            statusbar.remove_all (statusbar_context_id);
            unichar uc = chartable.get_active_character ();
            string name = Gucharmap.get_unicode_name (uc);
            statusbar.push (statusbar_context_id, "U+%X %s".printf (uc, name));
        }

        private void set_chartable_font () {
            Pango.FontDescription font_desc = null;
            if (use_system_font) {
                // Use normal size GTK font
                var style_context = chartable.get_style_context ();
                font_desc = style_context.get_font (Gtk.StateFlags.NORMAL);
            } else if (font != null)
                // maybe font is not set when the first time
                // use-system-font is read
                font_desc = Pango.FontDescription.from_string (font);
            if (font_desc != null)
                chartable.set_font_desc (font_desc);
        }

        public CharmapPanel (IBus.Config config) {
            var paned = new Gtk.VBox (false, 0);

            // Chapters combo box
            //var model = new Gucharmap.ScriptChaptersModel ();
            var model = new Gucharmap.BlockChaptersModel ();
            model.set_sort_column_id (1, Gtk.SortType.ASCENDING);
            chapters = new Gtk.ComboBox.with_model (model);
            chapters.changed.connect (on_chapter_changed);

            // Translate chapter names in Charmap translation domain
            var renderer = new ChapterCellRenderer ();
            chapters.pack_start (renderer, true);
            chapters.set_attributes (renderer, "untranslated", 0);
            chapters.set_vexpand (false);

            paned.pack_start (chapters, false, false, 0);

            // Statusbar
            statusbar = new Gtk.Statusbar ();
            statusbar_context_id = statusbar.get_context_id ("active char");
            paned.pack_end (statusbar, false, false, 0);
            
            // Chartable
            var scrolled_window = new Gtk.ScrolledWindow (null, null);
            scrolled_window.set_policy (Gtk.PolicyType.NEVER,
                                        Gtk.PolicyType.AUTOMATIC);
            scrolled_window.set_shadow_type(Gtk.ShadowType.ETCHED_IN);

            chartable = new Gucharmap.Chartable ();
            // Enable zooming for the case that the font is too small
            chartable.set_zoom_enabled (true);
            chartable.activate.connect (activate_selected);
            chartable.notify["active-character"].connect (
                on_chartable_notify_active_character);
            this.hide.connect (on_hide);

            scrolled_window.add (chartable);
            paned.pack_end (scrolled_window, true, true, 0);

            var uc = Gucharmap.unicode_get_locale_character ();
            select_character (uc);

            paned.show_all ();

            this.pack_start (paned, true, true, 0);

            Variant? value;
            value = config.get_value ("charmap", "use_system_font");
            if (value != null) {
                _use_system_font = value.get_boolean ();
            } else {
                _use_system_font = true;
            }
            value = config.get_value ("charmap", "font");
            if (value != null) {
                _font = value.get_string ();
            } else {
                _font = "Sans 12";
            }
        }
    }
}
