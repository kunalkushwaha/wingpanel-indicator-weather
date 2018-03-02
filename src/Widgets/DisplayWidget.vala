
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
        string icon = "weather-clear-symbolic";
        File map_file;

     
        degree.label = "(N/A)";

        //Read file of weather discription and set icon accordingly.

        try {
            map_file = File.new_for_path (Environment.get_home_dir() + "/.weather-map.dat");
            stderr.printf("home dir: %s\n",Environment.get_home_dir());
            
            if (map_file.query_exists ()) {

		        var parser = new Json.Parser ();
                var dis = new DataInputStream (map_file.read ());
		        
                parser.load_from_stream(dis,null);

                var root_object = parser.get_root ().get_object ();
                icon = root_object.get_string_member (state);
            }
            else {
                    stderr.printf("map-file file NOT FOUND!\n");
            }
        }catch (Error e) {
		    stderr.printf ("Error: %s\n", e.message);
		    return;      
        }       

        image.icon_name = icon;
        degree.label = str + "\u00b0C";
    }
}
