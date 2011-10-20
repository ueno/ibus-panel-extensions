# vim:set et ts=4:
#
# ibus-tmpl - The Input Bus template project
#
# Copyright (c) 2007-2011 Peng Huang <shawn.p.huang@gmail.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

# if not 1, append datestamp to the version number.
m4_define([package_name], [ibus-panel-extensions])
m4_define([ibus_released], [0])
m4_define([ibus_major_version], [1])
m4_define([ibus_minor_version], [4])
m4_define([ibus_micro_version], [99])
m4_define(ibus_maybe_datestamp,
    m4_esyscmd([if test x]ibus_released[ != x1; then date +.%Y%m%d | tr -d '\n\r'; fi]))

m4_define([ibus_version],
    ibus_major_version.ibus_minor_version.ibus_micro_version[]ibus_maybe_datestamp)

AC_INIT([package_name], [ibus_version], [http://code.google.com/p/ibus/issues/entry], [package_name])
AM_INIT_AUTOMAKE([1.10])
AC_GNU_SOURCE

AC_CONFIG_HEADERS([config.h])
AC_CONFIG_MACRO_DIR([m4])
dnl m4_ifdef([AM_SILENT_RULES],[AM_SILENT_RULES([yes])])

# define PACKAGE_VERSION_* variables
AS_VERSION
AS_NANO
AM_SANITY_CHECK
AM_MAINTAINER_MODE
AM_DISABLE_STATIC
AC_PROG_CC
AM_PROG_CC_C_O
AC_PROG_CXX
AC_ISC_POSIX
AC_HEADER_STDC
AM_PROG_LIBTOOL

# check ibus
PKG_CHECK_MODULES(IBUS, [
    ibus-1.0
])

# check eekgtk
PKG_CHECK_MODULES(EEKGTK, [
    eek-gtk-0.90
])

# check gucharmap
PKG_CHECK_MODULES(GUCHARMAP, [
    gucharmap-2.90
])

# check sqlite
PKG_CHECK_MODULES(SQLITE, [
    sqlite3
])

# check gtk
PKG_CHECK_MODULES(GTK, [
    gtk+-3.0
])

# check gee
PKG_CHECK_MODULES(GEE, [
    gee-1.0
])

PKG_CHECK_MODULES(LIBIBUSPANELEXTENSIONS, [
    glib-2.0 >= 2.26.0 gobject-2.0 gio-2.0
])

# check glib2 and intltool for gsettings
AM_PATH_GLIB_2_0
IT_PROG_INTLTOOL([0.35.0])
GLIB_GSETTINGS

# check gtk-doc
GTK_DOC_CHECK([1.15])

# check vala
AM_PROG_VALAC([0.12.0])

AC_PATH_PROG(VALAC, valac, valac)
AC_SUBST(VALAC)
AC_SUBST(VALAFLAGS)

#check python
AM_PATH_PYTHON([2.5])

# define GETTEXT_* variables
GETTEXT_PACKAGE="$PACKAGE_NAME"
AC_SUBST(GETTEXT_PACKAGE)
AC_DEFINE_UNQUOTED(GETTEXT_PACKAGE,"$GETTEXT_PACKAGE", [Define to the read-only architecture-independent data directory.])

AM_GNU_GETTEXT([external])
AM_GNU_GETTEXT_VERSION(0.16.1)

dnl check whether enable example engines
AC_MSG_CHECKING([whether you enable example engines])
AC_ARG_ENABLE(engine,
              AS_HELP_STRING([--enable-engine=no/yes],
                             [Enable example engines default=yes]),
              enable_engine=$enableval,
              enable_engine=yes)

AM_CONDITIONAL(ENABLE_ENGINE, [test x$enable_engine = xyes])
AC_MSG_RESULT($enable_engine)


# OUTPUT files
AC_CONFIG_FILES(po/Makefile.in
Makefile
common/Makefile
common/ibus/Makefile
common/ibus/ibus-panel-extensions.pc
private/Makefile
charmap/Makefile
charmap/ibus/Makefile
charmap/ibus/ibus-charmap.pc
charmap/service/Makefile
charmap/service/gtkcharmap.xml.in
charmap/engine/Makefile
charmap/engine/charmap.xml.in
charmap/tools/Makefile
charmap/python/Makefile
virtkbd/Makefile
virtkbd/ibus/Makefile
virtkbd/ibus/ibus-virtkbd.pc
virtkbd/service/Makefile
virtkbd/service/gtkvirtkbd.xml.in
virtkbd/engine/Makefile
virtkbd/engine/virtkbd.xml.in
virtkbd/python/Makefile
drawing/Makefile
drawing/ibus/Makefile
drawing/ibus/ibus-drawing.pc
drawing/service/Makefile
drawing/service/gtkdrawing.xml.in
drawing/engine/Makefile
drawing/engine/drawing.xml.in
drawing/python/Makefile
vapi/Makefile
m4/Makefile
docs/Makefile
)

AC_OUTPUT
AC_MSG_RESULT([
Build options:
  Install prefix            $prefix
  Build shared libs         $enable_shared
  Build static libs         $enable_static
  CFLAGS                    $CFLAGS
  Build example engines     $enable_engine
])
