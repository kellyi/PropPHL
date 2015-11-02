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
            return "Block: \(block.streetAddress)"
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
        let currencyFormatter = NSNumberFormatter()
        currencyFormatter.numberStyle = .CurrencyStyle
        switch indexPath.row {
        case 0:
            label = "Number of Properties"
            detailLabel = "\(block.count)"
        case 1:
            let formattedMedianAssessment = currencyFormatter.stringFromNumber(block.medianAsssessmentValue)!
            label = "Median Assessment"
            detailLabel = formattedMedianAssessment
        case 2:
            let formattedLowestAssessment = currencyFormatter.stringFromNumber(block.lowestAssessmentValue)!
            label = "Low Assessment"
            detailLabel = formattedLowestAssessment
        case 3:
            let formattedHighestAssessment = currencyFormatter.stringFromNumber(block.highestAssessmentValue)!
            label = "High Assessment"
            detailLabel = formattedHighestAssessment
        default:
            print("fizzbuzz")
        }
        cell.textLabel?.text = label
        cell.detailTextLabel?.text = detailLabel
        return cell
    }

}
