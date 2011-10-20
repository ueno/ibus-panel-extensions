lib_LTLIBRARIES =				\
	libibusvirtkbd.la			\
	$(NULL)

libibusvirtkbd_la_VALAFLAGS =			\
	-H ibusvirtkbd.h			\
	--vapi ibus-virtkbd.vapi		\
	--vapidir=$(top_srcdir)/vapi		\
	--vapidir=$(top_builddir)/common/ibus	\
	--pkg gio-2.0				\
	--pkg ibus-panel-extensions		\
	--library ibus-virtkbd			\
	$(VALAFLAGS)

libibusvirtkbd_la_CFLAGS =			\
	$(LIBIBUSPANELEXTENSIONS_CFLAGS)	\
	-I$(top_srcdir)/common

libibusvirtkbd_la_LIBADD =			\
	$(LIBIBUSPANELEXTENSIONS_LIBS)		\
	-L$(top_builddir)/common/ibus		\
	-libuspanelextensions

libibusvirtkbdincludedir =				\
	$(includedir)/ibus-panel-extensions/ibus

libibusvirtkbdinclude_HEADERS =			\
	ibusvirtkbd.h				\
	$(NULL)

libibusvirtkbd_la_SOURCES =			\
	ibusvirtkbd.vala			\
	$(NULL)

vapi_DATA = ibus-virtkbd.vapi ibus-virtkbd.deps
vapidir = $(datadir)/vala/vapi
EXTRA_DIST = ibus-virtkbd.deps

pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = ibus-virtkbd.pc

CLEANFILES =					\
	*.h					\
	*.stamp					\
	*.vapi					\
	$(pkgconfig_DATA)			\
	$(NULL)
