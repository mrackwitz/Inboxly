import UIKit
import RealmSwift

//
// TODOs:
//
// * [x] Show the count of sent messages
//

class ProfileViewController: UIViewController {

    @IBOutlet weak var statsLabel: UILabel!
    
    lazy var stats: Results<Message> = {
        let realm = try! Realm()
        return realm.objects(Message).filter("name = %@", "me")
    }()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        statsLabel.text = "\(stats.count) sent messages"
    }
}
