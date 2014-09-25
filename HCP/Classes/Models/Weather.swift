@objc(Weather)
class Weather: _Weather {

	override func update(definition: NSDictionary) {
		super.update(definition);
		
		if let locationValue = definition.objectForKey("location") as? String {
			
			if (locationValue != location) {
				self.location = locationValue;
			}
			
		}
	}
	
	override func fields() -> [AnyObject]! {
		
		var fields: [AnyObject] = [ [ "key": "location", "title": "Location", "type": "text", "header" : "Weather" ] ];
		fields = fields + super.fields();
		return fields;
		
	}

}
