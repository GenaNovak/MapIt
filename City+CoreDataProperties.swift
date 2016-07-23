//
//  City+CoreDataProperties.swift
//  MapIt
//
//  Created by Genady Novak on 7/9/16.
//  Copyright © 2016 Gena. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension City {

    @NSManaged var locId: Int64
    @NSManaged var country: String?
    @NSManaged var region: String?
    @NSManaged var city: String?
    @NSManaged var postalCode: Int64
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
    @NSManaged var metroCode: Int64
    @NSManaged var areaCode: Int64
    
    

}
