# force include config.h before gi18n.h.
AM_CPPFLAGS = -include $(CONFIG_HEADER)

noinst_PROGRAMS = gen-index

gen_index_VALAFLAGS = \
	--vapidir=$(top_srcdir)/vapi \
	--pkg config --pkg gtk+-3.0 --pkg gucharmap-2.90 --pkg sqlite3 \
	$(VALAFLAGS)

gen_index_CFLAGS = \
	$(GUCHARMAP_CFLAGS) $(SQLITE_CFLAGS)
gen_index_LDADD = \
	$(GUCHARMAP_LIBS) $(SQLITE_LIBS)

gen_index_SOURCES = \
	gen-index.vala

CLEANFILES = *.[ch] *.stamp
