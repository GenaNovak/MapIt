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
    
    
    
    final func getAllCities() -> [City]{
        do{
            let request = NSFetchRequest(entityName: "City")
            request.sortDescriptors = [NSSortDescriptor(key: "locId", ascending: false)]
        
            let cities = try self.stack.context.executeFetchRequest(request) as! [City]
            return cities
        }
        catch{
            Swift.print("\(error) \(#function)")
        }
        
        return []
    }
    
    final func getCitiesWithContext(CityName name : String ,AndContext context : [String]) -> [City]{
        do {
            let request = NSFetchRequest(entityName: "City")
            request.predicate = NSPredicate(format: "city == %@", "\"\(name)\"")
            request.sortDescriptors = [NSSortDescriptor(key: "locId", ascending: false)]
            var results = try self.stack.context.executeFetchRequest(request) as! [City]
            results = results.filter({ (city) -> Bool in
                city.region != nil && context.contains(city.region!.stringByReplacingOccurrencesOfString("\"", withString: ""))
            })
            if results.count > 0{
                Swift.print("here")
            }
            return results
        }catch{
            Swift.print("\(error) -> \(#function)")
        }
        return []
    }
    
    final func getCity(CityName name : String) -> [City]{
        do {
            let request = NSFetchRequest(entityName: "City")
            request.predicate = NSPredicate(format: "city == %@", "\"\(name)\"")
            request.sortDescriptors = [NSSortDescriptor(key: "locId", ascending: false)]
            let results = try self.stack.context.executeFetchRequest(request) as! [City]
            return results
        }catch{
            Swift.print("\(error) -> \(#function)")
        }
        return []
        
    }
    
    final func initDBFromCSV(CSVPath path : String, complition : (Bool) -> ()){
        let taskQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)
        
        dispatch_async(taskQueue, {
            
            do{
                
                let content = try String(contentsOfFile: path, encoding: NSMacOSRomanStringEncoding)
                let splitedFileContent = content.componentsSeparatedByString("\n")
                self.stack.context.retainsRegisteredObjects = true
                for line in splitedFileContent{
                    let splitedLine = line.componentsSeparatedByString(",")
                    if splitedLine.count > 8{
                        if let city = NSEntityDescription.insertNewObjectForEntityForName("City", inManagedObjectContext: self.stack.context) as? City{
                            city.setValue(NSNumber(integer: Int(splitedLine[0]) ?? -1), forKey: "locId")
                            city.setValue(splitedLine[1], forKey: "country")
                            city.setValue(splitedLine[2], forKey: "region")
                            city.setValue(splitedLine[3], forKey: "city")
                            city.setValue(NSNumber(integer: Int(splitedLine[4]) ?? -1), forKey: "postalCode")
                            city.setValue(NSNumber(double: Double(splitedLine[5]) ?? -1) , forKey: "latitude")
                            city.setValue(NSNumber(double: Double(splitedLine[6]) ?? -1), forKey: "longitude")
                            city.setValue(NSNumber(integer: Int(splitedLine[7]) ?? -1), forKey: "metroCode")
                            city.setValue(NSNumber(integer: Int(splitedLine[8]) ?? -1), forKey: "areaCode")
                            /*
                            city.locId = Int64(splitedLine[0]) ?? -1
                            city.country = splitedLine[1]
                            city.region = splitedLine[2]
                            city.city = splitedLine[3]
                            city.postalCode = Int64(splitedLine[4]) ?? -1
                            city.latitude = Double(splitedLine[5]) ?? -1
                            city.longitude = Double(splitedLine[6]) ?? -1
                            city.metroCode = Int64(splitedLine[7]) ?? -1
                            city.areaCode = Int64(splitedLine[8]) ?? -1
                            */

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
    
    final func clearDB(WithComplition complition : (Bool) -> ()){
        let fetchRequest = NSFetchRequest(entityName: "City")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try self.stack.context.executeRequest(deleteRequest)
//            try self.stack.coordinator.executeRequest(deleteRequest, withContext: self.stack.context)
            complition(true)
        } catch {
            Swift.print("\(error) -> \(#function)")
            complition(false)
        }
    }
    
}
