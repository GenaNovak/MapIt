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
    
    final func getCity(CityName name : String) -> NSPersistentStoreResult?{
        do {
            let request = NSFetchRequest(entityName: "City")
            request.predicate = NSPredicate(format: "name=\(name)")
            request.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: false)]
            let results = try self.stack.context.executeRequest(request)
            return results
        }catch{
            Swift.print("\(error) -> \(#function)")
        }
        return nil
    }
    
    final func initDBFromCSV(CSVPath path : String, complition : (Bool) -> ()){
        let taskQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)
        
        dispatch_async(taskQueue, {
            
            do{
                
                let content = try String(contentsOfFile: path, encoding: NSUTF8StringEncoding)
                let splitedFileContent = content.componentsSeparatedByString("\n")
                for line in splitedFileContent{
                    let splitedLine = line.componentsSeparatedByString(",")
                    if splitedLine.count > 8{
                        if let city = NSEntityDescription.insertNewObjectForEntityForName("City", inManagedObjectContext: self.stack.context) as? City{
                            city.locId = Int64(splitedLine[0])!
                            city.country = splitedLine[1]
                            city.region = splitedLine[2]
                            city.country = splitedLine[3]
                            city.postalCode = Int64(splitedLine[4])!
                            city.latitude = Double(splitedLine[5])!
                            city.longitude = Double(splitedLine[6])!
                            city.metroCode = Int64(splitedLine[7])!
                            city.areaCode = Int64(splitedLine[8])!
                            
                            try self.stack.context.save()
                        }
                        
                    }
                    else{
                        Swift.print(line)
                    }
                }
                complition(true)
            }
            catch
            {
                Swift.print("\(error) -> \(#function)")
                complition(false)
            }
            
            
            
        })
    
        
    }
    
    
}
