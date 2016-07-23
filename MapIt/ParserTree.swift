//
//  ParserTree.swift
//  MapIt
//
//  Created by Genady Novak on 7/12/16.
//  Copyright © 2016 Gena. All rights reserved.
//

import Cocoa

class ParserTree: NSObject, NSCoding {
    let mRoot : ParserNode!
    
    init(root : ParserNode){
        self.mRoot = root
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        if let root = aDecoder.decodeObjectForKey("mRoot") as? ParserNode{
            self.mRoot = root
        }
        else{
            self.mRoot = ParserNode(pos: "", preNode: nil)
            self.mRoot.mIsRoot = true
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.mRoot, forKey: "mRoot")
    }
    
    func findNode(FromString str : String, currentNode : ParserNode) ->ParserNode?{
        for node in currentNode.mNextNodes{
            if node.mWord != nil && node.mWord == str{
                return node
            }
            else{
                let foundNode = self.findNode(FromString: str, currentNode: node)
                if foundNode != nil {
                    return foundNode
                }
            }
        }
        return nil
    }
    
    
    func findPath(fromNodeWithPos str : String, toNode node : ParserNode) -> [ParserNode]{
        var currentNode : ParserNode? = node
        var toReturn : [ParserNode] = []
        while currentNode != nil && currentNode!.mIsRoot == false{
            toReturn.append(currentNode!)
            if currentNode!.mPOS == str{
                break
            }
            currentNode = currentNode!.mPreNode
        }
        
        return toReturn
    }
    
    
    private func concatAllWords(currentNode : ParserNode) -> String{
        var acc = ""
        for node in currentNode.mNextNodes{
            if node.mWord != ""{
                acc += "\(node.mWord ?? "")"
            }
            
            acc += " \(self.concatAllWords(node))"
        }
        return acc
    }
    
    //MARK: Description
    override var description : String{
        let description: String = self.concatAllWords(self.mRoot)
        return description
        
        
    }
}
