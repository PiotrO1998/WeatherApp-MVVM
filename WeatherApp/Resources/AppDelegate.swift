//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by Piotr Obara on 12/02/2023.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // Window that gets created when app loads app
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        let navVC = UINavigationController(rootViewController: SavedWeathersViewController())
        navVC.navigationBar.prefersLargeTitles = true
        navVC.viewControllers.first?.navigationItem.largeTitleDisplayMode = .always
        window.rootViewController = navVC
        
        if #available(iOS 13.0, *) {
            let customNavBarAppearnace = UINavigationBarAppearance()
            customNavBarAppearnace.configureWithOpaqueBackground()
            customNavBarAppearnace.backgroundColor = UIColor(named: "BackgroundColor")
            let apperance = UINavigationBar.appearance()
            //apperance.scrollEdgeAppearance = customNavBarAppearnace
            apperance.compactAppearance = customNavBarAppearnace
            apperance.standardAppearance = customNavBarAppearnace
        } else {
            UINavigationBar().backgroundColor = UIColor(named: "BackgroundColor")
            UINavigationBar().tintColor = UIColor(named: "BackgroundColor")
        }
        
        window.makeKeyAndVisible()
        self.window = window
        
        do {
            let _ = try Realm()
        } catch {
            print("Error initialisting new realm, \(error)")
        }
        
        // locate Realm database
        // print(Realm.Configuration.defaultConfiguration.fileURL)
        
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

