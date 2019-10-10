//
//  Category+CoreDataProperties.swift
//  ExpenseTracker
//
//  Created by Shailesh Aher on 06/10/19.
//  Copyright © 2019 Shailesh Aher. All rights reserved.
//
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var title: String?
    @NSManaged public var tag: Tag?

}
