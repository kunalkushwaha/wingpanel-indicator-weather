
public class Weather.Widgets.DisplayWidget : Gtk.Box {
    private Gtk.Image image;
    private Gtk.Label degree;

    public DisplayWidget () {
        Object (orientation: Gtk.Orientation.HORIZONTAL);
    }

    construct {
        image = new Gtk.Image ();
        //TODO: find a better icon for weather Plugin.
        image.icon_name = "weather-clear-symbolic";
        image.icon_size = Gtk.IconSize.SMALL_TOOLBAR;
        degree = new Gtk.Label ("");
        pack_start (image);
        pack_start (degree);
    }


    public void update_state (string state, double temperature) {
        
        // Convert the F to C and copy in label.
        var degreeTemp =  (temperature - 32.0)*(0.55);
        char[] buf = new char[double.DTOSTR_BUF_SIZE];
	    unowned string str = degreeTemp.format (buf, "%2.2g");
        degree.label = str + "\u00b0C";
        
        switch (state) {
        case "Clear":
            image.icon_name = "weather-clear-symbolic";
            break;
        case "Drizzle":
        case "Light Rain":
            image.icon_name = "weather-showers-scattered-symbolic";
            break;
        case "Rain":
            image.icon_name = "weather-showers-symbolic";
            break;
        case "Snow":
            image.icon_name = "weather-snow-symbolic";
            break;
        case "Partly Cloudy":
        case "Cloudy":
        case "Mostly Cloudy":
            image.icon_name = "weather-few-clouds-symbolic";
            break;
        case "Overcast":
            image.icon_name = "weather-overcast-symbolic";
            break;
        case "Breezy":
            image.icon_name = "weather-windy-symbolic";
            break;    
        default:
            //TODO: Find better icon (\ over weather icon.')
            image.icon_name = "weather-clear-symbolic";
            
            break;
        }
    }
}
