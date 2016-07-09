//
//  DataMenuItem.swift
//  MapIt
//
//  Created by Genady Novak on 7/9/16.
//  Copyright © 2016 Gena. All rights reserved.
//

import Cocoa

class DataMenuItem: NSObject {


    @IBAction func clearData(sender: AnyObject) {
        DataParser.SharedInstance.clearAllData()
    }

}
