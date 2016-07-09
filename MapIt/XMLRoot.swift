//
//  XMLRoot.swift
//  MapIt
//
//  Created by Genady Novak on 7/6/16.
//  Copyright © 2016 Gena. All rights reserved.
//

import Cocoa

class XMLRoot: ParserBase {
    var mRoot : XMLRootIn?
    
    
    override func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
    
        if elementName == "root"{
            self.mRoot = XMLRootIn()
            parser.delegate = self.mRoot
            
            self.mRoot?.parent = self
        }
    
    }
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if let root : XMLRootIn = aDecoder.decodeObjectForKey("mRoot") as? XMLRootIn{
            self.mRoot = root
        }
        
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(self.mRoot, forKey: "mRoot")
    }
}
