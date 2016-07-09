//
//  XMLDependent.swift
//  MapIt
//
//  Created by Genady Novak on 7/8/16.
//  Copyright © 2016 Gena. All rights reserved.
//

import Cocoa

class XMLDependent: ParserBase {
    var mIDx : Int = -1
    var mValue : String = ""
    
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        self.mValue = foundCharacters
        parser.delegate = self.parent
    }
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.mIDx = aDecoder.decodeIntegerForKey("mIDx")
        if let value = aDecoder.decodeObjectForKey("mValue") as? String{
            self.mValue = value
        }
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeInteger(self.mIDx, forKey: "mIDx")
        aCoder.encodeObject(self.mValue, forKey: "mValue")
    }
}
