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

    var selectedProperty: Property?
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var assessmentLabel: UILabel!
    @IBOutlet weak var taxesLabel: UILabel!
    @IBOutlet weak var saleDateLabel: UILabel!
    @IBOutlet weak var salePriceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let currentProperty = selectedProperty!
        addressLabel.text = currentProperty.fullAddress
        descriptionLabel.text = currentProperty.opaDescription
        
        let currencyFormatter = NSNumberFormatter()
        currencyFormatter.numberStyle = .CurrencyStyle
        let formattedAssessment = currencyFormatter.stringFromNumber(currentProperty.assessment)
        let formattedTaxes = currencyFormatter.stringFromNumber(currentProperty.taxes)
        let formattedSalePrice = currencyFormatter.stringFromNumber(currentProperty.salesPrice)
        assessmentLabel.text = formattedAssessment
        taxesLabel.text = formattedTaxes
        salePriceLabel.text = formattedSalePrice
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .LongStyle
        let formattedDate = dateFormatter.stringFromDate(currentProperty.salesDate)
        saleDateLabel.text = formattedDate
        let center = currentProperty.pin.coordinate
        let meters = 100 as Double
        let region = MKCoordinateRegionMakeWithDistance(center, meters, meters)
        let adjustedRegion = mapView.regionThatFits(region)
        mapView.setRegion(adjustedRegion, animated: true)
    }
    
}
