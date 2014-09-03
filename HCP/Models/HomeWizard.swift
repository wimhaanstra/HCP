@objc(HomeWizard)
class HomeWizard: _HomeWizard {
    
    override class func discover(completion: (results: [Controller]) -> Void) {
        
        let discoveryUrl = "http://gateway.homewizard.nl/discovery.php";
		
		logDebug("HomeWizard Discovery: " + discoveryUrl);
		
        let manager = AFHTTPRequestOperationManager();
        
        manager.GET(discoveryUrl, parameters: nil, success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
				
				if (responseObject.objectForKey("status") as String == "ok") {
					var ipAddress = responseObject.objectForKey("ip") as String
					var match: AnyObject! = HomeWizard.findFirstByAttribute("ip", withValue: ipAddress);
					
					if (match == nil) {
						var foundObject: HomeWizard = HomeWizard.createEntityInContext(nil) as HomeWizard;
						foundObject.ip = ipAddress;
						foundObject.name = ipAddress;
						foundObject.lastUpdate = NSDate.date();
						completion(results: [foundObject]);
					}
					else {
						var foundObject: HomeWizard = match as HomeWizard
						completion(results: [foundObject])
					}
					
				}
				else {
					completion(results: []);
				}
            },
            failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
                logError("Error: " + error.localizedDescription)
            }
        )
        
    }
    
    override func performAction(command: String, completion: (results: AnyObject!) -> Void ) -> Void {
		logDebug("Performing HomeWizard Command: " + command);
    }
    
}
