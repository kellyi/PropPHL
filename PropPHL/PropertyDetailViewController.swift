//
//  PropertyDetailViewController.swift
//  PropPHL
//
//  Created by Kelly Innes on 9/16/15.
//  Copyright © 2015 Kelly Innes. All rights reserved.
//

import UIKit

class PropertyDetailViewController: UIViewController {

    var selectedProperty: Property?
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var assessmentLabel: UILabel!
    @IBOutlet weak var taxesLabel: UILabel!
    @IBOutlet weak var saleDateLabel: UILabel!
    @IBOutlet weak var salePriceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Property Detail"
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let currentProperty = selectedProperty!
        addressLabel.text = currentProperty.fullAddress
        assessmentLabel.text = "\(currentProperty.assessment)"
        taxesLabel.text = "\(currentProperty.taxes)"
        salePriceLabel.text = "\(currentProperty.salesPrice)"
        saleDateLabel.text = "\(currentProperty.salesDate)"
        descriptionLabel.text = currentProperty.description
    }

}
