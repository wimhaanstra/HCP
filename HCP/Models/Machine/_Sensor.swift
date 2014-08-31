// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Sensor.swift instead.

import CoreData

enum SensorRelationships: String {
    case controller = "controller"
}

@objc
class _Sensor: NSManagedObject {

    // MARK: - Class methods

    class func entityName () -> String {
        return "Sensor"
    }

    class func entity(managedObjectContext: NSManagedObjectContext!) -> NSEntityDescription! {
        return NSEntityDescription.entityForName(self.entityName(), inManagedObjectContext: managedObjectContext);
    }

    // MARK: - Life cycle methods

    override init(entity: NSEntityDescription!, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    convenience init(managedObjectContext: NSManagedObjectContext!) {
        let entity = _Sensor.entity(managedObjectContext)
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    }

    // MARK: - Properties

    // MARK: - Relationships

    @NSManaged
    var controller: Controller?

    // func validateController(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

}

