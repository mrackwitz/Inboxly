import UIKit
import RealmSwift

//
// TODOs:
//
// * [x] Observe for new photos
// * [x] Load the photo from the bundle
//       (instead of an actual download)
// * [x] Write the data to a `Photo` model
//

class CacheController {
    var subscription: NotificationToken?
    let pendingPhotos: Results<Photo>

    init() {
        let realm = try! Realm()
        
        pendingPhotos = realm.objects(Photo).filter("image = nil")

        subscription = pendingPhotos.addNotificationBlock { [weak self] changes in
            self?.downloadPhotos()
        }
    }

    func downloadPhotos() {
        let realm = try! Realm()
        try! realm.write {
            for pending in pendingPhotos {
                print("[Cache] Download \(pending.url)")

                let image = UIImage(named: pending.url)! // faux download
                pending.image = UIImagePNGRepresentation(image)!
            }
        }
    }
    
    deinit {
        subscription?.stop()
    }
}
