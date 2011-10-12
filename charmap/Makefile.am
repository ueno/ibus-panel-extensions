# force include config.h before gi18n.h.
AM_CPPFLAGS = -include $(CONFIG_HEADER)

SUBDIRS = tools service ibus .

if ENABLE_ENGINE
SUBDIRS += engine
endif

@INTLTOOL_XML_NOMERGE_RULE@
@GSETTINGS_RULES@
gsettings_schemas_in_files = \
	org.freedesktop.ibus.charmap.gtk.gschema.xml.in \
	org.freedesktop.ibus.engines.charmap.gschema.xml.in
gsettings_SCHEMAS = $(gsettings_schemas_in_files:.gschema.xml.in=.gschema.xml)

CLEANFILES = \
	$(gsettings_SCHEMAS)
EXTRA_DIST = \
	$(gsettings_schemas_in_files)
