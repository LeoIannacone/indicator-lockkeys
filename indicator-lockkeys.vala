/*
 * Copyright 2015 Leo Iannacone.
 *
 * This program is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License version 3, as published
 * by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranties of
 * MERCHANTABILITY, SATISFACTORY QUALITY, or FITNESS FOR A PARTICULAR
 * PURPOSE.  See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Authors:
 *   Leo Iannacone (l3on) <info@leoiannacone.com>
 */

using AppIndicator;

abstract class IndicatorLockKey
{
    protected Gdk.Keymap map;
    protected Indicator indicator;
    protected Gtk.MenuItem item;
    protected string icon;
    protected string name;
    protected uint keyval;
    protected bool active;
    protected bool force_update;

    public IndicatorLockKey(string keyname, string icon)
    {
        this.name = keyname.replace("_", " ");
        this.keyval = Gdk.keyval_from_name(keyname);
        this.icon = icon;
        this.indicator = new Indicator("IndicatorLockKey_" + name, icon,
                                       IndicatorCategory.APPLICATION_STATUS);
        indicator.set_status(IndicatorStatus.ACTIVE);
        indicator.set_icon_theme_path("/usr/share/icons");
        indicator.set_icon(icon);

        var menu = new Gtk.Menu();
        this.item = new Gtk.MenuItem.with_label("");
        item.activate.connect(() => {
            Caribou.DisplayAdapter.get_default().keyval_press(keyval);
            Caribou.DisplayAdapter.get_default().keyval_release(keyval);
        });
        item.show();
        menu.append(item);
        indicator.set_menu(menu);

        this.map = Gdk.Keymap.get_default();
        map.state_changed.connect(on_state_changed);
        this.force_update = true;
        on_state_changed();
        this.force_update = false;
    }

    public void set_active(bool active)
    {
        if (active == this.active && !this.force_update) {
            return;
        }
        this.active = active;

        if (active) {
            this.icon = this.icon.replace("disabled", "enabled");
            this.item.set_label("Disable " + this.name);
        } else {
            this.icon = this.icon.replace("enabled", "disabled");
            this.item.set_label("Enable " + this.name);
        }

        this.indicator.set_icon(this.icon);
    }

    public abstract void on_state_changed();
}

class Indicator_NumLock : IndicatorLockKey
{
    public Indicator_NumLock()
    {
        base("Num_Lock", "numlock-disabled-symbolic");
    }

    public override void on_state_changed()
    {
        this.set_active(map.get_num_lock_state());
    }
}

class Indicator_CapsLock : IndicatorLockKey
{
    public Indicator_CapsLock()
    {
        base("Caps_Lock", "capslock-disabled-symbolic");
    }

    public override void on_state_changed()
    {
        this.set_active(map.get_caps_lock_state());
    }
}

public class IndicatorLockKeys
{
    public static int main(string[] args)
    {
        Gtk.init(ref args);
        var caps = new Indicator_CapsLock();
        var num = new Indicator_NumLock();
        Gtk.main();
        return 0;
    }
}
