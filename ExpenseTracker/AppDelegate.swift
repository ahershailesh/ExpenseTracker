//
//  AppDelegate.swift
//  ExpenseTracker
//
//  Created by Shailesh Aher on 28/09/19.
//  Copyright © 2019 Shailesh Aher. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        loadPersistanceStore()
        return true
    }

    private func loadPersistanceStore() {
        _ = CoreDataManager.shared.container.loadPersistentStores(completionHandler: { (_, _) in
            DataManger.setupData()
        })

    }
    
}

