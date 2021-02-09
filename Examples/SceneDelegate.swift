import UIKit
import SwiftUI
import SwiftUIRefresh

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        let contentView = NavigationView {
            RefreshableScrollView {
                
                Text("Text 1")
                Text("Text 2")
                Text("Text 3")
            } onRefresh: { completion in
                debugPrint("Start Refreshing")
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    debugPrint("End Refreshing")
                    completion()
                }
            }
            .navigationBarTitle("Your items")
        }
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}
