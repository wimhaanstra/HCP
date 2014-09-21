@objc(Time)
class Time: _Time {
 
	private var _fetchDataTimer: NSTimer? = nil;
	private var _fetchSensorsTimer: NSTimer? = nil;
	
	override class func discover(includeStored: Bool, completion: (results: [Controller]) -> Void) {
		
		//XCGLogger.defaultInstance().info("TimeController Discovery");
		var match: Time? = Time.findFirstByAttribute("ip", withValue: "localhost");
		
		if (match == nil) {
			var foundObject = Time.createEntityInContext(nil);
			foundObject.ip = "localhost";
			foundObject.name = "Time Controller";
			foundObject.lastUpdate = NSDate();
			foundObject.type = kControllerType.Time;
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
			//			XCGLogger.defaultInstance().error("This object is not saved, you cannot store sensors for this device.");
			return;
		}

		if (self.sensors.count == 0) {
			
			EntityFactory<Clock>.create(self, definition: [ "id" : 0, "name" : "Europe/Amsterdam", "timeZoneOffset" : 2 ]);
			
		}
		
	}
	
	override var entityName: String {
		return "TimeController";
	}
	
	override var description: String {
		return "Time (" + self.ip! + ")";
	}
	
	
}
