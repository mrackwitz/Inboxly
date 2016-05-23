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

    lazy var realm = try! Realm()

    lazy var pendingPhotos: Results<Photo> = {
        self.realm.objects(Photo).filter("image = nil")
    }()

    var subscription: NotificationToken?

    init() {
        subscription = pendingPhotos.addNotificationBlock { [weak self] _ in
            self?.downloadPhotos()
        }
    }

    func downloadPhotos() {
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
