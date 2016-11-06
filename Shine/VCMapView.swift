//
//  VCMapView.swift
//  Shine
//
//  Created by Gina De La Rosa on 9/6/16.
//  Copyright © 2016 Gina De La Rosa. All rights reserved.
//

import Foundation
import MapKit

extension MapViewController: MKMapViewDelegate {
   
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if let annotation = annotation as? Food {
            let identifier = "Pin"
            var view: MKPinAnnotationView
            if let dequeueView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView{
                dequeueView.annotation = annotation
                view = dequeueView
            }else{
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.canShowCallout = true
                view.rightCalloutAccessoryView = UIButton(type: UIButtonType.detailDisclosure) as UIView
                view.pinTintColor = annotation.pinColor()
            }
            return view
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
       
        let location = view.annotation as! Food
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
}
