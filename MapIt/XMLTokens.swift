//
//  XMLTokens.swift
//  MapIt
//
//  Created by Genady Novak on 7/7/16.
//  Copyright © 2016 Gena. All rights reserved.
//

import Cocoa

class XMLTokens: ParserBase {
    var mTokens : [XMLToken] = []
    
    override func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if elementName == "token"{
            let token = XMLToken()
            if let id = attributeDict["id"]{
                token.mID = Int(id)!
            }
            
            parser.delegate = token
            token.parent = self
            self.mTokens.append(token)
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "tokens"{
            parser.delegate = self.parent
        }
    }
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if let tokens  = aDecoder.decodeObjectForKey("mTokens") as? [XMLToken]{
            self.mTokens = tokens
        }
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(self.mTokens, forKey: "mTokens")
    }
    
    
}
