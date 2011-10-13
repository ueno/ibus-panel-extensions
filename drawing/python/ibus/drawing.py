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

class Drawing(gobject.GObject):
    __gtype_name__ = "PyIBusDrawing"
    __gsignals__ = {
        'stroke-added': (
            gobject.SIGNAL_RUN_LAST,
            gobject.TYPE_NONE,
            (gobject.TYPE_POINTER,
             gobject.TYPE_INT)),
        'stroke-removed': (
            gobject.SIGNAL_RUN_LAST,
            gobject.TYPE_NONE,
            (gobject.TYPE_UINT,))
        }

    def __init__(self, bus):
        super(Drawing, self).__init__()
        self.__dbusconn = bus.get_dbusconn()
        _drawing = self.__dbusconn.get_object("org.freedesktop.IBus.Drawing",
                                              "/org/freedesktop/IBus/Drawing")
        self.__drawing = dbus.Interface(_drawing,
                                        dbus_interface="org.freedesktop.DBus")
        self.__drawing.connect_to_signal("StrokeAdded",
                                         self.__stroke_added_cb)
        self.__drawing.connect_to_signal("StrokeRemoved",
                                         self.__stroke_removed_cb)

    def __stroke_added_cb(self, *args):
        # FIXME: self.emit("stroke-added", coordinates, len(coordinates))
        pass

    def __stroke_removed_cb(self, *args):
        n_strokes = args[0]
        self.emit("stroke-removed", n_strokes)

    def show(self):
        self.__drawing.Show()

    def hide(self):
        self.__drawing.Hide()

    def set_cursor_location(self, x, y, w, h):
        x = dbus.Int32(x)
        y = dbus.Int32(y)
        w = dbus.Int32(w)
        h = dbus.Int32(h)
        self.__drawing.SetCursorLocation(x, y, w, h)
