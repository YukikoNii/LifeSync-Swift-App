
import SwiftUI
import SwiftData
import UserNotifications // Have to import this to use notification. 

@main
struct JournalApp: App {
    @UIApplicationDelegateAdaptor (AppDelegate.self) var appDelegate
    
    var body: some Scene {
        @StateObject var viewModel = JournalViewModel()
        
        WindowGroup {
            JournalView(viewModel: viewModel)
                .modelContainer(for: [stressLog.self, daySummary.self, dailyFactorsLog.self]) // Adding models
        } // https://qiita.com/dokozon0/items/0c46c432b2e873ceeb04 これをしないとクラッシュするらしい。

    }
}

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound]) 
        { (granted, _) in
            if granted {
                UNUserNotificationCenter.current().delegate = self
            }
        }
        return true
    }
} // https://tech.nri-net.com/entry/Implementation_of_notification


// Create notification
public func notification() async {
    do {
        let content = UNMutableNotificationContent()
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false) // runs 5 seconds later if in the background
        
        content.title = "How are you feeling?"
        content.body = "Open the app to record"
        content.sound = UNNotificationSound.default
        content.badge = 1 // Badge appears in the home at the top right of the logo
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        try await UNUserNotificationCenter.current().add(request)
    } catch {
        print(error)
    }
}
