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

class Virtkbd(gobject.GObject):
    __gtype_name__ = "PyIBusVirtkbd"
    __gsignals__ = {
        'text-activated': (
            gobject.SIGNAL_RUN_LAST,
            gobject.TYPE_NONE,
            (gobject.TYPE_STRING,))
        }

    def __init__(self, bus):
        super(Virtkbd, self).__init__()
        self.__dbusconn = bus.get_dbusconn()
        _virtkbd = self.__dbusconn.get_object("org.freedesktop.IBus.Virtkbd",
                                              "/org/freedesktop/IBus/Virtkbd")
        self.__virtkbd = dbus.Interface(_virtkbd,
                                        dbus_interface="org.freedesktop.DBus")
        self.__virtkbd.connect_to_signal("TextActivated",
                                         self.__text_activated_cb)

    def __text_activated_cb(self, *args):
        uc = args[0]
        self.emit("text-activated", uc)

    def show(self):
        self.__virtkbd.Show()

    def hide(self):
        self.__virtkbd.Hide()

    def set_cursor_location(self, x, y, w, h):
        x = dbus.Int32(x)
        y = dbus.Int32(y)
        w = dbus.Int32(w)
        h = dbus.Int32(h)
        self.__virtkbd.SetCursorLocation(x, y, w, h)

    def set_keyboard(self, keyboard):
        keyboard = dbus.String(keyboard)
        self.__virtkbd.SetKeyboard(keyboard)
