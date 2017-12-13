//
//  MapViewController.swift
//  FilmLoctions
//
//  Created by Neil Li on 12/12/17.
//  Copyright © 2017 Li Zezhong. All rights reserved.
//
//  MapViewController search a location using MapKit and add a pin annotation on map.
//  Dependency on MKMapView injected and initialized by storyboard.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var name : String?
    var year : String?
    var location : String?
    
    // San Francisco coordinates within a 20km bounding box.
    let region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(37.7749, -122.4194), 10000, 10000)
    // Append pin point annotation title from name, year, location
    private var pointAnnotationTitle : String? {
        var title = ""
        if name != nil {
            title += name!
        }
        if year != nil {
            title += "\n" + year!
        }
        if location != nil {
            title += "\n" + location!
        }
        return title.count == 0 ? nil : title
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchAndAddAnnotation()
    }
    
    func searchAndAddAnnotation() {
        let localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = location
        localSearchRequest.region = region
        let localSearch = MKLocalSearch(request: localSearchRequest)
        weak var weakSelf = self
        localSearch.start { (response, error) in
            guard response != nil, error == nil else {
                weakSelf?.alertNotFound()
                return
            }
            guard response!.mapItems.count > 0 &&
                MKMapRectContainsPoint((weakSelf?.MKMapRectForCoordinateRegion(region: (weakSelf?.region)!))!, MKMapPointForCoordinate((response?.mapItems[0].placemark.coordinate)!)) else {
                    weakSelf?.alertNotFound()
                    return
            }
            
            let pointAnnotation = MKPointAnnotation()
            pointAnnotation.title = weakSelf?.pointAnnotationTitle
            pointAnnotation.coordinate = response!.mapItems[0].placemark.coordinate
            let pinAnnotationView = MKPinAnnotationView(annotation: pointAnnotation, reuseIdentifier: nil)
            weakSelf?.mapView.centerCoordinate = pointAnnotation.coordinate
            weakSelf?.mapView.addAnnotation(pinAnnotationView.annotation!)
            weakSelf?.mapView.centerCoordinate = pointAnnotation.coordinate
            weakSelf?.mapView.region = MKCoordinateRegionMakeWithDistance(pointAnnotation.coordinate, 500, 500)
        }
    }
    
    // Get MKMapRect from MKCoordinateRegion
    private func MKMapRectForCoordinateRegion(region:MKCoordinateRegion) -> MKMapRect {
        let topLeft = CLLocationCoordinate2D(latitude: region.center.latitude + (region.span.latitudeDelta/2), longitude: region.center.longitude - (region.span.longitudeDelta/2))
        let bottomRight = CLLocationCoordinate2D(latitude: region.center.latitude - (region.span.latitudeDelta/2), longitude: region.center.longitude + (region.span.longitudeDelta/2))
        
        let a = MKMapPointForCoordinate(topLeft)
        let b = MKMapPointForCoordinate(bottomRight)
        
        return MKMapRect(origin: MKMapPoint(x:min(a.x,b.x), y:min(a.y,b.y)), size: MKMapSize(width: abs(a.x-b.x), height: abs(a.y-b.y)))
    }
    
    // Popup alert view
    private func alertNotFound() {
        let alertController = UIAlertController(title: "Place not found", message: "Look at another location", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true)
    }

}
