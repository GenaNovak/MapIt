//
//  ViewController.swift
//  MapIt
//
//  Created by Genady Novak on 7/6/16.
//  Copyright © 2016 Gena. All rights reserved.
//

import Cocoa
import MapKit
import AddressBook

class ViewController: NSViewController, MapItDragAndDropViewDelegate, MKMapViewDelegate{
    @IBOutlet var mMap: MKMapView!
    @IBOutlet var mDragAndDropView: MapItDragAndDropView!

    @IBOutlet var mActivityIndecator: NSProgressIndicator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
        self.mDragAndDropView.delegate = self
        self.mMap.delegate = self

        
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
                                self.dataIsReady()
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
    
    
    private func dataIsReady(){
        let locations = DataParser.SharedInstance.getAllLocations()
        
        
        for location in locations{
        
            /*****************/
            
            var isTraveledCity = false
            
            let locationArr = location.0.componentsSeparatedByString(" ")
            if let node = location.1.findNode(FromString: locationArr[0], currentNode: location.1.mRoot){
                let paresePath = locations[0].1.findPath(fromNodeWithPos: "S", toNode: node)
                if paresePath.count > 0{
                    let neededNode = paresePath[paresePath.count - 1]
                    var printStr = ""
                    for n in neededNode.mNextNodes[0].mNextNodes{
                        printStr += "\(n.mWord ?? "") "
                    }
                    
                    if LinguisticParser.SharedInstance.isSelfDescribeWord(printStr){
                        isTraveledCity = true
                    }
                    else{
                        Swift.print("\(printStr) ------------------ \(location.1.description)" )
                    }
                }
                else{
                   Swift.print("S Not found")
                }
                
            }
            else{
                Swift.print("node Not found \(locationArr[0])")
            }
            /*****************/
            
            if isTraveledCity{
                let isAlreadyPinned = DataParser.SharedInstance.addToPinnedCities(CityName: location.0)
                DataParser.SharedInstance.updateContextState(StateName: location.0, SentenceNum: location.2)
                
                if isAlreadyPinned == false{
                    let context = DataParser.SharedInstance.getContext()
                    var cities : [City] = []
                    if context.count > 0{
                        cities = CoreDataManager.SharedInstance.getCitiesWithContext(CityName: location.0, AndContext: context)
                    }
                    else{
                        cities = CoreDataManager.SharedInstance.getCity(CityName: location.0)
                    }
                    
                    if cities.count > 0
                    {
                        var currentCity : City?
                        for city in cities{
                            if city.country != nil && city.country == "\"US\"" && city.region != nil{
                                currentCity = city
                                break
                            }
                            
                        }
                        
                        if currentCity != nil{
                            
                            self.presentCityOnMap(FromCity: currentCity!, AndDescription: location.1.description)
                        }
                        else{
                            Swift.print("City not found")
                        }
                        
                    }
                    else{
                        self.presentCityFromNetworkCity(FromCityLocation: location)
                    }
                }
                
                isTraveledCity = false
            }
            
        }
    }
    
    func presentCityOnMap(FromCity city: City, AndDescription description : String){
        let pinLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake(city.latitude, city.longitude)
        let objectAnnotation = MKPointAnnotation()
        objectAnnotation.coordinate = pinLocation
        objectAnnotation.title = city.city
        objectAnnotation.subtitle = description
        self.mMap.addAnnotation(objectAnnotation)
    }
    
    func presentCity(FromCordinate cordinate : CLLocationCoordinate2D, AndName cityName : String, AndDescription description : String){
        let pinLocation = cordinate
        let objectAnnotation = MKPointAnnotation()
        objectAnnotation.coordinate = pinLocation
        objectAnnotation.title = cityName
        objectAnnotation.subtitle = description
        self.mMap.addAnnotation(objectAnnotation)
    }
    
    func presentCityFromNetworkCity(FromCityLocation location : (String, ParserTree, Int)){
        if NSUserDefaults.standardUserDefaults().arrayForKey("BedResultsArr") == nil{
           NSUserDefaults.standardUserDefaults().setObject([], forKey: "BedResultsArr")
        }
        let bedResults = NSUserDefaults.standardUserDefaults().arrayForKey("BedResultsArr") as! [String]
        if bedResults.contains(location.0) == false{
            let request = MKLocalSearchRequest()
            request.naturalLanguageQuery = location.0
            let search = MKLocalSearch(request: request)
            search.startWithCompletionHandler { response, _ in
                guard let response = response else {
                    Swift.print("Location not found \(location.0)" )
                    return
                }
                if response.mapItems.count == 1{
                    let mapItems = response.mapItems[0]
                    
                    do{
                        let regx = try NSRegularExpression(pattern: "\\b\(location.0)\\b", options: .CaseInsensitive)
                        let matchings = regx.matchesInString(mapItems.name!, options: NSMatchingOptions.ReportCompletion, range: NSMakeRange(0, mapItems.name!.characters.count))
                        if matchings.count > 0 {
                            if location.0 == "Rio Grande river"{
                                Swift.print("here")
                            }
                            self.presentCity(FromCordinate: mapItems.placemark.coordinate, AndName: mapItems.name ?? "", AndDescription: location.1.description)
                            Swift.print("\(location.0) VS \(mapItems.name)")
                        }
                        else{
                            Swift.print("Regex no match")
                        }
                    }
                    catch{
                        Swift.print(error)
                    }
                    
                    
                }
                else{
                    var bedResults = NSUserDefaults.standardUserDefaults().arrayForKey("BedResultsArr") as! [String]
                    bedResults.append(location.0)
                    NSUserDefaults.standardUserDefaults().setObject(bedResults, forKey: "BedResultsArr")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    Swift.print("More than one result \(location.0)")
                }
                
                
            }

        }
        
    }
    
    
    //MARK: MKMapViewDelegate
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
        }
        else {
            pinView!.annotation = annotation
        }
        
        //THIS IS THE GOOD BIT
        let subtitleView = NSTextField(frame: CGRectMake(0,0,100,100))
        subtitleView.drawsBackground = false
        subtitleView.backgroundColor = NSColor.clearColor()
        subtitleView.allowsEditingTextAttributes = false
        subtitleView.font = NSFont.systemFontOfSize(12)
        subtitleView.allowsEditingTextAttributes = false
        subtitleView.bordered = false
        subtitleView.maximumNumberOfLines = 30
        subtitleView.stringValue = annotation.subtitle!!
        pinView!.detailCalloutAccessoryView = subtitleView
        pinView?.animatesDrop = true
        
        
        return pinView
    }
    
    


}

