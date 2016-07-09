//
//  ViewController.swift
//  MapIt
//
//  Created by Genady Novak on 7/6/16.
//  Copyright © 2016 Gena. All rights reserved.
//

import Cocoa
import MapKit

class ViewController: NSViewController, MapItDragAndDropViewDelegate {
    @IBOutlet var mMap: MKMapView!
    @IBOutlet var mDragAndDropView: MapItDragAndDropView!

    @IBOutlet var mActivityIndecator: NSProgressIndicator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
        self.mDragAndDropView.delegate = self

        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear() {
        super.viewWillAppear()
        self.mDragAndDropView.layer?.backgroundColor = NSColor.whiteColor().CGColor
        self.mDragAndDropView.alphaValue = 0.8
    }
    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    //MARK: MapItDragAndDropViewDelegate
    func dragOperationDone(filePath path : String) {
        self.mActivityIndecator.hidden = false
        self.mActivityIndecator.indeterminate = true
        self.mActivityIndecator.usesThreadedAnimation = true
        self.mActivityIndecator.startAnimation(self)


        DataParser.SharedInstance.processBook(FromPath: path) { (success) in
            if success{
                let splitedPath = path.componentsSeparatedByString("/")
                let fileName = splitedPath[splitedPath.count - 1]
            
                let NLPPath = NSBundle.mainBundle().pathForResource("stanford-corenlp-full-2015-12-09", ofType: nil)
                let outputPath = "\(NLPPath!)/\(fileName).out"
                DataParser.SharedInstance.processXML(FromPath: outputPath, andCompletion: { (success) in
                    if success{
                        NSAnimationContext.runAnimationGroup({ (context) in
                            context.duration = 0.7
                            self.mDragAndDropView.animator().layer?.backgroundColor = NSColor.clearColor().CGColor
                            
                            }, completionHandler: {
                                self.mDragAndDropView.animator().alphaValue = 1
                                self.mDragAndDropView.acceptsTouchEvents = false
                                self.mDragAndDropView.removeFromSuperview()
                        })
                    }
                    else{
                        
                    }
                    self.mActivityIndecator.stopAnimation(self)
                    self.mActivityIndecator.hidden = true
                })
            }
            else{
                self.mActivityIndecator.stopAnimation(self)
                self.mActivityIndecator.hidden = true
                Swift.print("Error")
            }
            
            
        }
    }
    
    


}

