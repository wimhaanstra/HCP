@objc(Controller)
class Controller: _Controller {

	// Custom logic goes here.
    class func discover(completion: (results: [Controller]) -> Void) {
        completion(results: [])
    }
    	
	override var description: String {
		return self.name! + " (" + self.ip! + ")";
	}
	
	func start() {
	}
	
	func stop() {
	}

}
