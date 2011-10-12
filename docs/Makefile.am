include $(top_srcdir)/gtk-doc.make

DOC_MODULE = ibus-panel-extensions
DOC_MAIN_SGML_FILE = ibus-panel-extensions-docs.xml
DOC_SOURCE_DIR = $(top_srcdir)/charmap/ibus $(top_srcdir)/virtkbd/ibus $(top_srcdir)/drawing/ibus
MKDB_OPTIONS = --output-format=xml

INCLUDES = $(LIBIBUSPANELEXTENSIONS_CFLAGS)
GTKDOC_LIBS = $(LIBIBUSPANELEXTENSIONS_LIBS) -L$(top_builddir)/charmap/ibus -libuscharmap -Wl,-rpath=$(top_builddir)/charmap/ibus -L$(top_builddir)/virtkbd/ibus -libusvirtkbd -Wl,-rpath=$(top_builddir)/virtkbd/ibus -L$(top_builddir)/drawing/ibus -libusdrawing -Wl,-rpath=$(top_builddir)/drawing/ibus

# IGNORE_HFILES = 
