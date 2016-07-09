//
//  XMLRootIn.swift
//  MapIt
//
//  Created by Genady Novak on 7/8/16.
//  Copyright © 2016 Gena. All rights reserved.
//

import Cocoa

class XMLRootIn: ParserBase {
    var mDocument : XMLDocument?
    
    
    override func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if elementName == "document"{
            self.mDocument = XMLDocument()
            parser.delegate = self.mDocument
            self.mDocument?.parent = self
            
        }
    
    }
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if let document = aDecoder.decodeObjectForKey("mDocument") as? XMLDocument{
            self.mDocument = document
        }
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(self.mDocument, forKey: "mDocument")
    }
    
    
}
