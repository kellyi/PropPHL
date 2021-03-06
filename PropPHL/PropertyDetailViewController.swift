//
//  PropertyDetailViewController.swift
//  PropPHL
//
//  Created by Kelly Innes on 9/16/15.
//  Copyright © 2015 Kelly Innes. All rights reserved.
//

import UIKit
import MapKit

class PropertyDetailViewController: UIViewController, MKMapViewDelegate {

    // MARK: - Variables
    
    var selectedProperty: Property!
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - View Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let center = CLLocationCoordinate2DMake(Double(selectedProperty.pin.latitude), Double(selectedProperty.pin.longitude))
        let meters = 100 as Double
        let region = MKCoordinateRegionMakeWithDistance(center, meters, meters)
        let adjustedRegion = mapView.regionThatFits(region)
        mapView.setRegion(adjustedRegion, animated: true)
        let annotation = MKPointAnnotation()
        let annotationLocation = center
        annotation.coordinate = annotationLocation
        mapView.addAnnotation(annotation)
    }

    // MARK: - MKAnnotationView Setup
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "pin"
        if let pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseID) {
            return pinView
        } else {
            let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pinView.canShowCallout = false
            return pinView
        }
    }
    
    // MARK: - Segue to Pass Info to Embedded TableViewController
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "propertyDetailContainerSegue" {
            let detailTableVC = segue.destinationViewController as! PropertyDetailTableViewController
            detailTableVC.property = selectedProperty
        }
    }
    
}
