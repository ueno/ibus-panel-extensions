# force include config.h before gi18n.h.
AM_CPPFLAGS = -include $(CONFIG_HEADER)

libexec_PROGRAMS =				\
	ibus-engine-drawing			\
	$(NULL)

ibus_engine_drawing_VALAFLAGS =			\
	--vapidir=$(builddir)			\
	--vapidir=$(top_srcdir)/vapi		\
	--vapidir=$(top_builddir)/common/ibus	\
	--vapidir=$(top_builddir)/drawing/ibus	\
	--pkg config				\
	--pkg gio-2.0				\
	--pkg ibus-1.0				\
	--pkg ibus-panel-extensions		\
	--pkg ibus-drawing			\
	$(VALAFLAGS)

ibus_engine_drawing_CFLAGS =			\
	$(IBUS_CFLAGS)				\
	-I$(top_builddir)/common		\
	-I$(top_builddir)/drawing/ibus		\
	-DPACKAGE_DATADIR=\"$(pkgdatadir)\"	\
	-DLOCALEDIR=\"$(datadir)/locale\"	\
	-DLIBEXECDIR=\"$(libexecdir)\"

ibus_engine_drawing_LDADD =			\
	$(IBUS_LIBS)				\
	-L$(top_builddir)/common/ibus		\
	-L$(top_builddir)/drawing/ibus		\
	-libusdrawing

ibus_engine_drawing_SOURCES =			\
	engine.vala				\
	engine-main.vala			\
	$(NULL)

component_DATA = drawing.xml
componentdir = $(datadir)/ibus/component

# cannot use suffix rules here because it conflicts with
# INTLTOOL_XML_NOMERGE_RULE
drawing.xml: drawing.xml.in
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
	drawing.xml				\
	$(NULL)

DISTCLEANFILES =				\
	drawing.xml.in				\
	$(NULL)

EXTRA_DIST =					\
	drawing.xml.in.in			\
	$(NULL)
