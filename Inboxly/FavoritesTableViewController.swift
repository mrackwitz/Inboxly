import UIKit
import RealmSwift

//
// TODOs:
//
// * [x] Show favorite messages, not auto-updating
//

class FavoritesTableViewController: UITableViewController {

    var subscription: NotificationToken?
    
    lazy var messages: Results<Message> = {
        let realm = try! Realm()
        return realm.objects(Message).filter("favorite = true").sorted("createdAt", ascending: false)
    }()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        subscription = messages.addNotificationBlock { [weak self] changes in
            self?.tableView.reloadDataAnimated()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        subscription?.stop()
    }
}

extension FavoritesTableViewController {
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(self.messages.count) favorites"
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier(FeedTableViewCell.reuseIdentifier, forIndexPath: indexPath) as! FeedTableViewCell
        cell.configureWithMessage(message)
        return cell
    }

}
