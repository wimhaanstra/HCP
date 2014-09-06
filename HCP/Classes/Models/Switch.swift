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

	
	class func create(definition: Dictionary<String, AnyObject!>) -> Switch {
		
		return Switch();
		
	}
	
}
