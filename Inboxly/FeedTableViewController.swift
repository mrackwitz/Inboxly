import UIKit
import RealmSwift

//
// TODOs:
//
// * [ ] Show auto-updating list of messages, where the outbox
//       and inbox should be displayed in separate table sections
//

class FeedTableViewController: UITableViewController {

    let realm = try! Realm()

    lazy var messages: Results<Message> = {
        self.realm.objects(Message).filter("outgoing = false and sent = false")
    }()

    var subscription: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()

        subscription = messages.addNotificationBlock { [weak self] _ in
            self?.tableView.reloadData()
        }
    }

    deinit {
        subscription?.stop()
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(messages.count) messages"
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
