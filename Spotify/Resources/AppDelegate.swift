//
//  AppDelegate.swift
//  Spotify
//
//  Created by Michael Chen on 2/22/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //added this after removing storyboard
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        //is user is signed in go to tabBarViewcontroller
        if AuthManager.shared.isSignedIn {
            //if user is signed in start refreshing the access token
            AuthManager.shared.refreshIfNeeded(completion: nil)
            window.rootViewController = TabBarViewController()
        }
        else{
            let navVC = UINavigationController(rootViewController: WelcomeViewController())
            navVC.navigationBar.prefersLargeTitles = true
            navVC.viewControllers.first?.navigationItem.largeTitleDisplayMode = .always
            window.rootViewController = navVC
        }
        
        window.makeKeyAndVisible()
        self.window = window
        
//        AuthManager.shared.refreshIfNeeded { (success) in
//            print(success)
//        }
        
        //print(AuthManager.shared.signInURL?.absoluteString)
        
        // Override point for customization after application launch.
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

