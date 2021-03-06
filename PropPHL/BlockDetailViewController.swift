//
//  BlockDetailViewController.swift
//  PropPHL
//
//  Created by Kelly Innes on 9/16/15.
//  Copyright © 2015 Kelly Innes. All rights reserved.
//

import UIKit
import MapKit

class BlockDetailViewController: UIViewController, MKMapViewDelegate {

    // MARK: - Variables
    
    @IBOutlet weak var mapView:MKMapView!
    @IBOutlet weak var lowerView:UIView!
    
    var block: Block!
    
    // MARK: - View Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        let blockCenter = CLLocationCoordinate2DMake(Double(block.pin.latitude), Double(block.pin.longitude))
        let meters = 250 as Double
        let region = MKCoordinateRegionMakeWithDistance(blockCenter, meters, meters)
        let adjustedRegion = mapView.regionThatFits(region)
        mapView.setRegion(adjustedRegion, animated: true)
        let annotation = MKPointAnnotation()
        let annotationLocation = blockCenter
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
        if segue.identifier == "blockDetailContainerSegue" {
            let detailTableVC = segue.destinationViewController as! BlockDetailTableViewController
            detailTableVC.block = block
        }
    }

}
