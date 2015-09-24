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
        return 3
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Block"
        case 1:
            return "Neighborhood"
        case 2:
            return "Median Assessment"
        default:
            return nil
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = tableView.headerViewForSection(section)
        header?.tintColor = .oceanColor()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("blockDetailTableCell") as UITableViewCell!
        var label = ""
        switch indexPath.section {
        case 0:
            label = block.streetAddress
        case 1:
            label = "East Falls"
        case 2:
            let currencyFormatter = NSNumberFormatter()
            currencyFormatter.numberStyle = .CurrencyStyle
            let formattedMedianAssessment = currencyFormatter.stringFromNumber(block.medianAsssessmentValue)!
            label = formattedMedianAssessment
        default:
            label = "This should never show up!"
        }
        cell.textLabel?.text = label
        return cell
    }

}
