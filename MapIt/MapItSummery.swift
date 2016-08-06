//
//  MapItSummery.swift
//  MapIt
//
//  Created by Genady Novak on 8/5/16.
//  Copyright © 2016 Gena. All rights reserved.
//

import Cocoa

class MapItSummery: NSObject {
    static let SharedInstance =  MapItSummery()
    private var mFoundLocationVSMapResultDic : [String : (Sentences : [String], MapResults : [String])] = [:]
    private var mBadLocationsDic : [String: [String]] = [:]
    private var mNumberOfLocations : Int = 0
    
    func addBadResult (BadResult name : String, Sentence sen : String){
        if self.mBadLocationsDic[name] == nil{
            self.mBadLocationsDic[name] = [sen]
        }
        else{
            self.mBadLocationsDic[name] = self.mBadLocationsDic[name]! + [sen]
        }
    }
    
    func addFoundLocation(Location loc : String, Sentences sen : String, MapResults result : String){
        if self.mFoundLocationVSMapResultDic[loc] == nil{
            self.mFoundLocationVSMapResultDic[loc] = ([sen], [result])
        }
        else{
            let val = self.mFoundLocationVSMapResultDic[loc]!
            self.mFoundLocationVSMapResultDic[loc] = (val.Sentences + [sen], val.MapResults + [result])
        }

    }
    
    
    func printSummary(){
        var gooodResultsOutput = "Total Locations \(self.mNumberOfLocations)\n\n"
        
        
        
        var title = "######################################## Found Locations (\(mFoundLocationVSMapResultDic.keys.count)) ########################################\n\n"
        
        gooodResultsOutput += title
        
        for name in self.mFoundLocationVSMapResultDic.keys{
            gooodResultsOutput += self.getFoundLocationDescription(FromLocationName: name, AndData: self.mFoundLocationVSMapResultDic[name]!)
        }
        
        title = "######################################## Bad Locations (\(mBadLocationsDic.keys.count)) ########################################\n\n"
        
        var barResultsOutput = ""
        
        barResultsOutput += title
        
        for name in self.mBadLocationsDic.keys{
            barResultsOutput += self.getBadLocationDiscription(FromLocationName: name, AndSentences: self.mBadLocationsDic[name]!)
        }
        
        let filename = getDocumentsDirectory().stringByAppendingPathComponent("GooodResultsOutput.txt")
        
        do {
            try gooodResultsOutput.writeToFile(filename, atomically: true, encoding: NSUTF8StringEncoding)
        } catch {
            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
        }
        
        let badResultsFilename = getDocumentsDirectory().stringByAppendingPathComponent("BadResultsOutput.txt")
        
        do {
            try barResultsOutput.writeToFile(badResultsFilename, atomically: true, encoding: NSUTF8StringEncoding)
        } catch {
            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
        }
    }
    
    func updateNumberOfFoundLocations(NumOfFoundLocations num : Int){
        self.mNumberOfLocations = num
    }
    
    private func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    private func getFoundLocationDescription(FromLocationName name : String, AndData data : (Sentences : [String], MapResults : [String])) -> String{
        let title = "#################### \(name) ####################\n\n"
        let sentencesHeader = "########## Sentences ##########\n"
        var sentencesBody = ""
        for (index, sentence) in data.Sentences.enumerate(){
            sentencesBody += "\(index + 1). \(sentence)\n"
        }
        sentencesBody += "\n"
        
        let mapResultsHeader = "########## Map Results ##########\n"
        var mapResultsBody = ""
        for (index, res) in data.MapResults.enumerate(){
            mapResultsBody += "\(index + 1). \(res)\n"
        }
        
        mapResultsBody += "\n\n\n"
        
        return title + sentencesHeader + sentencesBody + mapResultsHeader + mapResultsBody
    }
    
    private func getBadLocationDiscription(FromLocationName name : String, AndSentences sentences : [String]) ->String{
        let title = "#################### \(name) ####################\n\n"
        let sentencesHeader = "########## Sentences ##########\n"
        var sentencesBody = ""
        for (index, sentence) in sentences.enumerate(){
            sentencesBody += "\(index + 1). \(sentence)\n"
        }
        
        sentencesBody += "\n\n\n"
        
        return title + sentencesHeader + sentencesBody
    }
}
