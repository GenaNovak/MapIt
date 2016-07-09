//
//  XMLCoreferences.swift
//  MapIt
//
//  Created by Genady Novak on 7/6/16.
//  Copyright © 2016 Gena. All rights reserved.
//

import Cocoa

class XMLCoreferences: ParserBase {
    var mCoreferences : [XMLConference] = []
    
    
    override func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        if elementName == "coreference"{
            let coreference = XMLConference()
            self.mCoreferences.append(coreference)
            parser.delegate = coreference
            
            coreference.parent = self
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?){
    
        if elementName == "coreference"{
            parser.delegate = self.parent
        }
    }
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if let confrences = aDecoder.decodeObjectForKey("mCoreferences") as? [XMLConference]{
            self.mCoreferences = confrences
        }
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(self.mCoreferences, forKey: "mCoreferences")
    }
    
}
