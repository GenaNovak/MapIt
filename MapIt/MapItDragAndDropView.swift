//
//  MapItDragAndDropView.swift
//  MapIt
//
//  Created by Genady Novak on 7/8/16.
//  Copyright © 2016 Gena. All rights reserved.
//

import Cocoa

protocol MapItDragAndDropViewDelegate {
    func dragOperationDone(filePath path : String)
}

class MapItDragAndDropView: NSView {
    let mExpectedExt = "txt"
    var mFilePath : String = ""
    var delegate : MapItDragAndDropViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        registerForDraggedTypes([NSFilenamesPboardType, NSURLPboardType])
        
    }
    
    override func draggingEntered(sender: NSDraggingInfo) -> NSDragOperation {
        if let pasteboard = sender.draggingPasteboard().propertyListForType("NSFilenamesPboardType") as? NSArray {
            if let path = pasteboard[0] as? String {
                let ext = NSURL(fileURLWithPath: path).pathExtension
                if ext == self.mExpectedExt {
                
                    return NSDragOperation.Copy
                }
            }
        }
        return NSDragOperation.None
    }
    
    override func draggingExited(sender: NSDraggingInfo?) {
    }
    
    override func draggingEnded(sender: NSDraggingInfo?) {
    }
    
    override func performDragOperation(sender: NSDraggingInfo) -> Bool {
        if let pasteboard = sender.draggingPasteboard().propertyListForType("NSFilenamesPboardType") as? NSArray {
            if let path = pasteboard[0] as? String {
                self.mFilePath = path
                //GET YOUR FILE PATH !!
                self.delegate?.dragOperationDone(filePath: self.mFilePath)
                return true
            }
        }
        return false
    }

    
}
