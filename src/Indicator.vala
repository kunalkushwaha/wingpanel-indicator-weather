/*
 * Copyright (c) 2011-2017 elementary LLC. (http://launchpad.net/wingpanel)
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public
 * License along with this program; if not, write to the
 * Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1301 USA
 */

public class Weather.Indicator : Wingpanel.Indicator {
    Weather.Widgets.DisplayWidget? display_widget = null;

    private Wingpanel.IndicatorManager.ServerType server_type;

    private const string WEATHER_APP = "Weather App";

    private Gtk.Grid main_grid;
    
    private File config;
    
    private string key;

    public Indicator (Wingpanel.IndicatorManager.ServerType server_type) {
        Object (code_name: WEATHER_APP,
                display_name: _("Weather"),
                description: _("The Weather indicator"));
                
        try {
            config = File.new_for_path (Environment.get_home_dir() + "/.weather.config");
            stderr.printf("home dir: %s\n",Environment.get_home_dir());
            
            if (config.query_exists ()) {

		        var parser = new Json.Parser ();
                var dis = new DataInputStream (config.read ());
		        
                parser.load_from_stream(dis,null);

                var root_object = parser.get_root ().get_object ();
                key = root_object.get_string_member ("key");
            }
            else {
                    stderr.printf("config file NOT FOUND!\n");
            }

        }catch (Error e) {
		    stderr.printf ("Error: %s\n", e.message);
		    return;
	        
        }
                  
        this.server_type = server_type;
    }

    public override Gtk.Widget get_display_widget () {
    
        if (display_widget == null) {
            display_widget = new Widgets.DisplayWidget ();
        }

        visible = true;

        return display_widget;
    }

    public override Gtk.Widget? get_widget () {
        //TODO: popup to show details like location, temp and discriptive forcast.
        this.visible = true;
        
        monitor_weather.begin((obj, res)=> {
            monitor_weather.end(res);
        });
        
        return null;
    }

    private async void monitor_weather() {

        var result = get_weather("",key);
        display_widget.update_state(result.short_discription,result.temperature);
        
    }

    public void connections () {}
  
    public override void opened () {

    }
        
    public override void closed () {}

}

public Wingpanel.Indicator? get_indicator (Module module, Wingpanel.IndicatorManager.ServerType server_type) {
    debug ("Activating Sample Indicator");
    var indicator = new Weather.Indicator (server_type);

    return indicator;
}
