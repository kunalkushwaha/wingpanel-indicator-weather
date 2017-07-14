using Soup;
using Json;

struct  weatherInfo{
    string short_discription;
    double temperature;
}

string get_ip(Soup.Session session) {
    string uri = "https://api.ipify.org";
    var message = new Soup.Message("GET", uri);
    session.send_message(message);
    
    return (string)message.response_body.data;
    
    
}

 weatherInfo get_weather(string location, string secret_key) {

    //Init the session.    
    var session = new Soup.Session ();
    var info = new weatherInfo();

    string loc_uri = "http://freegeoip.net/json/" + get_ip(session);

    string uri = "https://api.darksky.net/forecast/" + secret_key + "/";


   
    // Get Location.
    double lat, lon; 
    var query_location = new Soup.Message ("GET", loc_uri);
    session.send_message (query_location);
    
    try {
	    var parser = new Json.Parser();

	    parser.load_from_data((string) query_location.response_body.flatten().data, -1);

	    var root_object = parser.get_root().get_object();
	    lat = root_object.get_double_member("latitude");
	    lon = root_object.get_double_member("longitude");
        var city = root_object.get_string_member("city");

        stderr.printf("Location : lat : %g, lon : %g \n", lat, lon);
        stderr.printf("Location : City: %s \n", city);
        
    }catch (Error e){
	    stderr.printf(" Unable to get location\n");
	    return info ;
    }
    


    var weather_uri = uri + lat.to_string() + "," + lon.to_string();
    var message = new Soup.Message ("GET", weather_uri);
    session.send_message (message);

   
    try {
        var parser = new Json.Parser ();
      
        parser.load_from_data ((string) message.response_body.flatten().data, -1);

        var root_object = parser.get_root ().get_object ();
        var currently = root_object.get_object_member ("currently");
        var summary = currently.get_string_member ("summary");
        var temp = currently.get_double_member("temperature");
        
        stderr.printf("current : %s\n", summary);
        info.short_discription = summary;
        info.temperature = temp;
	    

    } catch (Error e) {
        stderr.printf ("I guess something is not working... %s \n", e.message);
    }

	return info;

}
