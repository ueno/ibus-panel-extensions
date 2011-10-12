noinst_LTLIBRARIES = libibuspanelextensionsprivate.la

libibuspanelextensionsprivate_la_VALAFLAGS = \
	-H ibuspanelextensionsprivate.h \
	--vapi ibus-panel-extensions-private.vapi \
	--vapidir=$(top_srcdir)/vapi \
	--vapidir=$(top_builddir)/common/ibus \
	--pkg gio-2.0 \
	--pkg gtk+-3.0 \
	--pkg ibus-panel-extensions \
	--library ibus-panel-extensions-private \
	$(VALAFLAGS)

libibuspanelextensionsprivate_la_CFLAGS = \
	-I$(top_builddir)/common/ibus \
	-I$(top_srcdir)/common/ibus \
	$(LIBIBUSPANELEXTENSIONS_CFLAGS) \
	$(GTK_CFLAGS)
libibuspanelextensionsprivate_la_LIBADD = \
	-L$(top_builddir)/common/ibus \
	-L$(top_srcdir)/common/ibus \
	$(LIBIBUSPANELEXTENSIONS_LIBS) \
	$(GTK_LIBS) \
	-libuspanelextensions

noinst_HEADERS = \
	ibuspanelextensionsprivate.h

libibuspanelextensionsprivate_la_SOURCES = \
	selectable.vala \
	window-placement.vala

CLEANFILES = \
	*.[ch] \
	*.stamp \
	*.vapi
