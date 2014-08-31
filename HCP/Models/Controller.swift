@objc(Controller)
class Controller: _Controller {

	// Custom logic goes here.
    class func discover(completion: (results: [Controller]) -> Void) {
        completion(results: [])
    }

}
