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

    var selectedProperty: Property!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let center = selectedProperty.pin.coordinate
        let meters = 100 as Double
        let region = MKCoordinateRegionMakeWithDistance(center, meters, meters)
        let adjustedRegion = mapView.regionThatFits(region)
        mapView.setRegion(adjustedRegion, animated: true)
        mapView.addAnnotation(selectedProperty.pin)
    }

    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseID)
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
        pinView!.canShowCallout = false
        return pinView
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "propertyDetailContainerSegue" {
            let detailTableVC = segue.destinationViewController as! PropertyDetailTableViewController
            detailTableVC.property = selectedProperty
        }
    }
    
}
