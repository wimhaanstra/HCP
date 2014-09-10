@objc(Sensor)
class Sensor: _Sensor {

	func update(definition: NSDictionary) {

		if let nameValue = definition.objectForKey("name") as? String {
			self.name = definition.objectForKey("name") as? String;
		}
		
		if (self.displayName == nil) {
			self.displayName = self.name;
		}
		
	}
	
}
