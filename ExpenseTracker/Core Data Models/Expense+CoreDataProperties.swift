//
//  Expense+CoreDataProperties.swift
//  ExpenseTracker
//
//  Created by Shailesh Aher on 06/10/19.
//  Copyright © 2019 Shailesh Aher. All rights reserved.
//
//

import Foundation
import CoreData


extension Expense {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expense> {
        return NSFetchRequest<Expense>(entityName: "Expense")
    }

    @NSManaged public var spend: Int16
    @NSManaged public var note: String?
    @NSManaged public var timeStamp: Date?
    @NSManaged public var category: Category?

}
