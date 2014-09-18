@objc(Sensor)
class Sensor: _Sensor {

	func update(definition: NSDictionary) {

		var previousName = self.name;
		
		if let nameValue = definition.objectForKey("name") as? String {
			self.name = definition.objectForKey("name") as? String;
		}
		
		if (self.displayName == nil || previousName != self.name) {
			self.displayName = self.name;
		}
		
	}
	
	func addObserversForView(view: UIView) {
		self.addObserver(view, forKeyPath: "name", options: NSKeyValueObservingOptions.New, context: nil);
		self.addObserver(view, forKeyPath: "displayName", options: NSKeyValueObservingOptions.New, context: nil);
	}
	
	func removeObserversForView(view: UIView) {
		
		self.removeObserver(view, forKeyPath: "name");
		self.removeObserver(view, forKeyPath: "displayName");
		
	}
	
}
