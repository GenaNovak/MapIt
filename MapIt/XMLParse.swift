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
    var mParseTree : ParserTree?
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?){
        if elementName == "parse"{
            self.mParse = foundCharacters
            parser.delegate = self.parent
        
        }
    }
    
    
    func initilizeParseTree(str : String) -> ParserTree{
        let spaceRange = str.rangeOfString(" ")
        let spaceIndex : Int = str.startIndex.distanceTo(spaceRange!.startIndex)
        let pos = self.findPOS(str)
        let root = ParserNode(pos: pos, preNode: nil)
        root.mIsRoot = true
        let substr = str.substringFromIndex(str.startIndex.advancedBy(spaceIndex + 1))
        initializeNode(substr, prev: root)
        
        root.mIsRoot = true
        let tree = ParserTree(root: root)
        return tree
    }
    
    private func initializeNode(str : String, prev : ParserNode?){
        let arrStr = Array(str.characters)
        if arrStr[0] == "("{
            let pairs = self.findPairs(str)
            for pair in pairs{
                let pos = self.findPOS(pair)
                let node = ParserNode(pos: pos, preNode: prev)
                prev?.mNextNodes.append(node)
                let spaceRange = pair.rangeOfString(" ")
                let spaceIndex : Int = pair.startIndex.distanceTo(spaceRange!.startIndex)
                let substr = pair.substringFromIndex(str.startIndex.advancedBy(spaceIndex + 1))
                initializeNode(substr, prev: node)

                
            }
        }
        else{
            var word = ""
            for c in arrStr{
                if c != ")"{
                    word += String(c)
                }
                else{
                    break
                }
            }
            prev?.mWord = word
        }
    }
    
    
    final func findPOS(str : String) -> String{
        let spaceRange = str.rangeOfString(" ")
        let spaceIndex : Int = str.startIndex.distanceTo(spaceRange!.startIndex)
    
        let pos = str.substringWithRange(Range<String.Index>(start: str.startIndex.advancedBy(1), end: str.startIndex.advancedBy(spaceIndex)))
        return pos
    
    }
    
    
    private func findPairs(str : String) -> [String]{
        let strArr  = Array(str.characters)
        var arrToReturn : [String] = []
        var acc = ""
        var pairCount = 0
        for c in strArr{
            
            if c == "("{
                pairCount += 1
            }
            else if c == ")"{
                if pairCount != 0{
                    pairCount -= 1
                }
                else{
                    break
                }
                
            }
            
            if c != " " || pairCount != 0{
                acc += String(c)
            }
            
            
            if pairCount == 0 && c != " "{
                arrToReturn.append(acc)
                acc = ""
            }
        }
        
        return arrToReturn
    }
    
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if let parse = aDecoder.decodeObjectForKey("mParse") as? String{
            self.mParse = parse
        }
        if let tree = aDecoder.decodeObjectForKey("mParseTree") as? ParserTree{
            self.mParseTree = tree
        }
        else{
            self.mParseTree = ParserTree(root: ParserNode(pos: "", preNode: nil))
        }
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(self.mParse, forKey: "mParse")
        aCoder.encodeObject(self.mParseTree, forKey: "mParseTree")
    }
}
