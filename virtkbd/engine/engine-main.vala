/*
 * Copyright (C) 2011  Daiki Ueno
 * Copyright (C) 2011  Red Hat, Inc.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
 * 02110-1301, USA.
 */
namespace IBusVirtkbd {
    static bool ibus;

    const OptionEntry[] options = {
        {"ibus", 'i', 0, OptionArg.NONE, ref ibus,
         N_("Component is executed by IBus"), null },
        { null }
    };

    public static int main (string[] args) {
        var context = new OptionContext ("- ibus virtkbd");
        context.add_main_entries (options, "ibus-virtkbd");
        try {
            context.parse (ref args);
        } catch (OptionError e) {
            stderr.printf ("%s\n", e.message);
            return 1;
        }
        Intl.bindtextdomain (Config.GETTEXT_PACKAGE, Config.LOCALEDIR);
        Intl.bind_textdomain_codeset (Config.GETTEXT_PACKAGE, "UTF-8");

        IBus.init ();
        var bus = new IBus.Bus ();
        bus.disconnected.connect (() => { IBus.quit (); });
        IBusVirtkbd.Engine.config = bus.get_config ();

        var factory = new IBus.Factory (bus.get_connection());
        factory.add_engine ("virtkbd", typeof(IBusVirtkbd.Engine));
        if (ibus) {
            bus.request_name ("org.freedesktop.IBus.Virtkbd.Engine", 0);
        } else {
            var component = new IBus.Component (
                "org.freedesktop.IBus.Virtkbd.Engine",
                N_("Virtkbd"), Config.VERSION, "GPL",
                "Daiki Ueno <ueno@unixuser.org>",
                "http://code.google.com/p/ibus/",
                "",
                "ibus-virtkbd");
            var engine = new IBus.EngineDesc (
                "virtkbd",
                N_("Character Map"),
                N_("Unicode Input Method Using Virtual Keyboard"),
                "other",
                "GPL",
                "Daiki Ueno <ueno@unixuser.org>",
                "input-keyboard",
                "us");
            component.add_engine (engine);
            bus.register_component (component);
        }
        IBus.main ();
        return 0;
    }
}
