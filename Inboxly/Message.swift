import Foundation
import RealmSwift

class Message: Object {
    dynamic var id = ""
    dynamic var message = ""
    dynamic var name = ""
    dynamic var photo: Photo?
    dynamic var favorite = false
    dynamic var createdAt = NSDate()

    // State
    dynamic var outgoing = false
    dynamic var sent = false
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override class func indexedProperties() -> [String] {
        return ["outgoing", "favorite"]
    }
}
