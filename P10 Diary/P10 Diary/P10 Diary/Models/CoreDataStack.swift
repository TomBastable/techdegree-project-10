//
//  CoreDataStack.swift
//  Todolist
//
//  Created by Tom Bastable on 20/11/2019.
//  Copyright © 2019 Tom Bastable. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack{
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let container = self.persistentContainer
        return container.viewContext
    }()
    
    private lazy var persistentContainer: NSPersistentContainer = {
       let container = NSPersistentContainer(name: "P10_Diary")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error)")
            }
        }
        
        return container
    }()
    
}

extension NSManagedObjectContext {
    func saveChanges(){
        if self.hasChanges {
            do{
                try self.save()
            } catch {
                fatalError("\(error)")
            }
        }
    }
}
