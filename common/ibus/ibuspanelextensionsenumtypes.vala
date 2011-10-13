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
     * IBusMovementStep:
     * @IBUS_MOVEMENT_STEP_LOGICAL_POSITIONS: Move forward or back by graphemes
     * @IBUS_MOVEMENT_STEP_VISUAL_POSITIONS:  Move left or right by graphemes
     * @IBUS_MOVEMENT_STEP_WORDS:             Move forward or back by words
     * @IBUS_MOVEMENT_STEP_DISPLAY_LINES:     Move up or down lines (wrapped lines)
     * @IBUS_MOVEMENT_STEP_DISPLAY_LINE_ENDS: Move to either end of a line
     * @IBUS_MOVEMENT_STEP_PARAGRAPHS:        Move up or down paragraphs (newline-ended li
     nes)
     * @IBUS_MOVEMENT_STEP_PARAGRAPH_ENDS:    Move to either end of a paragraph
     * @IBUS_MOVEMENT_STEP_PAGES:             Move by pages
     * @IBUS_MOVEMENT_STEP_BUFFER_ENDS:       Move to ends of the buffer
     * @IBUS_MOVEMENT_STEP_HORIZONTAL_PAGES:  Move horizontally by pages
     */
    public enum MovementStep {
        LOGICAL_POSITIONS = 0,
        VISUAL_POSITIONS,
        WORDS,
        DISPLAY_LINES,
        DISPLAY_LINE_ENDS,
        PARAGRAPHS,
        PARAGRAPH_ENDS,
        PAGES,
        BUFFER_ENDS,
        HORIZONTAL_PAGES
    }
}
