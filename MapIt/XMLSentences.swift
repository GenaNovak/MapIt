//
//  XMLSentences.swift
//  MapIt
//
//  Created by Genady Novak on 7/6/16.
//  Copyright © 2016 Gena. All rights reserved.
//

import Cocoa

class XMLSentences: ParserBase {
    var mSentences :[ XMLSentence ] = []
    
    
    override func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        if elementName == "sentence"{
            let sentence = XMLSentence()
            if let idStr = attributeDict["id"]{
                if let id = Int(idStr){
                    sentence.mID = id
                }
            }
            self.mSentences.append(sentence)
            
            parser.delegate = sentence
            
            sentence.parent = self
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?){
        if elementName == "sentences"{
        
            parser.delegate = self.parent
        }
    
    }
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if let sentences = aDecoder.decodeObjectForKey("mSentences") as? [ XMLSentence ]{
            self.mSentences = sentences
        }
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(self.mSentences, forKey: "mSentences")
    }
    
    
}
