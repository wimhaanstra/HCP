@objc(YahooWeather)
class YahooWeather: _YahooWeather {

	override class func discover(includeStored: Bool, completion: (results: [Controller]) -> Void) {
		
		// https://query.yahooapis.com/v1/public/yql?q=select%20item.condition%20from%20weather.forecast%20where%20woeid%20%3D%202487889&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys
		//XCGLogger.defaultInstance().info("TimeController Discovery");
		var match: YahooWeather? = YahooWeather.findFirstByAttribute("ip", withValue: "query.yahooapis.com");
		
		if (match == nil) {
			var foundObject = YahooWeather.createEntityInContext(nil);
			foundObject.ip = "query.yahooapis.com";
			foundObject.name = "Yahoo Weather Controller";
			foundObject.lastUpdate = NSDate();
			foundObject.type = kControllerType.Weather;
			completion(results: [foundObject]);
		}
		else {
			if (includeStored) {
				completion(results: [match!]);
			}
			else {
				completion(results: []);
			}
		}
	}
	
	override func start() {
		
		if (self.managedObjectContext == nil) {
			return;
		}
		
		if (self.sensors.count == 0) {
			EntityFactory<Weather>.create(self, definition: [ "id" : 0, "name" : "Zwolle, NL", "location" : "Zwolle, NL"]);
		}
		
	}
	
	override var description: String {
		return "Weather (" + self.ip! + ")";
	}
}
