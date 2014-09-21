enum DeviceType: Int {
	case Light = 0, TV, Other;
}

@objc(Switch)
class Switch: _Switch, FXForm {
	
	func on() -> Void {
		
		(self.controller! as HomeWizard).performAction("/sw/\(self.id!)/on", completion: { (results) -> Void in
			self.status = true;
		});
		
	}
	
	func off() -> Void {
		
		(self.controller! as HomeWizard).performAction("/sw/\(self.id!)/off", completion: { (results) -> Void in
			self.status = false;
		});
		
	}
	
	func stateValue() -> String {
		return (self.status!.boolValue) ? "on" : "off";
	}
	
	override func update(definition: NSDictionary) {
		super.update(definition);
		
		if let statusValue = definition.objectForKey("status") as? String {
			var newValue = (statusValue == "off") ? false : true;
			
			if (self.status == nil || self.status! != newValue) {
				self.status = newValue;
			}
		}
	}
	
	override func addObserversForObject(object: NSObject) {
		
		super.addObserversForObject(object);
		self.addObserver(object, forKeyPath: "status", options: NSKeyValueObservingOptions.New, context: nil);
		
	}
	
	override func removeObserversForObject(object: NSObject) {
		
		super.removeObserversForObject(object);
		self.removeObserver(object, forKeyPath: "status");
		
	}
	
	/*
	func deviceTypeField() -> NSDictionary {
		
		return [ "options" : [ DeviceType.Light, DeviceType.TV, DeviceType.Other ]];
		
	}
	*/
	
	override func fields() -> [AnyObject]! {
		
//		var optionDictionary = [ "options" : ["Test", "Test 2", "Test 3"] ];
		
		var superFields = super.fields();
		superFields.append([ "key": "deviceType", "title": "Device type", "type": "option", "options": ["test", "test2", "test3"] ]);
		return superFields;

	}
	
	
}
