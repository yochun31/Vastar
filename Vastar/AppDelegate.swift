//
//  AppDelegate.swift
//  Vastar
//
//  Created by 郭堯彰 on 2021/5/31.
//

import UIKit
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        Thread.sleep(forTimeInterval: 1)
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.previousNextDisplayMode = IQPreviousNextDisplayMode.alwaysHide
        
        let navBar = UINavigationBar.appearance()
        navBar.tintColor = UIColor.white
        navBar.barTintColor = UIColor.init(red: 0.0/255.0, green: 62.0/255.0, blue: 39.0/255.0, alpha: 1.0)
        
        //Change navigation title Color
        navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        if #available(iOS 13.0, *) {
            
        }else {
            let rootVC = LoginViewController(nibName: "LoginViewController", bundle: nil)
            rootVC.modalPresentationStyle = .fullScreen
            
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.rootViewController = rootVC
            window?.makeKeyAndVisible()
        }

        return true
    }
    

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

