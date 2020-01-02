import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Create the SwiftUI view that provides the window contents.
        let tipsy = Tipsy().environmentObject(Bill())
        
//        if UserDefaults.standard.bool(forKey: "forceLightMode") {
//            keypadView = AnyView(keypadView.environment(\.colorScheme, .light))
//        } else if UserDefaults.standard.bool(forKey: "forceDarkMode") {
//            keypadView = AnyView(keypadView.environment(\.colorScheme, .dark))
//        }

        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: tipsy)
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}
