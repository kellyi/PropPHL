//
//  BlockTableViewController.swift
//  PropPHL
//
//  Created by Kelly Innes on 9/14/15.
//  Copyright © 2015 Kelly Innes. All rights reserved.
//

import UIKit
import CoreData

class BlockTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    // MARK: - Variables
    
    // NSIndexPath arrays to store selected tableViewCells to remove
    var selectedIndexes = [NSIndexPath]()
    var insertedIndexPaths: [NSIndexPath]!
    var deletedIndexPaths: [NSIndexPath]!
    var updatedIndexPaths: [NSIndexPath]!
    
    // NSManagedObjectContext
    lazy var sharedContext: NSManagedObjectContext = {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }()
    
    // NSFetchedResultsController
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: "Block")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timeWhenAdded", ascending: false)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
            managedObjectContext: self.sharedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        return fetchedResultsController
    }()
    
    // MARK: - View Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addBlock")
        let appInfoButton = UIBarButtonItem(title: "About", style: .Plain, target: self, action: "appInfoButtonPressed")
        self.navigationItem.leftBarButtonItem = addButton
        self.navigationItem.rightBarButtonItem = appInfoButton
        self.title = "Blocks"
        try! fetchedResultsController.performFetch()
        fetchedResultsController.delegate = self
    }
    
    // MARK: - Navigation Bar Button Actions
    
    func addBlock() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func appInfoButtonPressed() {
        let aboutVC = self.storyboard?.instantiateViewControllerWithIdentifier("aboutViewController") as! AboutViewController!
        self.presentViewController(aboutVC, animated: true, completion: nil)
    }
    
    // MARK: - TableViewController Methods
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("blockCell", forIndexPath: indexPath)
        let blockForIndexPath = fetchedResultsController.objectAtIndexPath(indexPath) as! Block
        let title = blockForIndexPath.streetAddress
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = .ShortStyle
        let formattedDate = formatter.stringFromDate(blockForIndexPath.timeWhenAdded)
        cell.textLabel?.text = title
        cell.layer.cornerRadius = 5.0
        cell.detailTextLabel?.text = "saved \(formattedDate)"
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch (editingStyle) {
        case .Delete:
            let block = fetchedResultsController.objectAtIndexPath(indexPath) as! Block
            sharedContext.deleteObject(block)
            CoreDataStackManager.sharedInstance().saveContext()
        default:
            break
        }
    }
    
    // MARK: - Prep for Segue to Block Detail View or Property Table View
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "blockTableVCtoPropTableVC" {
            let indexPath = self.tableView.indexPathForCell(sender as! UITableViewCell)
            let propTableVC = segue.destinationViewController as! PropertyTableViewController
            let block = fetchedResultsController.objectAtIndexPath(indexPath!)
            propTableVC.block = block as! Block
            propTableVC.title = block.streetAddress
        } else if segue.identifier == "blockTableToDetailVC" {
            let indexPath = self.tableView.indexPathForCell(sender as! UITableViewCell)
            let blockDetailVC = segue.destinationViewController as! BlockDetailViewController
            let block = fetchedResultsController.objectAtIndexPath(indexPath!)
            blockDetailVC.block = block as! Block
            blockDetailVC.title = block.streetAddress
        }
    }
    // MARK: - NSFetchedResultsControllerDelegate Methods
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Insert:
            self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        case .Delete:
            self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        default:
            return
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        default:
            return
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }
}
