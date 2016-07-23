//
//  ParserNode.swift
//  MapIt
//
//  Created by Genady Novak on 7/12/16.
//  Copyright © 2016 Gena. All rights reserved.
//

import Cocoa

class ParserNode: NSObject, NSCoding {
    var mIsRoot = false
    var mNextNodes : [ParserNode] = []
    var mPreNode : ParserNode?
    var mWord : String?
    let mPOS : String! //Parst of speach
    
    init(pos : String, preNode : ParserNode?) {
        self.mPOS = pos
        self.mPreNode = preNode
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.mIsRoot = aDecoder.decodeBoolForKey("mIsRoot")
        if let next = aDecoder.decodeObjectForKey("mNextNode") as? [ParserNode]{
            self.mNextNodes = next
        }
        else{
            self.mNextNodes = []
        }
        
        self.mPreNode = aDecoder.decodeObjectForKey("mPreNode") as? ParserNode
        if let word = aDecoder.decodeObjectForKey("mWord") as? String{
            self.mWord = word
        }
        else{
            self.mWord = ""
        }
        if let pos = aDecoder.decodeObjectForKey("mPOS") as? String{
            self.mPOS = pos
        }
        else{
            self.mPOS = ""
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeBool(self.mIsRoot, forKey: "mIsRoot")
        aCoder.encodeObject(self.mNextNodes, forKey: "mNextNode")
        aCoder.encodeObject(self.mPreNode, forKey: "mPreNode")
        aCoder.encodeObject(self.mWord, forKey: "mWord")
        aCoder.encodeObject(self.mPOS, forKey: "mPOS")
    }
    

    
}
