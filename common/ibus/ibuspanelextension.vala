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

[CCode(cheader_filename="ibus/ibuspanelextensions.h")]
namespace IBus {
    /**
     * SECTION:ibuspanelextensions
	 * @title: Base types
     * @short_description: Base types used in ibus-panel-extensions
     */
	public abstract class PanelExtension : Object {
        /**
         * IBusPanelExtension:visible:
         *
         * Whether the charmap window is visible.
         */
        public bool visible { get; protected set; }

        /**
         * ibus_panel_extension_show:
         * @self: an #IBusPanelExtension
         *
         * Show the window of this extension.
         */
        public abstract void show ();

        /**
         * ibus_panel_extension_hide:
         * @self: an #IBusPanelExtension
         *
         * Hide the window of this extension.
         */
		public abstract void hide ();

        /**
         * ibus_panel_extension_set_cursor_location:
         * @self: an #IBusPanelExtension
         * @x: X coordinate of the cursor
         * @y: Y coordinate of the cursor
         * @w: width of the cursor
         * @h: height of the cursor
         *
         * Tell the cursor location of the current IBus input context
         * to the service.
         */
		public abstract void set_cursor_location (int x, int y, int w, int h);
	}
}