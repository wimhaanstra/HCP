// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Dimmer.swift instead.

import CoreData

enum DimmerAttributes: String {
    case dimValue = "dimValue"
}

@objc
class _Dimmer: Switch {

    // MARK: - Class methods

    override class func entityName () -> String {
        return "Dimmer"
    }

    override class func entity(managedObjectContext: NSManagedObjectContext!) -> NSEntityDescription! {
        return NSEntityDescription.entityForName(self.entityName(), inManagedObjectContext: managedObjectContext);
    }

    // MARK: - Life cycle methods

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    convenience init(managedObjectContext: NSManagedObjectContext!) {
        let entity = _Dimmer.entity(managedObjectContext)
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged
    var dimValue: NSNumber?

    // func validateDimValue(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    // MARK: - Relationships

}

