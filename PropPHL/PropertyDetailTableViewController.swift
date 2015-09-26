//
//  PropertyDetailTableViewController.swift
//  PropPHL
//
//  Created by Kelly Innes on 9/23/15.
//  Copyright © 2015 Kelly Innes. All rights reserved.
//
// NOTE: This is a TableViewController for a grouped table embedded on
// the PropertyDetailViewController

import UIKit

class PropertyDetailTableViewController: UITableViewController {

    // MARK: - Variables
    
    var property: Property!
    
    // MARK: - TableViewController Methods

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellIdentifier: String = "detailCell"
        var label: String = ""
        var detailLabel: String = ""
        let currencyFormatter = NSNumberFormatter()
        currencyFormatter.numberStyle = .CurrencyStyle
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .LongStyle
        switch indexPath.row {
        case 0:
            cellIdentifier = "basicCell"
            label = property.fullAddress
        case 1:
            cellIdentifier = "basicCell"
            label = property.opaDescription
        case 2:
            label = "Assessment"
            detailLabel = currencyFormatter.stringFromNumber(property.assessment)!
        case 3:
            label = "Taxes"
            detailLabel = currencyFormatter.stringFromNumber(property.taxes)!
        case 4:
            label = "Last Sale Date"
            detailLabel = dateFormatter.stringFromDate(property.salesDate)
        case 5:
            label = "Last Sale Price"
            detailLabel = currencyFormatter.stringFromNumber(property.salesPrice)!
        default:
            print("fizzbuzz")
        }
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as UITableViewCell!
        cell.textLabel?.text = label
        cell.detailTextLabel?.text = detailLabel
        return cell
    }

}
