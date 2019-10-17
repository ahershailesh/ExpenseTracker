//
//  DataManger.swift
//  ExpenseTracker
//
//  Created by Shailesh Aher on 09/10/19.
//  Copyright © 2019 Shailesh Aher. All rights reserved.
//

import UIKit
import CoreData

class DataManger {
    
    static func setupData() {
        let context = CoreDataManager.shared.context
        if try! context.count(for: Tag.fetchRequest()) == 0 {
            if let path = Bundle.main.path(forResource: "DefaultData", ofType: "json"),
                let data = FileManager.default.contents(atPath: path),
                let categoryWithTags = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: [String]] {
                
                categoryWithTags.keys.forEach { (tagTitle) in
                    let tag = Tag(context: context)
                    tag.title = tagTitle
                    categoryWithTags[tagTitle]?.forEach({ (categoryTitle) in
                        let category = Category(context: context)
                        category.title = categoryTitle
                        category.tag = tag
                        tag.categories?.adding(category)
                    })
                }
                saveExpense()
            }
        }
    }
    
    private static func saveExpense() {
        var categories = [Category]()
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        let titleSortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [titleSortDescriptor]
        do {
            categories = try CoreDataManager.shared.context.fetch(request)
        } catch {
            print("Found error while fetching categories")
        }
        
        let context = CoreDataManager.shared.context
        if try! context.count(for: Expense.fetchRequest()) == 0 {
            if let path = Bundle.main.path(forResource: "ExpenseData", ofType: "json"),
            let data = FileManager.default.contents(atPath: path),
                let expenseDictArray = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [[String: String]] {
                
                
                expenseDictArray.forEach { (dict) in
                    let dateFormater = DateFormatter()
                    dateFormater.dateFormat = "dd-mm-yyyy hh:mm:ss"
                    
                    let expsense = Expense(context: context)
                    expsense.category = categories.first { $0.title == dict["category"]  }
                    if let dateString = dict["timeStamp"] {
                        expsense.timeStamp = dateFormater.date(from: dateString)
                    }
                    expsense.note = dict["note"]
                    if let spend = dict["spend"] {
                        expsense.spend = Int16(spend) ?? 0
                    }
                }
                CoreDataManager.shared.save()
            }
        }
    }
    
    static func getCategories(with title: String) -> [Category] {
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        if !title.isEmpty {
            request.predicate = NSPredicate(format: "title BEGINSWITH %@", title)
        }
        request.sortDescriptors = [NSSortDescriptor(key: "tag", ascending: true)]
        let categories = try? CoreDataManager.shared.context.fetch(request)
        return categories ?? []
    }
    
    static func getTags(with title: String) -> [Tag] {
        let request : NSFetchRequest<Tag> = Tag.fetchRequest()
        if !title.isEmpty {
            request.predicate = NSPredicate(format: "title BEGINSWITH %@", title)
        }
        let tags = try? CoreDataManager.shared.context.fetch(request)
        return tags ?? []
    }
    
    static func newTag(with title: String) -> Tag {
        let tag = Tag(context: CoreDataManager.shared.context)
        tag.title = title
        return tag
    }
    
    static func addExpense(_ model: ExpenseViewModel) {
        let expense = Expense(context: CoreDataManager.shared.context)
        expense.timeStamp = model.date
        expense.spend = model.expenseAmount ?? 0
        expense.category = getCategories(with: model.categoryName).first
        expense.note = model.note
        CoreDataManager.shared.save()
    }
}
