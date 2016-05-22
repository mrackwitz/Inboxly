import Foundation
import RealmSwift

//
// TODOs:
//
// * [ ] In `fetch(_)`: Retrieve messages from API and store objects in realm
// * [ ] in `postMessage(_)` show how instead of calling the network just store in realm
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
        //<#Needs to be implemented.#>
    }
        
    func postMessage(message: String) {
        //<#Needs to be implemented.#>
    }
}
