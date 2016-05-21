import UIKit
import RealmSwift

//
// Notes:
//
// Just needed for demonstration purposes
//

class ComposeViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        textView.becomeFirstResponder()
    }
    
    @IBAction func close(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func send(sender: AnyObject) {
        DataController.shared!.postMessage(textView.text)
        close(sender)
    }

}
