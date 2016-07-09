//
//  XMLMention.swift
//  MapIt
//
//  Created by Genady Novak on 7/7/16.
//  Copyright © 2016 Gena. All rights reserved.
//

import Cocoa

class XMLMention: ParserBase {
    var mRepresentative : Bool = false
    var mSentence : Int = -1
    var mStart : Int = -1
    var mEnd : Int = -1
    var mHead : Int = -1
    var mText : String = ""
    
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?){
        if elementName == "sentence"{
            if let sen = Int(foundCharacters){
                self.mSentence = sen
            }
            
        }
        else if elementName == "start"{
            if let st = Int(foundCharacters){
                self.mStart = st
            }
        }
        else if elementName == "end"{
            if let end = Int(foundCharacters){
                self.mEnd = end
            }
        }
        else if elementName == "head"{
            if let head = Int(foundCharacters){
                self.mHead = head
            }
        }
        else if elementName == "text"{
            self.mText = foundCharacters
        }
        else if elementName == "mention"{
            parser.delegate = self.parent
        }
        
        foundCharacters = ""
    }
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.mRepresentative = aDecoder.decodeBoolForKey("mRepresentative")
        self.mSentence = aDecoder.decodeIntegerForKey("mSentence")
        self.mStart = aDecoder.decodeIntegerForKey("mStart")
        self.mEnd = aDecoder.decodeIntegerForKey("mEnd")
        self.mHead = aDecoder.decodeIntegerForKey("mHead")
        if let text = aDecoder.decodeObjectForKey("mText") as? String{
            self.mText = text
        }
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeBool(self.mRepresentative, forKey: "mRepresentative")
        aCoder.encodeInteger(self.mSentence, forKey: "mSentence")
        aCoder.encodeInteger(self.mStart, forKey: "mStart")
        aCoder.encodeInteger(self.mEnd, forKey: "mEnd")
        aCoder.encodeObject(self.mText, forKey: "mText")
    }
    
}
