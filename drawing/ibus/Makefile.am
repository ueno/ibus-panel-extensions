lib_LTLIBRARIES =				\
	libibusdrawing.la			\
	$(NULL)

libibusdrawing_la_VALAFLAGS =			\
	-H ibusdrawing.h			\
	--vapi ibus-drawing.vapi		\
	--vapidir=$(top_srcdir)/vapi		\
	--vapidir=$(top_builddir)/common/ibus	\
	--pkg gio-2.0				\
	--pkg gtk+-3.0				\
	--pkg ibus-panel-extensions		\
	--library ibus-drawing			\
	$(VALAFLAGS)

libibusdrawing_la_CFLAGS =			\
	$(LIBIBUSPANELEXTENSIONS_CFLAGS)	\
	-I$(top_srcdir)/common

libibusdrawing_la_LIBADD =			\
	$(LIBIBUSPANELEXTENSIONS_LIBS)		\
	-L$(top_builddir)/common/ibus		\
	-libuspanelextensions

libibusdrawingincludedir =				\
	$(includedir)/ibus-panel-extensions/ibus

libibusdrawinginclude_HEADERS =			\
	ibusdrawing.h				\
	$(NULL)

libibusdrawing_la_SOURCES =			\
	ibusdrawing.vala			\
	$(NULL)

vapi_DATA = ibus-drawing.vapi ibus-drawing.deps
vapidir = $(datadir)/vala/vapi
EXTRA_DIST = ibus-drawing.deps

pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = ibus-drawing.pc

CLEANFILES =					\
	*.h					\
	*.stamp					\
	*.vapi					\
	$(pkgconfig_DATA)			\
	$(NULL)
