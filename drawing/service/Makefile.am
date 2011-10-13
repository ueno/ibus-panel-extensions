# force include config.h before gi18n.h.
AM_CPPFLAGS = -include $(CONFIG_HEADER)

libexec_PROGRAMS =				\
	ibus-ui-drawing-gtk			\
	$(NULL)

ibus_ui_drawing_gtk_VALAFLAGS =			\
	--vapidir=$(builddir)			\
	--vapidir=$(top_srcdir)/vapi		\
	--vapidir=$(top_builddir)/common/ibus	\
	--vapidir=$(top_builddir)/private	\
	--pkg config				\
	--pkg gio-2.0				\
	--pkg gtk+-3.0				\
	--pkg ibus-1.0				\
	--pkg ibus-panel-extensions		\
	--pkg ibus-panel-extensions-private	\
	$(VALAFLAGS)

ibus_ui_drawing_gtk_CFLAGS =			\
	$(GTK_CFLAGS) $(IBUS_CFLAGS)		\
	-I$(top_builddir)/common		\
	-I$(top_builddir)/private		\
	-DPACKAGE_DATADIR=\"$(pkgdatadir)\"	\
	-DLOCALEDIR=\"$(datadir)/locale\"	\
	-DUNICODENAMESFILE=\"$(unicodenames)\"	\
	-DLIBEXECDIR=\"$(libexecdir)\"

ibus_ui_drawing_gtk_LDADD =			\
	$(GTK_LIBS) $(IBUS_LIBS)		\
	-L$(top_builddir)/common/ibus		\
	-L$(top_builddir)/private		\
	-libuspanelextensions			\
	-libuspanelextensionsprivate		\
	-lm

ibus_ui_drawing_gtk_SOURCES =			\
	drawing-panel.vala			\
	service.vala				\
	service-gtk.vala			\
	service-gtk-main.vala			\
	$(NULL)

component_DATA = gtkdrawing.xml
componentdir = $(datadir)/ibus/component

# cannot use suffix rules here because it conflicts with
# INTLTOOL_XML_NOMERGE_RULE
gtkdrawing.xml: gtkdrawing.xml.in
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
	gtkdrawing.xml				\
	$(NULL)

DISTCLEANFILES =				\
	gtkdrawing.xml.in			\
	$(NULL)

EXTRA_DIST =					\
	gtkdrawing.xml.in			\
	$(NULL)
