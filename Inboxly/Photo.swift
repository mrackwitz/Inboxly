import Foundation
import RealmSwift

class Photo: Object {
    dynamic var url = ""
    dynamic var image: NSData?
    
    override static func primaryKey() -> String? {
        return "url"
    }
}
