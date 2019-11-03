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
                    dateFormater.dateFormat = "dd-MM-yyyy hh:mm:ss"
                    
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
    
    static func getMonthsExpense() -> [String: Int16] {
        let request : NSFetchRequest<Expense> = Expense.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "timeStamp", ascending: true)]
        let expenses = try? CoreDataManager.shared.context.fetch(request)
        var dictionary = [String: Int16]()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/YYYY"
        expenses?.forEach({ (expense) in
            if let date = expense.timeStamp {
                let dateString = formatter.string(from: date)
                let amount = dictionary[dateString] ?? 0
                dictionary[dateString] = amount + expense.spend
            }
        })
        return dictionary
    }
    
    static func getTotalExpense(ofMonth month: Int, andYear year: Int) -> Int {
        var components = DateComponents()
        components.month = month
        components.year = year
        
        let startDate = Calendar.current.date(from: components)
        
        components.year = 0
        components.month = 1
        components.day = -1
        
        let endDate = Calendar.current.date(byAdding: components, to: startDate!)
        
        let expenses = getExpenseBetween(date1: startDate!, date2: endDate!)
        let totalExpense = expenses.reduce(0, { (result, expense) -> Int in
            return result + Int(expense.spend)
        })
        return totalExpense
    }
    
    static func getExpenseBetween(date1: Date, date2: Date) -> [Expense] {
        let firstDate = date1 < date2 ? date1 : date2
        let secondDate = date2 > date1  ? date2 : date1
        
        let request : NSFetchRequest<Expense> = Expense.fetchRequest()
        let predicate = NSPredicate(format: "%K >= %@ && %K <= %@", "timeStamp", firstDate as NSDate, "timeStamp", secondDate as NSDate)
        request.predicate = predicate
        let expenses = try? CoreDataManager.shared.context.fetch(request)
        return expenses ?? []
    }
    
    static func getTodaysExpenses() -> [Expense] {
        let request : NSFetchRequest<Expense> = Expense.fetchRequest()
        let timeInterval = -(Int(Date().timeIntervalSince1970) % 86400)
        let predicate = NSPredicate(format: "timeStamp >= %@", NSDate(timeIntervalSinceNow: TimeInterval(timeInterval)))
        request.predicate = predicate
        let expenses = try? CoreDataManager.shared.context.fetch(request)
        return expenses ?? []
    }
    
    static func getLastUpdatedTimeStamp() -> Date? {
        let request : NSFetchRequest<Expense> = Expense.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "timeStamp", ascending: false)]
        request.fetchLimit = 1
        let expenses = try? CoreDataManager.shared.context.fetch(request)
        return expenses?.first?.timeStamp
    }
}
