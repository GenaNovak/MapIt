//
//  XMLDependencies.swift
//  MapIt
//
//  Created by Genady Novak on 7/7/16.
//  Copyright © 2016 Gena. All rights reserved.
//

import Cocoa

class XMLDependencies: ParserBase {
    var mDependencies : [XMLDependence] = []
    
    
    override func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if elementName == "dep"{
            let dependence = XMLDependence()
            
            if let type = attributeDict["type"]{
                dependence.mType = type
            }
            
            self.mDependencies.append(dependence)
            
            parser.delegate = dependence
            
            dependence.parent = self
        }
    
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?){
        if elementName == "dependencies"{
            parser.delegate = self.parent
        
        }
    }
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if let dependencies = aDecoder.decodeObjectForKey("mDependencies") as? [XMLDependence]{
            self.mDependencies = dependencies
        }
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(self.mDependencies, forKey: "mDependencies")
    }
    
    
}
