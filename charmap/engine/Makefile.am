# force include config.h before gi18n.h.
AM_CPPFLAGS = -include $(CONFIG_HEADER)

libexec_PROGRAMS =				\
	ibus-engine-charmap			\
	ibus-setup-charmap			\
	$(NULL)

ibus_engine_charmap_VALAFLAGS =			\
	--vapidir=$(builddir)			\
	--vapidir=$(top_srcdir)/vapi		\
	--vapidir=$(top_builddir)/common/ibus	\
	--vapidir=$(top_builddir)/charmap/ibus	\
	--pkg config				\
	--pkg gio-2.0				\
	--pkg ibus-1.0				\
	--pkg ibus-panel-extensions		\
	--pkg ibus-charmap			\
	$(VALAFLAGS)

ibus_engine_charmap_CFLAGS =			\
	$(IBUS_CFLAGS)				\
	-I$(top_builddir)/common		\
	-I$(top_builddir)/charmap/ibus		\
	-DPACKAGE_DATADIR=\"$(pkgdatadir)\"	\
	-DLOCALEDIR=\"$(datadir)/locale\"	\
	-DLIBEXECDIR=\"$(libexecdir)\"

ibus_engine_charmap_LDADD =			\
	$(IBUS_LIBS)				\
	-L$(top_builddir)/common/ibus		\
	-L$(top_builddir)/charmap/ibus		\
	-libuscharmap

ibus_engine_charmap_SOURCES =			\
	engine.vala				\
	engine-main.vala			\
	$(NULL)

ibus_setup_charmap_VALAFLAGS =			\
	--vapidir=$(builddir)			\
	--vapidir=$(top_srcdir)/vapi		\
	--vapidir=$(top_builddir)/common/ibus	\
	--vapidir=$(top_builddir)/charmap/ibus	\
	--pkg config				\
	--pkg gtk+-3.0				\
	--pkg ibus-1.0				\
	--pkg ibus-charmap			\
	$(VALAFLAGS)

setupdir = $(pkgdatadir)/setup
dist_setup_DATA = ibus-charmap-preferences.ui

ibus_setup_charmap_CFLAGS =			\
	$(GTK_CFLAGS)				\
	$(IBUS_CFLAGS)				\
	-I$(top_builddir)/common/ibus		\
	-I$(top_builddir)/charmap/ibus		\
	-DPACKAGE_DATADIR=\"$(pkgdatadir)\"	\
	-DLOCALEDIR=\"$(datadir)/locale\"	\
	-DSETUPDIR=\"$(setupdir)\"

ibus_setup_charmap_LDADD =			\
	$(GTK_LIBS)				\
	$(IBUS_LIBS)				\
	-L$(top_builddir)/common/ibus		\
	-L$(top_builddir)/charmap/ibus		\
	-libuscharmap

ibus_setup_charmap_SOURCES =			\
	key-capture-dialog.vala			\
	setup.vala				\
	setup-main.vala				\
	$(NULL)

component_DATA = charmap.xml
componentdir = $(datadir)/ibus/component

# cannot use suffix rules here because it conflicts with
# INTLTOOL_XML_NOMERGE_RULE
charmap.xml: charmap.xml.in
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
	charmap.xml				\
	$(NULL)

DISTCLEANFILES =				\
	charmap.xml.in				\
	$(NULL)

EXTRA_DIST =					\
	charmap.xml.in.in			\
	$(NULL)
