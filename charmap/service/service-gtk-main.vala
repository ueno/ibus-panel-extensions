static bool ibus;
const OptionEntry[] options = {
    {"ibus", 'i', 0, OptionArg.NONE, ref ibus,
     N_("Component is executed by IBus"), null },
    { null }
};

static int main (string[] args) {
    var context = new OptionContext ("- ibus charmap gtk");
    context.add_main_entries (options, "ibus-charmap-gtk");
    try {
        context.parse (ref args);
    } catch (OptionError e) {
        stderr.printf ("%s\n", e.message);
        return 1;
    }
    Intl.bindtextdomain (Config.GETTEXT_PACKAGE, Config.LOCALEDIR);
    Intl.bind_textdomain_codeset (Config.GETTEXT_PACKAGE, "UTF-8");

    Gtk.init (ref args);
    IBus.init ();
    var bus = new IBus.Bus ();
    bus.disconnected.connect (() => { IBus.quit (); });
    IBusCharmap.GtkService.config = bus.get_config ();

    DBusConnection conn;
    if (ibus) {
        conn = bus.get_connection ();
    } else {
        try {
            conn = Bus.get_sync (BusType.SESSION);
        } catch (IOError e) {
            stderr.printf ("can't get session bus: %s\n", e.message);
            return 1;
        }
    }
	new IBusCharmap.GtkService (conn);

    IBus.main ();

    return 0;
}
