//
//  MapViewController.swift
//  NFCTagsApp
//
//  Created by Alex Levy on 5/30/19.
//  Copyright © 2019 Hillside Software. All rights reserved.
//

import UIKit
import MapKit


class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet var mapView: MKMapView!
    
    var tag = TagModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Customize the map view
        mapView.delegate = self
        mapView.showsCompass = true
        mapView.showsScale = true
        mapView.showsTraffic = true
        
        // Convert address to coordinate and annotate it on map
        let geoCoder = CLGeocoder()
        var addr = tag.tagAddress + " " + tag.tagAddress2 + " " + tag.tagCity
        geoCoder.geocodeAddressString(addr, completionHandler: { placemarks, error in
            if let error = error {
                print(error)
                return
            }
            
            if let placemarks = placemarks {
                // Get the first placemark
                let placemark = placemarks[0]
                
                // Add annotation
                let annotation = MKPointAnnotation()
                annotation.title = self.tag.tagTitle
                annotation.subtitle = self.tag.tagSubTitle
                
                if let location = placemark.location {
                    annotation.coordinate = location.coordinate
                    
                    // Display the annotation
                    self.mapView.showAnnotations([annotation], animated: true)
                    self.mapView.selectAnnotation(annotation, animated: true)
                }
            }
            
        })
    }
    
    // MARK: - MKMapViewDelegate methods
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MyMarker"
        
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        
        // Reuse the annotation if possible
        var annotationView: MKMarkerAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        
        annotationView?.glyphText = "😋"
        annotationView?.markerTintColor = UIColor.orange
        
        return annotationView
    }
}
