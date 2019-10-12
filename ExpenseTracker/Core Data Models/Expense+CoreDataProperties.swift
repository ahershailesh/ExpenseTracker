//
//  Expense+CoreDataProperties.swift
//  ExpenseTracker
//
//  Created by Shailesh Aher on 10/10/19.
//  Copyright © 2019 Shailesh Aher. All rights reserved.
//
//

import Foundation
import CoreData


extension Expense {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expense> {
        return NSFetchRequest<Expense>(entityName: "Expense")
    }

    @NSManaged public var note: String?
    @NSManaged public var spend: Int16
    @NSManaged public var timeStamp: Date?
    @NSManaged public var category: Category?
    
    @objc var dateString : String {
           let formatter = DateFormatter()
           formatter.dateFormat = "dd MMMM YYYY"
           if let timeStamp = timeStamp {
               return formatter.string(from: timeStamp)
           }
           return ""
       }

}
