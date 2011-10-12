lib_LTLIBRARIES =				\
	libibuscharmap.la			\
	$(NULL)

libibuscharmap_la_VALAFLAGS =			\
	-H ibuscharmap.h			\
	--vapi ibus-charmap.vapi		\
	--vapidir=$(top_srcdir)/vapi		\
	--vapidir=$(top_builddir)/common/ibus	\
	--pkg gio-2.0				\
	--pkg ibus-panel-extensions		\
	--library ibus-charmap			\
	$(VALAFLAGS)

libibuscharmap_la_CFLAGS =			\
	$(LIBIBUSPANELEXTENSIONS_CFLAGS)	\
	-I$(top_builddir)/common/ibus

libibuscharmap_la_LIBADD =			\
	$(LIBIBUSPANELEXTENSIONS_LIBS)		\
	-L$(top_builddir)/common/ibus		\
	-libuspanelextensions

libibuscharmapincludedir =				\
	$(includedir)/ibus-panel-extensions/ibus

libibuscharmapinclude_HEADERS =			\
	ibuscharmap.h				\
	$(NULL)

libibuscharmap_la_SOURCES =			\
	ibuscharmap.vala			\
	$(NULL)

vapi_DATA = ibus-charmap.vapi ibus-charmap.deps
vapidir = $(datadir)/vala/vapi
EXTRA_DIST = ibus-charmap.deps

pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = ibus-charmap.pc

CLEANFILES =					\
	*.c					\
	*.stamp					\
	*.vapi					\
	$(pkgconfig_DATA)			\
	$(NULL)
