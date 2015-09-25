//
//  BlockDetailTableViewController.swift
//  PropPHL
//
//  Created by Kelly Innes on 9/23/15.
//  Copyright © 2015 Kelly Innes. All rights reserved.
//

import UIKit

class BlockDetailTableViewController: UITableViewController {

    var block: Block!
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Block Details"
        default:
            return nil
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("blockDetailTableCell") as UITableViewCell!
        var label = ""
        var detailLabel = ""
        switch indexPath.row {
        case 0:
            label = "Block Address"
            detailLabel = block.streetAddress
        case 1:
            label = "Neighborhood"
            if block.neighborhood != nil {
                detailLabel = block.neighborhood!
            }
        case 2:
            label = "Number of Properties"
            detailLabel = "\(block.count)"
        case 3:
            let currencyFormatter = NSNumberFormatter()
            currencyFormatter.numberStyle = .CurrencyStyle
            let formattedMedianAssessment = currencyFormatter.stringFromNumber(block.medianAsssessmentValue)!
            label = "Median Assessment Value"
            detailLabel = formattedMedianAssessment
        default:
            print("fizzbuzz")
        }
        cell.textLabel?.text = label
        cell.detailTextLabel?.text = detailLabel
        return cell
    }

}
