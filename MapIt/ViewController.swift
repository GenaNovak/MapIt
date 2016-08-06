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
import CoreLocation
import ArcGIS
import GooglePlacesAPI


class ViewController: NSViewController, MapItDragAndDropViewDelegate, MKMapViewDelegate{
    @IBOutlet var mMap: MKMapView!
    @IBOutlet var mDragAndDropView: MapItDragAndDropView!

    @IBOutlet var mActivityIndecator: NSProgressIndicator!
    private var mNumberOfLocationLeft : Int = 0
    private var searchCount = 0
    private var locationSearchQue : [ () -> ()] = []
    private var mTaskExecutionTime : NSTimer?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
        self.mDragAndDropView.delegate = self
        self.mMap.delegate = self
        GooglePlaces.provideAPIKey("AIzaSyC9lhUCQev5dKWvvMoTYykSABGHKqIsk-o")
    }

    override func viewWillAppear() {
        super.viewWillAppear()
        self.mDragAndDropView.layer?.backgroundColor = NSColor.whiteColor().CGColor
        self.mDragAndDropView.alphaValue = 0.8
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
    
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,Int64(delay * Double(NSEC_PER_SEC))),dispatch_get_main_queue(), closure)
    }
    
    private func dataIsReady(){
        let locations = DataParser.SharedInstance.getAllLocations()
        
        MapItSummery.SharedInstance.updateNumberOfFoundLocations(NumOfFoundLocations: locations.count)
        debugPrint("number of locations \(locations.count)")
        
        for (index,location) in locations.enumerate(){
        
        
        
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
                        MapItSummery.SharedInstance.addBadResult(BadResult: location.0, Sentence: location.1.description)
                    }
                }
                else{
                   MapItSummery.SharedInstance.addBadResult(BadResult: location.0, Sentence: location.1.description)
                }
                
            }
            else{
                MapItSummery.SharedInstance.addBadResult(BadResult: location.0, Sentence: location.1.description)
            }
            /*****************/
            
            if isTraveledCity{
                
                let isAlreadyPinned = DataParser.SharedInstance.addToPinnedCities(CityName: location.0)
                DataParser.SharedInstance.updateContextState(StateName: location.0, SentenceNum: location.2)
                
                if isAlreadyPinned == false{
                    let context = DataParser.SharedInstance.getContext()
                    if context.count > 0{
                    
                        
                            var locationName = DataParser.SharedInstance.getState(FromInitials: location.0)
                            var contenxtName = context[0]
                            if locationName == nil{
                                locationName = location.0
                                contenxtName = DataParser.SharedInstance.getState(FromInitials: context[0]) ?? context[0]
                            }
                        self.locationSearchQue.append({
                            self.findLocation(FromCityLocation: (locationName!, location.1, location.2), andContext: contenxtName, WithCompiltion: {
                                
                                    self.startNextLocationSearch(FromIndex: index)
                            })
                        })
                        
//                        })
                    }
                    else{
                        self.locationSearchQue.append({
                            self.findLocation(FromCityLocation:  ((DataParser.SharedInstance.getState(FromInitials: location.0) ?? location.0), location.1, location.2), WithCompiltion: {
                                    self.startNextLocationSearch(FromIndex: index)
                                
                            })
                        })

                        
                    }
                    

                }
                else{
                    MapItSummery.SharedInstance.addFoundLocation(Location: location.0, Sentences: location.1.description, MapResults: "Allready Pinned")
                }
                
                isTraveledCity = false
            }
            
        }
        
        self.mTaskExecutionTime = NSTimer(timeInterval: 0.2, target: self, selector: #selector(startNextLocationSearch), userInfo: nil, repeats: true)
        self.mTaskExecutionTime?.fire()
//        self.startNextLocationSearch(FromIndex: 0)
    }
    
    func startNextLocationSearch(FromIndex index : Int){
        if self.locationSearchQue.count > 0{
            self.locationSearchQue.removeFirst()()
            
        }
        else{
            self.mTaskExecutionTime?.invalidate()
            MapItSummery.SharedInstance.printSummary()
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
    
    func presentCityFromNetworkCity(FromCityLocation location : (String, ParserTree, Int), WithComplition complition : () -> ()){
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
                    MapItSummery.SharedInstance.addBadResult(BadResult: location.0, Sentence: location.1.description)
                    Swift.print("Location not found \(location.0)" )
                    complition()
                    return
                }
                if response.mapItems.count == 1{
                    let mapItems = response.mapItems[0]
                    
                    do{
                        let regx = try NSRegularExpression(pattern: "\\b\(location.0)\\b", options: .CaseInsensitive)
                        let matchings = regx.matchesInString(mapItems.name!, options: NSMatchingOptions.ReportCompletion, range: NSMakeRange(0, mapItems.name!.characters.count))
                        if matchings.count > 0 {
                            MapItSummery.SharedInstance.addFoundLocation(Location: location.0, Sentences: location.1.description, MapResults: mapItems.name ?? "")
                            self.presentCity(FromCordinate: mapItems.placemark.coordinate, AndName: mapItems.name ?? "", AndDescription: location.1.description)
                            complition()
                        }
                        else{
                            MapItSummery.SharedInstance.addBadResult(BadResult: location.0, Sentence: location.1.description)
                            Swift.print("Regex no match")
                            complition()
                        }
                    }
                    catch{
                        MapItSummery.SharedInstance.addBadResult(BadResult: location.0, Sentence: location.1.description)
                        Swift.print(error)
                        complition()
                    }
                    
                    
                }
                else{
                    MapItSummery.SharedInstance.addBadResult(BadResult: location.0, Sentence: location.1.description)
                    var bedResults = NSUserDefaults.standardUserDefaults().arrayForKey("BedResultsArr") as! [String]
                    bedResults.append(location.0)
                    NSUserDefaults.standardUserDefaults().setObject(bedResults, forKey: "BedResultsArr")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    Swift.print("More than one result \(location.0)")
                    complition()
                }
                
                
            }

        }
        else{
            complition()
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
    
    
    func findLocation(FromCityLocation location : (String, ParserTree, Int), andContext context : String = "", WithCompiltion complition : () -> ()){
        var input = location.0
        if context != ""{
            input = "\(location.0), \(context)"
        }
            GooglePlaces.placeAutocomplete(forInput: input ) { (response, error) in
                //             Check Status Code
                guard response?.status == GooglePlaces.StatusCode.OK else {
                    // Status Code is Not OK
                    
                    self.presentCityFromNetworkCity(FromCityLocation: location, WithComplition: {
                        complition()
                    })
                    return
                }
                
                let palceID = response!.predictions.first!.place?.toString().componentsSeparatedByString(":")[1]
                GooglePlaces.placeDetails(forPlaceID: palceID!, completion: { (response, error) in
                    guard response?.status == GooglePlaces.StatusCode.OK else {
                        // Status Code is Not OK
                        debugPrint(response?.errorMessage)
                        complition()
                        return
                    }
                    let pinLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake(response!.result!.geometryLocation!.latitude, response!.result!.geometryLocation!.longitude)
                    MapItSummery.SharedInstance.addFoundLocation(Location: location.0, Sentences: location.1.description, MapResults: response!.result!.name!)
                    self.presentCity( FromCordinate: pinLocation , AndName: response!.result!.name!, AndDescription: location.1.description)
                    complition()
                })
            }
        
    }

    
    


}

