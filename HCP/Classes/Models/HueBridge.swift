@objc(HueBridge)
class HueBridge: _HueBridge {
	
	override class func discover(includeStored: Bool, completion: (results: [Controller]) -> Void) {
		
		let discoveryUrl = "http://www.meethue.com/api/nupnp";
		
		let manager = AFHTTPRequestOperationManager();
		
		manager.GET(discoveryUrl, parameters: nil, success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
			
			if (responseObject is NSArray) {
				if (responseObject.count == 0) {
					completion(results: [])
				}
				else {
					var huesArray: NSArray = responseObject as NSArray
					
					var returnObjects: [Controller] = [Controller]();

					for item in huesArray {
						
						if let hue = item as? NSDictionary {
							
							var macAddress = hue.objectForKey("macaddress") as String;
							var match = HueBridge.findFirstByAttribute("mac", withValue: macAddress);
							var name = hue.objectForKey("name") as String;
							
							if (match == nil) {
								var foundObject: HueBridge = HueBridge.createEntityInContext(nil) as HueBridge;
								foundObject.ip = hue.objectForKey("internalipaddress") as? String;
								foundObject.name = "HueBridge (\(name))";
								foundObject.mac = macAddress;
								foundObject.type = kControllerType.HueBridge;
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
			}
			else {
				completion(results: [])
			}
			
			},
			failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
				//			XCGLogger.defaultInstance().error("Error: " + error.localizedDescription);
		});
	}
	
}

