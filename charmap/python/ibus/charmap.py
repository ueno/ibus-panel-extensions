# Copyright (C) 2011 Daiki Ueno <ueno@unixuser.org>
# Copyright (C) 2011 Red Hat, Inc.

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see
# <http://www.gnu.org/licenses/>.

import dbus
import dbus.mainloop.glib
import gobject
import ibus

class Charmap(gobject.GObject):
    __gtype_name__ = "PyIBusCharmap"
    __gsignals__ = {
        'character-activated': (
            gobject.SIGNAL_RUN_LAST,
            gobject.TYPE_NONE,
            (gobject.TYPE_UCHAR,))
        }

    def __init__(self, bus):
        super(Charmap, self).__init__()
        self.__dbusconn = bus.get_dbusconn()
        _charmap = self.__dbusconn.get_object("org.freedesktop.IBus.Charmap",
                                              "/org/freedesktop/IBus/Charmap")
        self.__charmap = dbus.Interface(_charmap,
                                        dbus_interface="org.freedesktop.DBus")
        self.__charmap.connect_to_signal("CharacterActivated",
                                         self.__character_activated_cb)

    def __character_activated_cb(self, *args):
        uc = args[0]
        self.emit("character-activated", uc)

    def show(self):
        self.__charmap.Show()

    def hide(self):
        self.__charmap.Hide()

    def set_cursor_location(self, x, y, w, h):
        x = dbus.Int32(x)
        y = dbus.Int32(y)
        w = dbus.Int32(w)
        h = dbus.Int32(h)
        self.__charmap.SetCursorLocation(x, y, w, h)

    def move_cursor(self, step, count):
        step = dbus.Int32(step)
        count = dbus.Int32(step)
        self.__charmap.MoveCursor(step, count)
        
    def select_character(self, uc):
        uc = dbus.UInt32(uc)
        self.__charmap.SelectCharacter(uc)

    def activate_selected(self):
        self.__charmap.ActivateSelected()

    def popup_chapters(self):
        self.__charmap.PopupChapters()

    def start_search(self, name, max_matches):
        name = dbus.String(name)
        max_matches = dbus.UInt32(max_matches)
        self.__charmap.StartSearch(name, max_matches)

    def cancel_search(self):
        self.__charmap.CancelSearch()
