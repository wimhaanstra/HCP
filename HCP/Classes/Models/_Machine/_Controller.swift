// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Controller.swift instead.

import CoreData

enum ControllerAttributes: String {
    case available = "available"
    case ip = "ip"
    case lastUpdate = "lastUpdate"
    case name = "name"
    case version = "version"
}

enum ControllerRelationships: String {
    case sensors = "sensors"
}

@objc
class _Controller: NSManagedObject {

    // MARK: - Class methods

    class func entityName () -> String {
        return "Controller"
    }

    class func entity(managedObjectContext: NSManagedObjectContext!) -> NSEntityDescription! {
        return NSEntityDescription.entityForName(self.entityName(), inManagedObjectContext: managedObjectContext);
    }

    // MARK: - Life cycle methods

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    convenience init(managedObjectContext: NSManagedObjectContext!) {
        let entity = _Controller.entity(managedObjectContext)
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged
    var available: NSNumber?

    // func validateAvailable(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var ip: String?

    // func validateIp(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var lastUpdate: NSDate?

    // func validateLastUpdate(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var name: String?

    // func validateName(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var version: String?

    // func validateVersion(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    // MARK: - Relationships

    @NSManaged
    var sensors: NSSet

}

extension _Controller {

    func addSensors(objects: NSSet) {
        let mutable = self.sensors.mutableCopy() as NSMutableSet
        mutable.unionSet(objects)
        self.sensors = mutable.copy() as NSSet
    }

    func removeSensors(objects: NSSet) {
        let mutable = self.sensors.mutableCopy() as NSMutableSet
        mutable.minusSet(objects)
        self.sensors = mutable.copy() as NSSet
    }

    func addSensorsObject(value: Sensor!) {
        let mutable = self.sensors.mutableCopy() as NSMutableSet
        mutable.addObject(value)
        self.sensors = mutable.copy() as NSSet
    }

    func removeSensorsObject(value: Sensor!) {
        let mutable = self.sensors.mutableCopy() as NSMutableSet
        mutable.removeObject(value)
        self.sensors = mutable.copy() as NSSet
    }

}
