@objc(Dimmer)
class Dimmer: _Dimmer {
	
	func dim(dimValue: Int) -> Void {
		(self.controller! as HomeWizard).performAction("/sw/dim/\(self.id!)/\(self.stateValue())", completion: { (results) -> Void in
			self.dimValue = dimValue;
		});
	}
	
	override func update(definition: NSDictionary) {
		super.update(definition);
		
		if let dimmerValue = definition.objectForKey("dimlevel") as? Int {
			if (self.dimValue == nil || dimmerValue != self.dimValue!) {
				self.dimValue = dimmerValue
			}
		}
		
		if (self.defaultDimValue == nil || self.defaultDimValue == 0) {
			self.defaultDimValue = 70;
		}
	}
	
	override func addObserversForObject(object: NSObject) {
		super.addObserversForObject(object);
		self.addObserver(object, forKeyPath: "dimValue", options: NSKeyValueObservingOptions.New, context: nil);
		
	}
	
	override func removeObserversForObject(object: NSObject) {
		
		super.removeObserversForObject(object);
		self.removeObserver(object, forKeyPath: "dimValue");
		
	}
	
	override func fields() -> [AnyObject]! {
		
		var fields: [AnyObject] = [ [ "key": "defaultDimValue", "title": "Tap Dim Value", "type": "number", "header" : "Dimmer" ] ];
		fields = fields + super.fields();
		return fields;
		
	}

}
