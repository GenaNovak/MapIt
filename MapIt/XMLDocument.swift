//
//  XMLDocument.swift
//  MapIt
//
//  Created by Genady Novak on 7/6/16.
//  Copyright © 2016 Gena. All rights reserved.
//

import Cocoa

class XMLDocument: ParserBase {
    var mSentences : XMLSentences?
    var mCoreference : XMLCoreferences?


    override func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
       if elementName == "sentences"{
            self.mSentences = XMLSentences()
            parser.delegate = self.mSentences
            self.mSentences?.parent = self
        
        }
         else if elementName == "coreference"{
            self.mCoreference = XMLCoreferences()
            parser.delegate = self.mCoreference
            self.mCoreference?.parent = self
        }
        
    }
    
    
    override init() {
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if let sentences : XMLSentences = aDecoder.decodeObjectForKey("mSentences") as? XMLSentences{
            self.mSentences = sentences
        }
        if let coreference : XMLCoreferences = aDecoder.decodeObjectForKey("mCoreference") as? XMLCoreferences{
            self.mCoreference = coreference
        }
        
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(self.mSentences, forKey: "mSentences")
        aCoder.encodeObject(self.mCoreference, forKey: "mCoreference")
    }
}
