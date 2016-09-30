import UIKit
import RealmSwift

//
// TODOs:
//
// * [x] Show auto-updating list of messages, where the outbox
//       and inbox should be displayed in separate table sections
//

class FeedTableViewController: UITableViewController {

    let realm = try! Realm()
    
    lazy var messages: [Results<Message>] = {
        let messages = self.realm.objects(Message).filter("sent = false")
        return [
            messages.filter("outgoing = true").sorted("createdAt", ascending: true),
            messages.filter("outgoing = false").sorted("createdAt", ascending: false)
        ]
    }()
    
    var subscriptions = [NotificationToken?]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for (i, result) in messages.enumerate() {
            let token = result.addNotificationBlock { [weak self] changes in
                guard let `self` = self else { return }

                switch changes {
                    case .Initial:
                        // Results are now populated and can be accessed without blocking the UI
                        self.tableView.reloadData()
                        break
                    case .Update(_, let deletions, let insertions, let modifications):
                        // Query results have changed, so apply them to the TableView
                        self.tableView.beginUpdates()
                        self.tableView.insertRowsAtIndexPaths(insertions.map { NSIndexPath(forRow: $0, inSection: i) },
                            withRowAnimation: .Automatic)
                        self.tableView.deleteRowsAtIndexPaths(deletions.map { NSIndexPath(forRow: $0, inSection: i) },
                            withRowAnimation: .Automatic)
                        self.tableView.reloadRowsAtIndexPaths(modifications.map { NSIndexPath(forRow: $0, inSection: i) },
                            withRowAnimation: .Automatic)
                        self.tableView.endUpdates()
                        self.tableView.reloadData()
                        break
                    case .Error(let err):
                        // An error occurred while opening the Realm file on the background worker thread
                        fatalError("\(err)")
                        break
                }

                if let lastMessageCount = self.lastMessageCount where self.messages[1].count > lastMessageCount {
                    self.navigationController!.tabBarItem.badgeValue = "\(self.messages[1].count - lastMessageCount)"
                }
            }
            subscriptions.append(token)
        }
    }
    
    deinit {
        for token in subscriptions {
            token?.stop()
        }
    }
    
    
    var lastMessageCount: Int?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        lastMessageCount = nil
        navigationController!.tabBarItem.badgeValue = nil
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        lastMessageCount = messages[1].count
    }
}

// MARK: - UITableViewDelegate and UITableViewDataSource implementation

extension FeedTableViewController {
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if messages[section].count == 0 {
            return nil
        }
        let sectionTitle = ["Outgoing", "Messages"][section]
        return "\(messages[section].count) \(sectionTitle)"
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return messages.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages[section].count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let message = messages[indexPath.section][indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier(FeedTableViewCell.reuseIdentifier, forIndexPath: indexPath) as! FeedTableViewCell
        cell.configureWithMessage(message)
        return cell
    }

}
