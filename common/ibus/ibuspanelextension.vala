/* 
 * Copyright (C) 2011 Daiki Ueno <ueno@unixuser.org>
 * Copyright (C) 2011 Red Hat, Inc.
 * 
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public License
 * as published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 * 
 * This library is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
 * 02110-1301 USA
 */
[CCode(cheader_filename="ibus/ibuspanelextensions.h")]
namespace IBus {
    /**
     * A base abstract class of panel extension service proxy.
     */
	public abstract class PanelExtension : Object {
        /**
         * Whether the charmap window is visible.
         */
        public bool visible { get; protected set; }

        /**
         * Request to show the window of this extension.
         */
        public abstract void show ();

        /**
         * Request to hide the window of this extension.
         */
		public abstract void hide ();

        /**
         * Tell the service the current cursor location.
         *
         * @param x X coordinate of the cursor
         * @param y Y coordinate of the cursor
         * @param w width of the cursor
         * @param h height of the cursor
         *
         */
		public abstract void set_cursor_location (int x, int y, int w, int h);
	}
}