//
//  ListItem.swift
//  sample2
//
//  Created by 渡邊 翔矢 on 2023/12/22.
//

// ToDoItemModel.swift

import Foundation
import CoreData

@objc(ToDoItemModel)
public class ToDoItemModel: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var descriptionText: String
    @NSManaged public var deadline: Date
    @NSManaged public var completed: Bool
}

extension ToDoItemModel {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoItemModel> {
        return NSFetchRequest<ToDoItemModel>(entityName: "ToDoItemModel")
    }
}


// PersistenceController.swift

import CoreData

class PersistenceController {
    static let shared = PersistenceController()
    
    static var preview: PersistenceController = {
        let result = PersistenceController()
        let viewContext = result.container.viewContext
        return result
    }()
    
    var container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "YourDataModelFileName")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}

