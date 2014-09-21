@objc(Clock)
class Clock: _Clock {

	override func update(definition: NSDictionary) {
		super.update(definition);
		
		if let timeZoneOffsetValue = definition.objectForKey("timeZoneOffset") as? NSNumber {
			
			if (timeZoneOffset != nil && timeZoneOffsetValue != timeZoneOffset) {
				self.timeZoneOffset = timeZoneOffsetValue;
			}
			
		}
	}
	
	override func fields() -> [AnyObject]! {
		
		var fields: [AnyObject] = [ [ "key": "timeZoneOffset", "title": "Timezone Offset", "type": "number", "header" : "Clock" ] ];
		fields = fields + super.fields();
		return fields;
		
	}

}
