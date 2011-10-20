# force include config.h before gi18n.h.
AM_CPPFLAGS = -include $(CONFIG_HEADER)

libexec_PROGRAMS =				\
	ibus-ui-charmap-gtk			\
	$(NULL)

ibus_ui_charmap_gtk_VALAFLAGS =			\
	--vapidir=$(builddir)			\
	--vapidir=$(top_srcdir)/vapi		\
	--vapidir=$(top_builddir)/common/ibus	\
	--vapidir=$(top_builddir)/private	\
	--pkg config				\
	--pkg gio-2.0				\
	--pkg gtk+-3.0				\
	--pkg gucharmap-2.90			\
	--pkg sqlite3				\
	--pkg ibus-1.0				\
	--pkg ibus-panel-extensions		\
	--pkg ibus-panel-extensions-private	\
	$(VALAFLAGS)

ibus_ui_charmap_gtk_CFLAGS =			\
	$(GUCHARMAP_CFLAGS)			\
	$(SQLITE_CFLAGS)			\
	$(IBUS_CFLAGS)				\
	-I$(top_srcdir)/common			\
	-I$(top_srcdir)/private			\
	-DPACKAGE_DATADIR=\"$(pkgdatadir)\"	\
	-DLOCALEDIR=\"$(datadir)/locale\"	\
	-DUNICODENAMESFILE=\"$(unicodenames)\"	\
	-DLIBEXECDIR=\"$(libexecdir)\"

ibus_ui_charmap_gtk_LDADD =			\
	$(GUCHARMAP_LIBS)			\
	$(SQLITE_LIBS)				\
	$(IBUS_LIBS)				\
	-L$(top_builddir)/common/ibus		\
	-L$(top_builddir)/private		\
	-libuspanelextensions			\
	-libuspanelextensionsprivate

ibus_ui_charmap_gtk_SOURCES =			\
	charmap-panel.vala			\
	search-panel.vala			\
	service.vala				\
	service-gtk.vala			\
	service-gtk-main.vala			\
	$(NULL)

unicodenames = unicodenames.sqlite3
dist_pkgdata_DATA = $(unicodenames)
unicodenames.sqlite3: | $(top_builddir)/charmap/tools/gen-index
	$(AM_V_GEN) $(top_builddir)/charmap/tools/gen-index $@

component_DATA = gtkcharmap.xml
componentdir = $(datadir)/ibus/component

# cannot use suffix rules here because it conflicts with
# INTLTOOL_XML_NOMERGE_RULE
gtkcharmap.xml: gtkcharmap.xml.in
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
	gtkcharmap.xml				\
	$(NULL)

DISTCLEANFILES =				\
	gtkcharmap.xml.in			\
	$(unicodenames)				\
	$(NULL)

EXTRA_DIST =					\
	gtkcharmap.xml.in			\
	$(NULL)
