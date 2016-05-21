import Foundation
import RealmSwift

//
// TODOs:
//
// * [x] In `fetch(_)`: Retrieve messages from API and store objects in realm
// * [x] in `postMessage(_)` show how instead of calling the network just store in realm
//

class DataController {
    private let api: InboxlyAPI
    private let cache: CacheController
    
    weak static var shared: DataController?

    static let meUrl = "me@2x.png"

    init(api: InboxlyAPI, cache: CacheController) {
        self.api = api
        self.cache = cache
        
        DataController.shared = self
    }
    
    private lazy var timer: NSTimer = {
        return NSTimer.scheduledTimerWithTimeInterval(20, target: self, selector: #selector(fetch), userInfo: nil, repeats: true)
    }()
    
    func startFetchingMessages() {
        fetch(timer)
    }
    
    func stopFetchingMessages() {
        timer.invalidate()
    }
    
    @objc private func fetch(timer: NSTimer) {
        api.getMessages { jsonObjects in
            let realm = try! Realm()
            
            try! realm.write {
                for object in jsonObjects {
                    let url = object["image"] as! String
                    let photo = realm.objectForPrimaryKey(Photo.self, key: url) ?? Photo(value: ["url": url])
                    
                    let message = Message(value: object)
                    message.photo = photo
                    realm.add(message, update: true)
                }
            }
            
            print("saved \(jsonObjects.count) new messages")
        }
    }
        
    func postMessage(message: String) {
        let meUrl = "me@2x.png"
        let newId = NSUUID().UUIDString
        
        let realm = try! Realm()

        let new = Message()
        new.id = newId
        new.message = message
        new.name = "me"
        new.photo = realm.objectForPrimaryKey(Photo.self, key: meUrl) ?? Photo(value: ["url": meUrl])
        new.outgoing = true
        
        try! realm.write {
            realm.add(new)
        }
        
        // faux sending - it just changes the message state in 5secs
        delay(seconds: 5, completion: {
            let realm = try! Realm()
            if let message = realm.objectForPrimaryKey(Message.self, key: newId) {
                try! realm.write {
                    message.sent = true
                }
            }
        })
    }
}
