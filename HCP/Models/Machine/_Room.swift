// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Room.swift instead.

import CoreData

enum RoomAttributes: String {
    case name = "name"
    case order = "order"
}

enum RoomRelationships: String {
    case sensors = "sensors"
}

@objc
class _Room: NSManagedObject {

    // MARK: - Class methods

    class func entityName () -> String {
        return "Room"
    }

    class func entity(managedObjectContext: NSManagedObjectContext!) -> NSEntityDescription! {
        return NSEntityDescription.entityForName(self.entityName(), inManagedObjectContext: managedObjectContext);
    }

    // MARK: - Life cycle methods

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    convenience init(managedObjectContext: NSManagedObjectContext!) {
        let entity = _Room.entity(managedObjectContext)
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged
    var name: String?

    // func validateName(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var order: NSNumber?

    // func validateOrder(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    // MARK: - Relationships

    @NSManaged
    var sensors: NSSet

}

extension _Room {

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
