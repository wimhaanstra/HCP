@objc(Controller)
class Controller: _Controller, FXForm {

	// Custom logic goes here.
	class func discover(includeStored: Bool, completion: (results: [Controller]) -> Void) {
        completion(results: [])
    }
    	
	var type: kControllerType = kControllerType.Controller;
	
	var reachabilityManager: AFNetworkReachabilityManager?;
	
	var started: Bool = false;
	
	func start() {
	}
	
	func stop() {
	}
	
	func fields() -> [AnyObject]! {
		
		return [
			[ "key": "name", "title": "Name", "type": "text" ]
		];
		
	}
	
	

}
