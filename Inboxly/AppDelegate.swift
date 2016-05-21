import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var dataController: DataController!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        Realm.Configuration.defaultConfiguration.deleteRealmIfMigrationNeeded = true

        dataController = DataController(api: StubbedInboxlyAPI(), cache: CacheController())
        dataController.startFetchingMessages()
        return true
    }
    
    func applicationWillTerminate(application: UIApplication) {
        dataController.stopFetchingMessages()
    }
}
