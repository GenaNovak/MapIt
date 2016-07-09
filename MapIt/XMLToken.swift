//
//  XMLToken.swift
//  MapIt
//
//  Created by Genady Novak on 7/7/16.
//  Copyright © 2016 Gena. All rights reserved.
//

import Cocoa

class XMLToken: ParserBase {
    var mID : Int = -1
    var mWord : String = ""
    var mLemma : String = ""
    var mCharacterOffsetBegin : Int = -1
    var mCharacterOffsetEnd : Int = -1
    var mPOS : String = ""
    var mNER : String = ""
    var mNormalizedNER : String = ""
    var mSpeaker : String = ""
    
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?){
        if elementName == "word"{
            self.mWord = foundCharacters
        }
        else if elementName == "lemma"{
            self.mLemma = foundCharacters
        }
        else if elementName == "CharacterOffsetBegin"{
            self.mCharacterOffsetBegin = Int(foundCharacters)!
            
        }
        else if elementName == "CharacterOffsetEnd"{
            self.mCharacterOffsetEnd = Int(foundCharacters)!
        }
        else if elementName == "POS"{
            self.mPOS = foundCharacters
        }
        else if elementName == "NER"{
            self.mNER = foundCharacters
        }
        else if elementName == "NormalizedNER"{
            self.mNormalizedNER = foundCharacters
        }
        else if elementName == "Speaker"{
            self.mSpeaker = foundCharacters
        }
        else if elementName == "token"{
            parser.delegate = self.parent
        }

        
        foundCharacters = ""
    }
    
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.mID = aDecoder.decodeIntegerForKey("mID")
        if let word = aDecoder.decodeObjectForKey("mWord") as? String{
            self.mWord = word
        }
        if let lemma = aDecoder.decodeObjectForKey("mLemma") as? String{
            self.mLemma = lemma
        }
        self.mCharacterOffsetBegin = aDecoder.decodeIntegerForKey("mCharacterOffsetBegin")
        self.mCharacterOffsetEnd = aDecoder.decodeIntegerForKey("mCharacterOffsetEnd")
        if let pos = aDecoder.decodeObjectForKey("mPOS") as? String{
            self.mPOS = pos
        }
        if let ner = aDecoder.decodeObjectForKey("mNER") as? String{
            self.mNER = ner
        }
        if let normalizedNER = aDecoder.decodeObjectForKey("mNormalizedNER") as? String{
            self.mNormalizedNER = normalizedNER
        }
        if let speaker = aDecoder.decodeObjectForKey("mSpeaker") as? String{
            self.mSpeaker = speaker
        }
        
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeInteger(self.mID, forKey: "mID")
        aCoder.encodeObject(self.mWord, forKey: "mWord")
        aCoder.encodeObject(self.mLemma, forKey: "mLemma")
        aCoder.encodeInteger(self.mCharacterOffsetBegin, forKey: "mCharacterOffsetBegin")
        aCoder.encodeInteger(self.mCharacterOffsetEnd, forKey: "mCharacterOffsetEnd")
        aCoder.encodeObject(self.mPOS, forKey: "mPOS")
        aCoder.encodeObject(self.mNER, forKey: "mNER")
        aCoder.encodeObject(self.mNormalizedNER, forKey: "mNormalizedNER")
        aCoder.encodeObject(self.mSpeaker, forKey: "mSpeaker")
    }
}
