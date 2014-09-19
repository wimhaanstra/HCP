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
	
	override func addObserversForView(view: UIView) {
		
		super.addObserversForView(view);
		self.addObserver(view, forKeyPath: "dimValue", options: NSKeyValueObservingOptions.New, context: nil);
		
	}
	
	override func removeObserversForView(view: UIView) {
		
		super.removeObserversForView(view);
		self.removeObserver(view, forKeyPath: "dimValue");
		
	}
	
	override func fields() -> [AnyObject]! {
		
		var superFields = super.fields();
		superFields.append([ "key": "defaultDimValue", "title": "Default Dim Value", "type": "number" ]);
		return superFields;
		
	}

}
