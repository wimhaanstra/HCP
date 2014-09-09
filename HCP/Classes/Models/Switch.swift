@objc(Switch)
class Switch: _Switch {
	
	func on() -> Void {
		
		(self.controller! as HomeWizard).performAction(String(format: "/sw/%d/on", self.id!), completion: { (results) -> Void in
			self.status = true;
		});
		
	}
	
	func off() -> Void {
		
		(self.controller! as HomeWizard).performAction(String(format: "/sw/%d/off", self.id!), completion: { (results) -> Void in
			self.status = false;
		});
		
	}
	
	func stateValue() -> String {
		return (self.status!.boolValue) ? "on" : "off";
	}
	
	override func update(definition: NSDictionary) {
		super.update(definition);
		
		if let statusValue = definition.objectForKey("status") as? String {
			if (statusValue == "off") {
				self.status = false;
			}
			else {
				self.status = true;
			}
		}
	}
	
}
