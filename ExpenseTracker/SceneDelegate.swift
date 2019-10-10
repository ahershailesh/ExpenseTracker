//
//  SceneDelegate.swift
//  ExpenseTracker
//
//  Created by Shailesh Aher on 28/09/19.
//  Copyright © 2019 Shailesh Aher. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var tabBarController : UITabBarController?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        setupTabbar()
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = tabBarController
        window!.makeKeyAndVisible()
        window?.windowScene = windowScene
        
        loadPersistanceStore()
    }
    
    private func setupTabbar() {
        tabBarController = UITabBarController()
        let homeViewController = HomeViewController()
        
        homeViewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "home"), selectedImage: UIImage(named: "home-selected"))
        
        let historyViewController = HistoryViewController()
        historyViewController.tabBarItem = UITabBarItem(title: "History", image: UIImage(named: "history"), selectedImage: UIImage(named: "history-selected"))
        
        let settingsViewController = SettingsViewController()
        settingsViewController.tabBarItem =
            
            UITabBarItem(title: "Settings", image: UIImage(named: "settings"), selectedImage: UIImage(named: "settings-selected"))
        
        tabBarController?.viewControllers = [UINavigationController(rootViewController: homeViewController), UINavigationController(rootViewController: historyViewController), UINavigationController(rootViewController: settingsViewController)]
        
    }
    
    private func loadPersistanceStore() {
        _ = CoreDataManager.shared.container.loadPersistentStores(completionHandler: { (_, _) in
            DataManger.setupData()
        })

    }
}

