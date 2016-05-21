import UIKit
import RealmSwift

//
// TODOs:
//
// * [x] (Un)Favorize the message in `toggleLike`
// * [x] Observe the image cache in `configureWithMessage` and
//       refresh the table cell image once the image is downloaded
//

class FeedTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "FeedTableViewCell"
    
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    var message: Message?
    var photoToken: NotificationToken?
    
    override func prepareForReuse() {
        photoView.image = nil
        photoToken?.stop()
    }
    
    func configureWithMessage(message: Message) {
        self.message = message
        
        nameLabel.text = message.name
        messageLabel.text = message.message
        likeButton.selected = message.favorite
        
        if let imageData = message.photo?.image {
            photoView.image = UIImage(data: imageData)!
        } else {
            let realm = try! Realm()
            let photo = realm.objects(Photo).filter("url = %@", message.photo!.url)

            photoToken = photo.addNotificationBlock { [weak self] _ in
                if let imageData = message.photo?.image {
                    dispatch_async(dispatch_get_main_queue()) {
                        self?.photoView.image = UIImage(data: imageData)!
                    }
                }
            }
        }
    }
    
    deinit {
        photoToken?.stop()
    }
    
    @IBAction func toggleLike(sender: AnyObject) {
        let realm = try! Realm()
        try! realm.write {
            if let message = message {
                likeButton.selected = !likeButton.selected
                message.favorite = likeButton.selected
            }
        }
    }
}
