# force include config.h before gi18n.h.
AM_CPPFLAGS = -include $(CONFIG_HEADER)

SUBDIRS = service ibus python .

if ENABLE_ENGINE
SUBDIRS += engine
endif
