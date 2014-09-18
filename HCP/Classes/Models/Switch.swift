@objc(Switch)
class Switch: _Switch {
	
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
	
	override func addObserversForView(view: UIView) {
		
		super.addObserversForView(view);
		self.addObserver(view, forKeyPath: "status", options: NSKeyValueObservingOptions.New, context: nil);
		
	}
	
	override func removeObserversForView(view: UIView) {
		
		super.removeObserversForView(view);
		self.removeObserver(view, forKeyPath: "status");
		
	}
	
}
