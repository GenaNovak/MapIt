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
    var mContenxtStates : [String : Int] = [:]
    var mCurrentSentence : Int = 0
    private var mPinnedCities : [String : String] = [:]
    private let mUSStates = [
        "Alabama" : "AL",
        "Alaska" : "AK",
        "Arizona" : "AZ",
        "Arkansas" : "AR",
        "California" : "CA",
        "Colorado" : "CO",
        "Connecticut" : "CT",
        "Delaware" : "DE",
        "District of Columbia" : "DC",
        "Florida" : "FL",
        "Georgia" : "GA",
        "Hawaii" : "HI",
        "Idaho" : "ID",
        "Illinois" : "IL",
        "Indiana" : "IN",
        "Iowa" : "IA",
        "Kansas" : "KS",
        "Kentucky" : "KY",
        "Louisiana" : "LA",
        "Maine" : "ME",
        "Maryland" : "MD",
        "Massachusetts" : "MA",
        "Michigan" : "MI",
        "Minnesota" : "MN",
        "Mississippi" : "MS",
        "Missouri" : "MO",
        "Montana" : "MT",
        "Nebraska" : "NE",
        "Nevada" : "NV",
        "New Hampshire" : "NH",
        "New Jersey" : "NJ",
        "New Mexico" : "NM",
        "New York" : "NY",
        "North Carolina" : "NC",
        "North Dakota" : "ND",
        "Ohio" : "OH",
        "Oklahoma" : "OK",
        "Oregon" : "OR",
        "Pennsylvania" : "PA",
        "Puerto Rico" : "PR",
        "Rhode Island" : "RI",
        "South Carolina" : "SC",
        "South Dakota" : "SD",
        "Tennessee" : "TN",
        "Texas" : "TX",
        "Utah" : "UT",
        "Vermont" : "VT",
        "Virginia" : "VA",
        "Washington" : "WA",
        "West Virginia" : "WV",
        "Wisconsin" : "WI",
        "Wyoming": "WY"
    ]
    private let XML_DATA_KEY = "XML_DATA_KEY"
    private let BOOKS_DATA_KEY = "BOOKS_DATA_KEY"

    private func reverseDictionary(FromDic dic : [String : String]) -> [String : String]{
        var toReturn : [String : String] = [:]
        for key in dic.keys{
            toReturn[dic[key]!] = key
        }
        
        return toReturn
    }
    
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
    
    
    final func getAllLocations()->[(String, ParserTree, Int)]{
        var locationTokens : [(String, ParserTree, Int)] = []
        if let data = DataParser.SharedInstance.mCurrentXML{
            if let dataIn = data.mRoot{
                if let document = dataIn.mDocument{
                    if let sentence = document.mSentences{
                        let sentenceArr = sentence.mSentences
                        for sen in sentenceArr{
                            if let tokens = sen.mTokens{
                                var skipCount = 0
                                for (index,token) in tokens.mTokens.enumerate(){
                                    if skipCount > 0{
                                        skipCount -= 1
                                        continue
                                    }
                                    else if token.mNER == "LOCATION"{
                                        var location = token.mWord
                                        if index < tokens.mTokens.count - 1 && tokens.mTokens[index + 1].mNER == "LOCATION"{
                                            location += " \(tokens.mTokens[index + 1].mWord)"
                                            skipCount += 1
                                            if index < tokens.mTokens.count - 2 && tokens.mTokens[index + 2].mNER == "LOCATION"{
                                                location += " \(tokens.mTokens[index + 2].mWord)"
                                                skipCount += 1
                                                
                                                if index < tokens.mTokens.count - 3 && tokens.mTokens[index + 3].mNER == "LOCATION"{
                                                    
                                                    location += " \(tokens.mTokens[index + 3].mWord)"
                                                    skipCount += 1
                                                }
                                            }
                                            locationTokens.append((location, sen.mParse!.mParseTree!, sen.mID))
                                            continue
                                        }
                                        locationTokens.append((token.mWord, sen.mParse!.mParseTree!, sen.mID))
                                        //                                        locations.append(token.mWord)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        return locationTokens
        

    }
    
    
    func getContext() -> [String]{
        return Array(self.mContenxtStates.keys)
    }
    
    func updateContextState(StateName name : String, SentenceNum num : Int){
        if num - self.mCurrentSentence > 30{
            self.mContenxtStates.removeAll()
        }
        if let initials = self.mUSStates[name]{
            if let contextState = self.mContenxtStates[initials]{
                self.mContenxtStates[initials] = contextState + 1
            }
            else{
                self.mContenxtStates[initials] = 1
            }
        }
        
        self.mCurrentSentence = num
        
    }
    
    func getState(FromInitials initials : String) ->String?{
        return self.reverseDictionary(FromDic: self.mUSStates)[initials]
    }
    
    func addToPinnedCities(CityName name : String) -> Bool{
        let isAlreadyPinned = self.mPinnedCities[name] != nil
        self.mPinnedCities[name] = name
        return isAlreadyPinned
        
    }

}
