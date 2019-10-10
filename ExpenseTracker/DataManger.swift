//
//  DataManger.swift
//  ExpenseTracker
//
//  Created by Shailesh Aher on 09/10/19.
//  Copyright © 2019 Shailesh Aher. All rights reserved.
//

import UIKit

class DataManger {
    
    static func setupData() {
        let context = CoreDataManager.shared.context
        if try! context.count(for: Tag.fetchRequest()) == 0 {
            if let path = Bundle.main.path(forResource: "DefaultData", ofType: "json"),
                let data = FileManager.default.contents(atPath: path),
                let categoryWithTags = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: [String]] {
                
                categoryWithTags.keys.forEach { (tagTitle) in
                    let tag = Tag(context: context)
                    categoryWithTags[tagTitle]?.forEach({ (categoryTitle) in
                        let category = Category(context: context)
                        category.title = categoryTitle
                        tag.categories?.adding(category)
                    })
                }
                CoreDataManager.shared.save()
            }
        }
    }
}
