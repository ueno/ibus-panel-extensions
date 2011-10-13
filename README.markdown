Additional UI service components for IBus
================================

NOTE: WIP

What's this
-------------------------

This package contains the following components:

* charmap: character map
* virtkbd: virtual keyboard
* drawing: drawing pad for hand-writing input

Each component consists of a D-Bus service running on IBus bus (which
provides actual UI), a client library to access the service, and an
example IME using the service through the library.

Dependencies
-------------------------------

* IBus (pkgconfig: ibus-1.0 >= 1.4.0)

Note that it won't work with older IBus, because IBus gets automatic
service activation since 1.4.0.

* Vala 0.12

For charmap:

* Gucharmap 3.0.* (pkgconfig: gucharmap-2.90 >= 3.0.1)

For virtkbd:

* eekboard 1.0.* (pkgconfig: eek-gtk-0.90)

For drawing:

* GTK+ 3.* (pkgconfig: gtk+-3.0)

Install
-------------------------------

<pre>
$ sudo yum install vala ibus-devel gucharmap-devel eekboard-devel ...
$ ./autogen.sh --prefix=/usr # --libdir=/usr/lib64
$ make
$ sudo make install
</pre>

