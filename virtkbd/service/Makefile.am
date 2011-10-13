# force include config.h before gi18n.h.
AM_CPPFLAGS = -include $(CONFIG_HEADER)

libexec_PROGRAMS =				\
	ibus-ui-virtkbd-gtk			\
	$(NULL)

ibus_ui_virtkbd_gtk_VALAFLAGS =			\
	--vapidir=$(builddir)			\
	--vapidir=$(top_srcdir)/vapi		\
	--vapidir=$(top_builddir)/common/ibus	\
	--vapidir=$(top_builddir)/private	\
	--pkg config				\
	--pkg gee-1.0				\
	--pkg gio-2.0				\
	--pkg gtk+-3.0				\
	--pkg eek-0.90				\
	--pkg eek-gtk-0.90			\
	--pkg ibus-1.0				\
	--pkg ibus-panel-extensions		\
	--pkg ibus-panel-extensions-private	\
	$(VALAFLAGS)

ibus_ui_virtkbd_gtk_CFLAGS =				\
	-I$(top_builddir)/common			\
	-I$(top_builddir)/private			\
	$(GEE_CFLAGS)					\
	$(EEKGTK_CFLAGS)				\
	$(SQLITE_CFLAGS)				\
	$(IBUS_CFLAGS)					\
	-DPACKAGE_DATADIR=\"$(pkgdatadir)\"		\
	-DLOCALEDIR=\"$(datadir)/locale\"		\
	-DKEYBOARDDIR=\"$(datadir)/eekboard/keyboards\"	\
	-DLIBEXECDIR=\"$(libexecdir)\"

ibus_ui_virtkbd_gtk_LDADD =			\
	-L$(top_builddir)/common/ibus		\
	-L$(top_builddir)/private		\
	$(GEE_LIBS)				\
	$(EEKGTK_LIBS)				\
	$(SQLITE_LIBS)				\
	$(IBUS_LIBS)				\
	-libuspanelextensions			\
	-libuspanelextensionsprivate

ibus_ui_virtkbd_gtk_SOURCES =			\
	virtkbd-panel.vala			\
	service.vala				\
	service-gtk.vala			\
	service-gtk-main.vala			\
	$(NULL)

component_DATA = gtkvirtkbd.xml
componentdir = $(datadir)/ibus/component

# cannot use suffix rules here because it conflicts with
# INTLTOOL_XML_NOMERGE_RULE
gtkvirtkbd.xml: gtkvirtkbd.xml.in
	$(AM_V_GEN) \
	( \
		libexecdir=${libexecdir}; \
		pkgdatadir=${pkgdatadir}; \
		s=`cat $<`; \
		eval "echo \"$${s}\""; \
	) > $@

CLEANFILES =					\
	*.[ch]					\
	*.stamp					\
	gtkvirtkbd.xml				\
	$(NULL)

DISTCLEANFILES =				\
	gtkvirtkbd.xml.in			\
	$(NULL)

EXTRA_DIST =					\
	gtkvirtkbd.xml.in			\
	$(NULL)
