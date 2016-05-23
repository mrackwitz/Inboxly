import UIKit
import RealmSwift

//
// TODOs:
//
// * [ ] (Un)Favorize the message in `toggleLike`
// * [ ] Observe the image cache in `configureWithMessage` and
//       refresh the table cell image once the image is downloaded
//

class FeedTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "FeedTableViewCell"
    
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    var message: Message? {
        didSet {
            photoSubscription?.stop()
        }
    }

    var photoSubscription: NotificationToken?

    func configureWithMessage(message: Message) {
        self.message = message
        
        nameLabel.text = message.name
        messageLabel.text = message.message
        likeButton.selected = message.favorite
        if let imageData = message.photo?.image {
            photoView.image = UIImage(data: imageData)
        } else {
            let realm = try! Realm()
            let photos = realm.objects(Photo).filter("url = %@ && image != nil", message.photo!.url)

            photoSubscription = photos.addNotificationBlock { [weak self] _ in
                if let imageData = photos.first?.image {
                    self?.photoView.image = UIImage(data: imageData)
                }
            }
        }
    }
    
    @IBAction func toggleLike(sender: AnyObject) {
        //<#Needs to be implemented.#>
    }

    deinit {
        photoSubscription?.stop()
    }
}
