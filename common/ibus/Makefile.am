lib_LTLIBRARIES = libibuspanelextensions.la

libibuspanelextensions_la_VALAFLAGS = \
	-H ibuspanelextensions.h --vapi ibus-panel-extensions.vapi \
	--vapidir=$(top_srcdir)/vapi \
	--pkg gobject-2.0 \
	--library ibus-panel-extensions \
	$(VALAFLAGS)

libibuspanelextensions_la_CFLAGS = \
	$(LIBIBUSPANELEXTENSIONS_CFLAGS)
libibuspanelextensions_la_LIBADD = \
	$(LIBIBUSPANELEXTENSIONS_LIBS)

libibuspanelextensionsincludedir = \
	$(includedir)/ibus-panel-extensions/ibus

libibuspanelextensionsinclude_HEADERS = \
	ibuspanelextensions.h

libibuspanelextensions_la_SOURCES = \
	ibuspanelextensionsenumtypes.vala \
	ibuspanelextension.vala

vapi_DATA = ibus-panel-extensions.vapi ibus-panel-extensions.deps
vapidir = $(datadir)/vala/vapi
EXTRA_DIST = ibus-panel-extensions.deps

pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = ibus-panel-extensions.pc

CLEANFILES = \
	*.c \
	*.stamp \
	*.vapi \
	$(pkgconfig_DATA)
