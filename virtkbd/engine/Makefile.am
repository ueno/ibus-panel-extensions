# force include config.h before gi18n.h.
AM_CPPFLAGS = -include $(CONFIG_HEADER)

libexec_PROGRAMS =				\
	ibus-engine-virtkbd			\
	$(NULL)

ibus_engine_virtkbd_VALAFLAGS =			\
	--vapidir=$(builddir)			\
	--vapidir=$(top_srcdir)/vapi		\
	--vapidir=$(top_builddir)/common/ibus	\
	--vapidir=$(top_builddir)/virtkbd/ibus	\
	--pkg config				\
	--pkg gio-2.0				\
	--pkg ibus-1.0				\
	--pkg ibus-panel-extensions		\
	--pkg ibus-virtkbd			\
	$(VALAFLAGS)

ibus_engine_virtkbd_CFLAGS =			\
	-I$(top_builddir)/common		\
	-I$(top_builddir)/virtkbd/ibus		\
	$(IBUS_CFLAGS)				\
	-DPACKAGE_DATADIR=\"$(pkgdatadir)\"	\
	-DLOCALEDIR=\"$(datadir)/locale\"	\
	-DLIBEXECDIR=\"$(libexecdir)\"

ibus_engine_virtkbd_LDADD =			\
	-L$(top_builddir)/common/ibus		\
	-L$(top_builddir)/virtkbd/ibus		\
	$(IBUS_LIBS)				\
	-libusvirtkbd

ibus_engine_virtkbd_SOURCES =			\
	engine.vala				\
	engine-main.vala			\
	$(NULL)

component_DATA = virtkbd.xml
componentdir = $(datadir)/ibus/component

# cannot use suffix rules here because it conflicts with
# INTLTOOL_XML_NOMERGE_RULE
virtkbd.xml: virtkbd.xml.in
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
	virtkbd.xml				\
	$(NULL)

DISTCLEANFILES =				\
	virtkbd.xml.in				\
	$(NULL)

EXTRA_DIST =					\
	virtkbd.xml.in.in			\
	$(NULL)
