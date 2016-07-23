//
//  LinguisticParser.swift
//  MapIt
//
//  Created by Genady Novak on 7/22/16.
//  Copyright © 2016 Gena. All rights reserved.
//

import Cocoa

class LinguisticParser: NSObject {
    static let SharedInstance =  LinguisticParser()

    private let mSelfDescribeWords = ["I", "Me", "me", "We", "we", "Us", "us"]
    
    func isSelfDescribeWord (str : String) -> Bool{
        var isSelfDescribe = false
        for word in self.mSelfDescribeWords{
            if str.containsString(word){
                isSelfDescribe = true
                break
            }
        }
        return isSelfDescribe
    }
}
