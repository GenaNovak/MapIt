//
//  XMLSentence.swift
//  MapIt
//
//  Created by Genady Novak on 7/7/16.
//  Copyright © 2016 Gena. All rights reserved.
//

import Cocoa

class XMLSentence: ParserBase {
    var mID : Int = -1
    var mParse : XMLParse?
    var mTokens : XMLTokens?
    var mBasicDependencies : XMLBasicDependencies?
    var mCollapsedDependencies : XMLCollapsedDependencies?
    var mCollapsedCCDependencies : XMLCollapsedCcprocessedDependencies?
    
    override func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        if elementName == "tokens"{
            self.mTokens = XMLTokens()
            parser.delegate = self.mTokens
            self.mTokens!.parent = self
        }
        else if elementName == "parse"{
            self.mParse = XMLParse()
            parser.delegate = self.mParse
            self.mParse?.parent = self
        }
        else if elementName == "dependencies"{
            if let type = attributeDict["type"]{
                if type == "basic-dependencies"{
                    let basic = XMLBasicDependencies()
                    parser.delegate = basic
                    basic.parent = self
                    self.mBasicDependencies = basic
                }
                else if type == "collapsed-dependencies"{
                    let collapsed = XMLCollapsedDependencies()
                    parser.delegate = collapsed
                    collapsed.parent = self
                    self.mCollapsedDependencies = collapsed
                }
                else if type == "collapsed-ccprocessed-dependencies"{
                    let collapsedCC = XMLCollapsedCcprocessedDependencies()
                    parser.delegate = collapsedCC
                    collapsedCC.parent = self
                    self.mCollapsedCCDependencies = collapsedCC
                }
            }
        }
        foundCharacters = ""
    
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?){
        if elementName == "sentence"{
            parser.delegate = self.parent
        }
    }
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.mID = aDecoder.decodeIntegerForKey("mID")
        if let parse = aDecoder.decodeObjectForKey("mParse") as? XMLParse{
            self.mParse = parse
        }
        if let tokens = aDecoder.decodeObjectForKey("mTokens") as? XMLTokens{
            self.mTokens = tokens
        }
        if let basicDependencies = aDecoder.decodeObjectForKey("mBasicDependencies") as? XMLBasicDependencies{
            self.mBasicDependencies = basicDependencies
        }
        if let collapsedDependencies = aDecoder.decodeObjectForKey("mCollapsedDependencies") as? XMLCollapsedDependencies{
            self.mCollapsedDependencies = collapsedDependencies
        }
        if let collapsedCCDependencies = aDecoder.decodeObjectForKey("mCollapsedCCDependencies") as? XMLCollapsedCcprocessedDependencies{
            self.mCollapsedCCDependencies = collapsedCCDependencies
        }
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeInteger(self.mID, forKey: "mID")
        aCoder.encodeObject(self.mParse, forKey: "mParse")
        aCoder.encodeObject(self.mTokens, forKey: "mTokens")
        aCoder.encodeObject(self.mBasicDependencies, forKey: "mBasicDependencies")
        aCoder.encodeObject(self.mCollapsedDependencies, forKey: "mCollapsedDependencies")
        aCoder.encodeObject(self.mCollapsedCCDependencies, forKey: "mCollapsedCCDependencies")
    }
}
