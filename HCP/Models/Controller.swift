@objc(Controller)
class Controller: _Controller {

	// Custom logic goes here.
    class func discover(completion: (results: [Controller]) -> Void) {
        completion(results: [])
    }
    
    func performAction(command: String, completion: (results: AnyObject!) -> Void ) -> Void {
		completion(results: nil);
    }
	
	func description() -> String {
		return self.name! + " (" + self.ip! + ")";
	}
	
	func start() {
	}
	
	func stop() {
	}

}
