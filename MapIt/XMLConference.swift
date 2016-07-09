//
//  XMLConference.swift
//  MapIt
//
//  Created by Genady Novak on 7/7/16.
//  Copyright © 2016 Gena. All rights reserved.
//

import Cocoa

class XMLConference: ParserBase {
    var mMentions : [XMLMention] = []
    
    
    override func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if elementName == "mention"{
            let mention = XMLMention()
            
            
            self.mMentions.append(mention)
            
            parser.delegate = mention
            
            mention.parent = self
            if let rep = attributeDict["representative"]{
                mention.mRepresentative = rep == "true"
            }
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
        if let mentions = aDecoder.decodeObjectForKey("mMentions") as? [XMLMention]{
            self.mMentions = mentions
        }
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(self.mMentions, forKey: "mMentions")
    }
    
    


}
