import UIKit

extension UITableView {
    func reloadDataAnimated() {
        UIView.transitionWithView(self, duration: 0.33, options: .TransitionCrossDissolve, animations: {
                self.reloadData()
            }, completion: nil)
    }
}