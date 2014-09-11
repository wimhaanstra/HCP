@objc(Controller)
class Controller: _Controller {

	// Custom logic goes here.
	class func discover(includeStored: Bool, completion: (results: [Controller]) -> Void) {
        completion(results: [])
    }
    	
	override var description: String {
		return self.name! + " (" + self.ip! + ")";
	}
	
	var entityName: String {
		return "Controller";
	}
	
	var started: Bool = false;
	
	func start() {
	}
	
	func stop() {
	}

}
