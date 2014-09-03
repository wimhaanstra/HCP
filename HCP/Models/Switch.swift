@objc(Switch)
class Switch: _Switch {

    func on() -> Void {
        
        self.controller!.performAction(String(format: "/sw/%d/on", self.id!), completion: { (results) -> Void in
        });
        
    }
    
    func off() -> Void {

        self.controller!.performAction(String(format: "/sw/%d/off", self.id!), completion: { (results) -> Void in
        });
    
    }

}
