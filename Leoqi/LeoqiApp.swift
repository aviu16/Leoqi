import SwiftUI
import UnityAds
import UIKit

// Define your AppDelegate class to handle Unity Ads initialization
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UnityAds.initialize("5587650", testMode: true)
        return true
    }
}

@main
struct LeoqiApp: App {
    // Connect the AppDelegate to your SwiftUI app
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            HomeScreenView()
        }
    }
}
