
import SwiftUI
import SwiftData
import UserNotifications // Have to import this to use notification. 

@main
struct LifeSyncApp: App {
    @UIApplicationDelegateAdaptor (AppDelegate.self) var appDelegate
    
    var body: some Scene {
        @StateObject var viewModel = JournalViewModel()
        
        WindowGroup {
            MainTabBarView(viewModel: viewModel)
                .modelContainer(for: [stressLog.self, summaryLog.self, metricsLog.self]) // Adding models
        } // https://qiita.com/dokozon0/items/0c46c432b2e873ceeb04
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
        
        let tabBarAppearance = UITabBarAppearance() // create UITabBarAppearance Object
        tabBarAppearance.configureWithDefaultBackground() // set default color
        tabBarAppearance.backgroundColor = UIColor(light: .lightPrim, dark: .darkPrim) // customize the color
        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = UIColor(light: .lightShade, dark: .darkTint) // src:
        
        //https://qiita.com/maeken_0216/items/8e098c669ff9f84b569e
        UITabBar.appearance().standardAppearance = tabBarAppearance // standard appearance applies when scrolling
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
                
        return true
        
        
    }
    
} // https://tech.nri-net.com/entry/Implementation_of_notification


// Create notification
public func setNotification(hour: Int, minute: Int, identifier: String)  {
    
    do {
        let content = UNMutableNotificationContent()
        let dateComponent = DateComponents(hour: hour, minute: minute)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true) // https://appdev-room.com/swift-notification-date  
        
        content.title = "How are you feeling?"
        content.body = "Open the app to record"
        content.sound = UNNotificationSound.default
        content.badge = 0
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
        
    } 
}

// Remove notifications if toggle is off.




