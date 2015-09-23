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

    @IBOutlet weak var mapView:MKMapView!
    
    var block: Block!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        let blockCenter = block.pin.coordinate
        let meters = 250 as Double
        let region = MKCoordinateRegionMakeWithDistance(blockCenter, meters, meters)
        let adjustedRegion = mapView.regionThatFits(region)
        mapView.setRegion(adjustedRegion, animated: true)
    }

}
