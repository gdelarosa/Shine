//
//  ViewController.swift
//  Shine
//
//  Created by Gina De La Rosa on 9/6/16.
//  Copyright © 2016 Gina De La Rosa. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var foods = [Food]()
    var locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        let initialLocation = CLLocation(latitude: 34.0522, longitude: -118.2437) // LA 
        centerMapOnLocation(initialLocation)
        loadInitialDtata()
        mapView.addAnnotations(foods)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }
    
    let regionRadius: CLLocationDistance = 10000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func loadInitialDtata(){
        let filename = NSBundle.mainBundle().pathForResource("Food", ofType: "json")
        
        var data: NSData?
        do{
            data = try NSData(contentsOfFile: filename!, options: NSDataReadingOptions(rawValue: 0))
        }catch _ {
            data = nil
        }
        
        var jsonObject: AnyObject?
        
        if let data = data {
            do {
                jsonObject = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0))
            }catch _ {
                jsonObject = nil
            }
        }
        
        if let jsonObject = jsonObject as? [String: AnyObject], let jsonData = JSONValue.fromObject(jsonObject)?["data"]?.array{
            for foodJSON in jsonData {
                if let foodJSON = foodJSON.array, food = Food.fromJSON(foodJSON){
                    foods.append(food)
                }
            }
        }
        
    }
    
    func checkLocationAuthorizationStatus(){
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            mapView.showsUserLocation = true
        }else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
}
