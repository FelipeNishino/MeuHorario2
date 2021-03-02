//
//  AppDelegate.swift
//  MeuHorario
//
//  Created by Felipe Nishino on 18/02/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.        
        //Create a window that is the same size as the screen
        window = UIWindow(frame: UIScreen.main.bounds)
        // Create a view controller
        let viewController = WrapperViewController()
//        let nav = UINavigationController()
//        nav.pushViewController(viewController, animated: false)
        // Assign the view controller as `window`'s root view controller
        window?.rootViewController = viewController
        // Show the window
        window?.makeKeyAndVisible()
        
//        guard let url = URL(string: "http://sistemasparainternet.azurewebsites.net/nasa/getCursos.php") else {
//            return false
//        }
//
//        URLSession.shared.dataTask(with: url) { data, resp, err in
//            if err != nil {
//                            DispatchQueue.main.async {
//                                print(err!)
//                            }
//                            return
//                        }
//
//                        let aulas = try? JSONDecoder().decode([Personagem].self, from: data!)
//                        DispatchQueue.main.async {
//                        }
//
//                    }.resume()
//        }
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}
