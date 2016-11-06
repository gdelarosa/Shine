//
//  Food.swift
//  ShineApp
//
//  Created by Gina De La Rosa on 9/6/16.
//  Copyright © 2016 Gina De La Rosa. All rights reserved.
//

import Foundation
import MapKit
import Contacts

class Food: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String,locationName: String,discipline: String,coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
    
    func mapItem() -> MKMapItem {
        let addressDictionary = [String(CNPostalAddressStreetKey): subtitle!]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
    
    class func fromJSON(_ json: [JSONValue]) -> Food? {
        var title: String
        if let titleOrNil = json[16].string {
            title = titleOrNil
        }else{
            title = ""
        }
        
        let locationName = json[12].string
        let discipline = json[15].string
        let latitude = (json[18].string! as NSString).doubleValue
        let longitude = (json[19].string! as NSString).doubleValue
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        return Food(title: title, locationName: locationName!, discipline: discipline!, coordinate: coordinate)
    }
    
    func pinColor() -> UIColor? {
        switch discipline {
        case "Housing", "Shelter" :
            return UIColor.blue
        case "Food", "Pantry" :
            return UIColor.blue
        default :
            return UIColor.blue
        }
    }
}
