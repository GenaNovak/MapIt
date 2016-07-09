//
//  ParserBase.swift
//  MapIt
//
//  Created by Genady Novak on 7/6/16.
//  Copyright © 2016 Gena. All rights reserved.
//

import Cocoa

class ParserBase: NSObject, NSXMLParserDelegate, NSCoding{
    
    var currentElement:String = ""
    var foundCharacters = ""
    weak var parent:ParserBase? = nil
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        currentElement = elementName
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if string.containsString("\n") == false{
            self.foundCharacters += string
        }
        
    }
    
    override init(){
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        if let element : String = aDecoder.decodeObjectForKey("currentElement") as? String{
            self.currentElement = element
        }
        if let character : String = aDecoder.decodeObjectForKey("foundCharacters") as? String{
            self.foundCharacters = character
        }
        if let parent = aDecoder.decodeObjectForKey("parent") as? ParserBase{
            self.parent = parent
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.currentElement, forKey: "currentElement")
        aCoder.encodeObject(self.foundCharacters, forKey: "foundCharacters")
        aCoder.encodeObject(self.parent, forKey: "parent")
    }
}
