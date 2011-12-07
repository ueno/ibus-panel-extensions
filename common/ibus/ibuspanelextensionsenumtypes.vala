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
    public enum MovementStep {
        /**
         * Move forward or back by graphemes
         */
        LOGICAL_POSITIONS = 0,

        /**
         * Move left or right by graphemes
         */
        VISUAL_POSITIONS,

        /**
         * Move forward or back by words
         */
        WORDS,

        /**
         * Move up or down lines (wrapped lines)
         */
        DISPLAY_LINES,

        /**
         * Move to either end of a line
         */
        DISPLAY_LINE_ENDS,

        /**
         * Move up or down paragraphs (newline-ended lines)
         */
        PARAGRAPHS,

        /**
         * Move to either end of a paragraph
         */
        PARAGRAPH_ENDS,

        /**
         * Move by pages
         */
        PAGES,

        /**
         * Move to ends of the buffer
         */
        BUFFER_ENDS,

        /**
         * Move horizontally by pages
         */
        HORIZONTAL_PAGES
    }
}
