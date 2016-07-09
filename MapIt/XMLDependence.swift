//
//  XMLDependence.swift
//  MapIt
//
//  Created by Genady Novak on 7/8/16.
//  Copyright © 2016 Gena. All rights reserved.
//

import Cocoa

class XMLDependence: ParserBase {
    var mType : String = ""
    var mGovernor : XMLGovenor?
    var mDependen : XMLDependentIn?
    
    
    override func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if elementName == "governor"{
            self.mGovernor = XMLGovenor()
            parser.delegate = self.mGovernor
            self.mGovernor?.parent = self
            
            if let idx = attributeDict["idx"]{
                self.mGovernor!.mIDx = Int(idx)!
            }
        }
        else if elementName == "dependent"{
            self.mDependen = XMLDependentIn()
            parser.delegate = self.mDependen
            self.mDependen?.parent = self
            if let idx = attributeDict["idx"]{
                self.mDependen!.mIDx = Int(idx)!
            }
        }
        
        foundCharacters = ""
    }
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "dep"{
            parser.delegate = self.parent
        }
    }
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if let type = aDecoder.decodeObjectForKey("mType") as? String{
            self.mType = type
        }
        if let governor = aDecoder.decodeObjectForKey("mGovernor") as? XMLGovenor{
            self.mGovernor = governor
        }
        if let dependen = aDecoder.decodeObjectForKey("mDependen") as? XMLDependentIn{
            self.mDependen = dependen
        }
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(self.mType, forKey: "mType")
        aCoder.encodeObject(self.mGovernor, forKey: "mGovernor")
        aCoder.encodeObject(self.mDependen, forKey: "mDependen")
    }
}
