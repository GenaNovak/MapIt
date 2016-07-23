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
            
                let myFileDialog: NSOpenPanel = NSOpenPanel()
                myFileDialog.canChooseDirectories = true
                myFileDialog.runModal()
                
                // Get the path to the file chosen in the NSOpenPanel
                let path = myFileDialog.URL?.path
                
                // Make sure that a path was chosen
                if (path != nil && path != "") {
                    CoreDataManager.SharedInstance.initDBFromCSV(CSVPath: path!, complition: { (success) in
                        if success{
                            NSUserDefaults.standardUserDefaults().setBool(true, forKey: self.INIT_DB_KEY)
                        }
                    })
                }
        }
    }
    
    @IBAction func clearDBWasPressed(sender: AnyObject) {
        CoreDataManager.SharedInstance.clearDB { (success) in
            if success{
                NSUserDefaults.standardUserDefaults().setBool(false, forKey: self.INIT_DB_KEY)
            }
        }
    }
    
    @IBAction func clearBadCitiesWasPressed(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setObject([], forKey: "BedResultsArr")
    }
    @IBAction func openWasPressed(sender: AnyObject) {
        let myFileDialog: NSOpenPanel = NSOpenPanel()
        myFileDialog.canChooseDirectories = true
        myFileDialog.runModal()
        
        // Get the path to the file chosen in the NSOpenPanel
        let path = myFileDialog.URL?.path
        let extention = myFileDialog.URL?.pathExtension
        
        // Make sure that a path was chosen
        if (path != nil && path != "" && extention == "txt") {
            DataParser.SharedInstance.processBook(FromPath: path!, andCompletion: { (success) in
                if success{
                    let splitedPath = path!.componentsSeparatedByString("/")
                    let fileName = splitedPath[splitedPath.count - 1]
                    
                    let NLPPath = NSBundle.mainBundle().pathForResource("stanford-corenlp-full-2015-12-09", ofType: nil)
                    let outputPath = "\(NLPPath!)/\(fileName).out"
                    DataParser.SharedInstance.processXML(FromPath: outputPath, andCompletion: { (success) in
                        if success{
                            
                        }
                        else{
                            
                        }
                    })
                }
                else{
                    
                }
            })
        }
    }
}
