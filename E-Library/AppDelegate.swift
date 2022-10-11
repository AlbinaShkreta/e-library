//
//  AppDelegate.swift
//  E-Library
//
//  Created by Albina Shkreta on 17.9.22.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.start()
        IQKeyboardManager.shared.enable = true
        return true
    }
    
    func start(){
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let storyboard = UIStoryboard.init(name: "Login", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let navigationController = UINavigationController.init(rootViewController: viewController)
        self.window?.rootViewController = navigationController
        navigationController.isNavigationBarHidden = true
        self.window?.makeKeyAndVisible()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "E_Library")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

