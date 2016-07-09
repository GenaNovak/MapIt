//
//  XMLParser.swift
//  MapIt
//
//  Created by Genady Novak on 7/8/16.
//  Copyright © 2016 Gena. All rights reserved.
//

import Cocoa

class XMLParse: ParserBase {
    var mParse : String = ""
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?){
        if elementName == "parse"{
            self.mParse = foundCharacters
            parser.delegate = self.parent
        
        }
    }
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if let parse = aDecoder.decodeObjectForKey("mParse") as? String{
            self.mParse = parse
        }
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(self.mParse, forKey: "mParse")
    }
}
