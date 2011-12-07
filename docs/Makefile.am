distclean_dirs = \
	ibus-panel-extensions \
	gtk-doc \
	$(NULL)

phony_deps = \
	ibus-panel-extensions-doc \
	ibus-panel-extensions-gtk-doc \
	$(NULL)

ibuspanelextensionsdocdir=$(datadir)/devhelp/references/ibus-panel-extensions
ibuspanelextensionsimgdir=$(datadir)/devhelp/references/ibus-panel-extensions/img

ibuspanelextensionsgtkdocdir=$(datadir)/gtk-doc/html/ibus-panel-extensions

common_doc_files = \
	*.css \
	*.png \
	*.js \
	index.htm \
	*.html \
	$(NULL)

ibuspanelextensionsdoc_DATA = \
	ibus-panel-extensions/ibus-panel-extensions/ibus-panel-extensions.devhelp2 \
	$(addprefix ibus-panel-extensions/ibus-panel-extensions/,$(common_doc_files)) \
	$(NULL)

ibuspanelextensionsgtkdoc_DATA = gtk-doc/ibus-panel-extensions/html/*

ibuspanelextensionsimg_DATA = \
	ibus-panel-extensions/ibus-panel-extensions/img/*.png \
	$(NULL)

$(ibuspanelextensionsdoc_DATA) $(ibuspanelextensionsimg_DATA): ibus-panel-extensions-doc
$(ibuspanelextensionsgtkdoc_DATA): ibus-panel-extensions-gtk-doc

valadoc_flags = \
	--force \
	--package-name $(PACKAGE_NAME) \
	--package-version $(PACKAGE_VERSION) \
	$(NULL)

# ibus-panel-extensions documentation
ibuspanelextensions_doc_files_blacklist = \
	$(NULL)
# this expands the list of files, so we can filter out elements
ibuspanelextensions_doc_files_all = \
	$(wildcard $(top_srcdir)/common/ibus/*.vala) \
	$(wildcard $(top_srcdir)/charmap/ibus/*.vala) \
	$(wildcard $(top_srcdir)/virtkbd/ibus/*.vala) \
	$(wildcard $(top_srcdir)/drawing/ibus/*.vala) \
	$(NULL)
# FIXME: sort the files manually to work around the native doclet portion of
# bgo#662784
ibuspanelextensions_doc_files = \
	$(sort \
	$(filter-out $(ibuspanelextensions_doc_files_blacklist),$(ibuspanelextensions_doc_files_all)))
ibuspanelextensions_doc_deps = \
	glib-2.0 \
	gio-2.0 \
	gee-1.0 \
	ibus-1.0 \
	$(NULL)
valadoc_flags_ibuspanelextensions = \
	$(valadoc_flags) \
	-X $(top_srcdir)/common/ibus/ibuspanelextensions.h \
	$(addprefix --pkg=,$(ibuspanelextensions_doc_deps)) \
	--vapidir=$(top_srcdir)/ibus-panel-extensions \
	$(ibuspanelextensions_doc_files) \
	$(NULL)

ibus-panel-extensions-doc: $(ibuspanelextensions_doc_files)
	$(AM_V_GEN)$(VALADOC) \
		-o ibus-panel-extensions/ \
		--doclet=devhelp \
		$(valadoc_flags_ibuspanelextensions) \
		$(NULL)

ibus-panel-extensions-gtk-doc: $(ibuspanelextensions_doc_files)
	$(AM_V_GEN)$(VALADOC) \
		-X -l -X $(top_builddir)/common/ibus/.libs/libibuspanelextensions.so \
		-X -l -X $(top_builddir)/charmap/ibus/.libs/libibuscharmap.so \
		-X -l -X $(top_builddir)/virtkbd/ibus/.libs/libibusvirtkbd.so \
		-X -l -X $(top_builddir)/drawing/ibus/.libs/libibusdrawing.so \
		-o gtk-doc/ibus-panel-extensions \
		--doclet=gtkdoc \
		$(valadoc_flags_ibuspanelextensions) \
		$(NULL)

.PHONY: $(phony_deps)

distclean-local: distclean-docs
distclean-docs:
	rm -rf $(distclean_dirs)

GITIGNOREFILES = \
	ibus-panel-extensions/ \
	gtk-doc/ \
	$(NULL)

-include $(top_srcdir)/git.mk
