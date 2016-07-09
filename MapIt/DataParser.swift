//
//  DataParser.swift
//  MapIt
//
//  Created by Genady Novak on 7/8/16.
//  Copyright © 2016 Gena. All rights reserved.
//

import Cocoa

class DataParser: NSObject {
    static let SharedInstance =  DataParser()
    var mCurrentXML : XMLRoot?
    private let XML_DATA_KEY = "XML_DATA_KEY"
    private let BOOKS_DATA_KEY = "BOOKS_DATA_KEY"


    
    final func processXML(FromPath path : String, andCompletion complition: (Bool)->()){
        
        let arr = NSUserDefaults.standardUserDefaults().objectForKey(self.XML_DATA_KEY) as? [String]
        if arr == nil || arr!.contains(path) == false{
            do{
                let content = try String(contentsOfFile: path, encoding: NSUTF8StringEncoding)
                if let data = content.dataUsingEncoding(NSUTF8StringEncoding){
                    
                    let taskQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)
                    
                    dispatch_async(taskQueue, {
                        let parser = NSXMLParser(data: data)
                        let xmlRoot = XMLRoot()
                        parser.delegate = xmlRoot
                        parser.parse()
                        
                        
                        do{
                            try NSFileManager.defaultManager().removeItemAtPath(path)
                            let data = NSKeyedArchiver.archivedDataWithRootObject(xmlRoot)
                            NSUserDefaults.standardUserDefaults().setObject(data, forKey: path)
                            if var arr = NSUserDefaults.standardUserDefaults().objectForKey(self.XML_DATA_KEY) as? [String]{
                                arr.append(path)
                                NSUserDefaults.standardUserDefaults().setObject(arr, forKey: self.XML_DATA_KEY)
                                
                            }
                            else{
                                let arr = [path]
                                NSUserDefaults.standardUserDefaults().setObject(arr, forKey: self.XML_DATA_KEY)
                            }
                            
                            NSUserDefaults.standardUserDefaults().synchronize()
                            self.mCurrentXML = xmlRoot
                            
                            complition(true)
                        }
                        catch{
                            Swift.print(error)
                            complition(false)
                        }
                        
                        
                    })
                    
                }
                
            }
            catch{
                Swift.print(error)
                complition(false)
            }
        }
        else{
            if let data = NSUserDefaults.standardUserDefaults().objectForKey(path) as? NSData{
                if let xmlRoot =  NSKeyedUnarchiver.unarchiveObjectWithData(data) as? XMLRoot{
                    self.mCurrentXML = xmlRoot
                    complition(true)
                }
                else{
                    complition(false)
                }
                
                
            }
            else{
                complition(false)
            }
            
        }
        
    }
    
    final func processBook(FromPath path : String, andCompletion complition : (Bool)->()){
        let NLPPath = NSBundle.mainBundle().pathForResource("stanford-corenlp-full-2015-12-09", ofType: nil)
        let splitedPath = path.componentsSeparatedByString("/")
        let fileName = splitedPath[splitedPath.count - 1]
        
        let arr = NSUserDefaults.standardUserDefaults().objectForKey(self.BOOKS_DATA_KEY) as? [String]
        if arr == nil || arr!.contains(fileName) == false{
            let fm = NSFileManager.defaultManager()
            do{
                try fm.copyItemAtPath(path, toPath: "\(NLPPath!)/\(fileName)")
                
                let taskQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)
                
                dispatch_async(taskQueue, {
                    
                    let splitedPath = path.componentsSeparatedByString("/")
                    let fileName = splitedPath[splitedPath.count - 1]
                    
                    let NLPPath = NSBundle.mainBundle().pathForResource("stanford-corenlp-full-2015-12-09", ofType: nil)
                    
                    let task = NSTask()
                    task.currentDirectoryPath = NLPPath!
                    task.launchPath = "/usr/bin/java"
                    task.arguments = ["-cp", "*" , "-Xmx2g" ,"edu.stanford.nlp.pipeline.StanfordCoreNLP", "-annotators", "tokenize,ssplit,pos,lemma,ner,parse,dcoref", "-file", fileName]
                    
                    task.launch()
                    
                    task.waitUntilExit()
                    
                    do{
                        try fm.removeItemAtPath("\(NLPPath!)/\(fileName)")
                        if task.terminationStatus == 0{
                            if var arr = NSUserDefaults.standardUserDefaults().objectForKey(self.BOOKS_DATA_KEY) as? [String]{
                                arr.append(fileName)
                                NSUserDefaults.standardUserDefaults().setObject(arr, forKey: self.BOOKS_DATA_KEY)
                            }
                            else{
                                let arr = [fileName]
                                NSUserDefaults.standardUserDefaults().setObject(arr, forKey: self.BOOKS_DATA_KEY)
                            }
                            NSUserDefaults.standardUserDefaults().synchronize()
                            complition(task.terminationStatus == 0)
                        }

                    }
                    catch{
                        Swift.print(error)
                        complition(false)
                    }
                    
                })
                
            }
            catch {
                complition(false)
            }
        }
        else{
            complition(true)
        }
        
        
        
    }
    
    final func clearAllData(){
        if var bookArr = NSUserDefaults.standardUserDefaults().objectForKey(self.BOOKS_DATA_KEY) as? [String]{
            bookArr.removeAll()
            NSUserDefaults.standardUserDefaults().setObject(bookArr, forKey: self.BOOKS_DATA_KEY)
        }
        if var xmlArr = NSUserDefaults.standardUserDefaults().objectForKey(self.XML_DATA_KEY) as? [String]{
            xmlArr.removeAll()
            NSUserDefaults.standardUserDefaults().setObject(xmlArr, forKey: self.XML_DATA_KEY)
        }
        NSUserDefaults.standardUserDefaults().synchronize()
    }

}
