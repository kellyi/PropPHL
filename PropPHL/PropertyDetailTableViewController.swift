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
        return 4
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return property.fullAddress
        default:
            return nil
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellIdentifier: String = "detailCell"
        var label: String = ""
        var detailLabel: String = ""
        let currencyFormatter = NSNumberFormatter()
        currencyFormatter.numberStyle = .CurrencyStyle
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .ShortStyle
        switch indexPath.row {
        case 0:
            cellIdentifier = "basicCell"
            label = property.opaDescription
        case 1:
            label = "Assessed Value"
            detailLabel = currencyFormatter.stringFromNumber(property.assessment)!
        case 2:
            label = "Taxes"
            detailLabel = currencyFormatter.stringFromNumber(property.taxes)!
        case 3:
            label = "Last Sale"
            detailLabel = currencyFormatter.stringFromNumber(property.salesPrice)! + " on " + dateFormatter.stringFromDate(property.salesDate)
        default:
            print("fizzbuzz")
        }
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as UITableViewCell!
        cell.textLabel?.text = label
        cell.detailTextLabel?.text = detailLabel
        return cell
    }

}
