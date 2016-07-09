//
//  DataMenuItem.swift
//  MapIt
//
//  Created by Genady Novak on 7/9/16.
//  Copyright © 2016 Gena. All rights reserved.
//

import Cocoa

class DataMenuItem: NSObject {
    private let INIT_DB_KEY = "INIT_DB_KEY"

    @IBAction func clearData(sender: AnyObject) {
        DataParser.SharedInstance.clearAllData()
    }

    @IBAction func initDBWasPressed(sender: AnyObject) {
        let wasInit = NSUserDefaults.standardUserDefaults().boolForKey(self.INIT_DB_KEY)
        if wasInit == false{
            CoreDataManager.SharedInstance.initDBFromCSV(CSVPath: "/Users/novakgena/Desktop/GeoLiteCity-Location.csv", complition: { (success) in
                if success{
                    NSUserDefaults.standardUserDefaults().setBool(true, forKey: self.INIT_DB_KEY)
                }
            })
        }
    }
}
