import HomeKit

@objc(HomeKit)
class HomeKit: _HomeKit {

	override class func discover(includeStored: Bool, completion: (results: [Controller]) -> Void) {
		
		var homeManager: HMHomeManager = ControllerManager.sharedInstance.homeManager;
		
		var homes = homeManager.homes;
		
		XCGLogger.defaultInstance().debug("HomeKit: Discovered \(homes.count) homes");
		
		var returnObjects: [Controller] = [Controller]();
		
		for item in homes {

			if let home = item as? HMHome {
				
				var match = HomeKit.findFirstByAttribute("ip", withValue: home.name);

				if (match == nil) {
					var foundObject: HomeKit = HomeKit.createEntityInContext(nil) as HomeKit;
					foundObject.ip = home.name;
					foundObject.name = "HomeKit (\(home.name))";
					foundObject.type = kControllerType.HomeKit;
					foundObject.lastUpdate = NSDate();
					returnObjects.append(foundObject);
				}
				else {
					if (includeStored) {
						returnObjects.append(match);
					}
				}
			}
		}
		
		completion(results: returnObjects);
		
	}
	
	override func fields() -> [AnyObject]! {
		
		var superFields = super.fields();
		superFields.append([ "title": "Discover accessories", "action" : "discoverHomeKitAccessories", "type" : "option" ]);
		return superFields;
		
	}
	
}
