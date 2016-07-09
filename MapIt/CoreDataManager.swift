//
//  CoreDataManager.swift
//  MapIt
//
//  Created by Genady Novak on 7/9/16.
//  Copyright © 2016 Gena. All rights reserved.
//

import Cocoa
import CoreData

class CoreDataManager: NSObject{
    
    static let SharedInstance = CoreDataManager()
    
    lazy var stack : CoreDataStack = CoreDataStack(
        modelName:"MapIt",
        storeName:"MapIt",
        options:[NSMigratePersistentStoresAutomaticallyOption: true,
            NSInferMappingModelAutomaticallyOption: true])
    
    lazy var cities : NSFetchRequest = {
        let request = NSFetchRequest(entityName: "City")
        request.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: false)]
//        let notes = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.stack.context, sectionNameKeyPath: nil, cacheName: nil)
        return request
    }()
    
    
    final func getAllCities(){
        do{
            let request = NSFetchRequest(entityName: "City")
            request.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: false)]
        
            try self.stack.context.executeRequest(request)
        }
        catch{
            Swift.print("\(error) \(#function)")
        }
        
    }
}
