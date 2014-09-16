@objc(HueBridge)
class HueBridge: _HueBridge {
    
    override class func discover(includeStored: Bool, completion: (results: [Controller]) -> Void) {
        
        let discoveryUrl = "http://www.meethue.com/api/nupnp";
        XCGLogger.defaultInstance().info("Starting Hue Bridge discovery");
        
        let manager = AFHTTPRequestOperationManager();
        
        manager.GET(discoveryUrl, parameters: nil, success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
            
            if (responseObject is NSArray) {
                if (responseObject.count == 0) {
                    completion(results: [])
                }
                else {
                    var huesArray: NSArray = responseObject as NSArray
                    for item in huesArray {
                        
                    }
                }
            }
            else {
                completion(results: [])
            }
            
        },
        failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
			XCGLogger.defaultInstance().error("Error: " + error.localizedDescription);
        });
    }
    
}

