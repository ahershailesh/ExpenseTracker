//
//  CoreDataManager.swift
//  ExpenseTracker
//
//  Created by Shailesh Aher on 06/10/19.
//  Copyright © 2019 Shailesh Aher. All rights reserved.
//

import CoreData

final class CoreDataManager {

    private init() {  }
    
    public static let shared = CoreDataManager()
    
    lazy var container : NSPersistentContainer = {
        let instance = NSPersistentContainer(name: "ExpenseTracker")
        instance.loadPersistentStores { (description, error) in
            if let error = error {
                print(error)
            } else {
                print(description)
            }
        }
        return instance
    }()
    
    var context : NSManagedObjectContext {
        return container.viewContext
    }
    
    
    func save() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch let error {
                print(">>>>> Found error while saving \(error)")
            }
        }
    }
}
