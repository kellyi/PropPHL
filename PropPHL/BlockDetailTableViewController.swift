//
//  BlockDetailTableViewController.swift
//  PropPHL
//
//  Created by Kelly Innes on 9/23/15.
//  Copyright © 2015 Kelly Innes. All rights reserved.
//
// NOTE: This is a TableViewController for a grouped table embedded on
// the BlockDetailViewController

import UIKit

class BlockDetailTableViewController: UITableViewController {

    // MARK: - Variables
    
    var block: Block!
    
    // MARK: - TableViewController Methods
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return block.streetAddress
        default:
            return nil
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("blockDetailTableCell") as UITableViewCell!
        var label = ""
        var detailLabel = ""
        switch indexPath.row {
            /*
        case 0:
            label = "Neighborhood"
            if block.neighborhood != nil {
                detailLabel = block.neighborhood!
            }
        */
        case 0:
            label = "Number of Properties"
            detailLabel = "\(block.count)"
        case 1:
            let currencyFormatter = NSNumberFormatter()
            currencyFormatter.numberStyle = .CurrencyStyle
            let formattedMedianAssessment = currencyFormatter.stringFromNumber(block.medianAsssessmentValue)!
            label = "Median Assessment"
            detailLabel = formattedMedianAssessment
        default:
            print("fizzbuzz")
        }
        cell.textLabel?.text = label
        cell.detailTextLabel?.text = detailLabel
        return cell
    }

}
