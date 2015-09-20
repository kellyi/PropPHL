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
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timeWhenAdded", ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
            managedObjectContext: self.sharedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addBlock")
        let appInfoButton = UIBarButtonItem(title: "Info", style: .Plain, target: self, action: "appInfoButtonPressed")
        self.navigationItem.leftBarButtonItem = addButton
        self.navigationItem.rightBarButtonItem = appInfoButton
        self.title = "Saved Blocks"
    }
    
    func addBlock() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func appInfoButtonPressed() {
        print("appInfoButtonPressed")
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PHLOPAClient.sharedInstance().savedBlocks.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("blockCell", forIndexPath: indexPath)
        let blockForIndexPath = PHLOPAClient.sharedInstance().savedBlocks[indexPath.row]
        let title = blockForIndexPath.streetAddress
        let formatter = NSDateFormatter()
        formatter.dateStyle = .LongStyle
        formatter.timeStyle = .ShortStyle
        let formattedDate = formatter.stringFromDate(blockForIndexPath.timeWhenAdded)
        cell.textLabel?.text = title
        cell.layer.cornerRadius = 5.0
        cell.detailTextLabel?.text = "saved \(formattedDate)"
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            PHLOPAClient.sharedInstance().savedBlocks.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "blockTableVCtoPropTableVC" {
            let indexPath = self.tableView.indexPathForCell(sender as! UITableViewCell)
            let propTableVC = segue.destinationViewController as! PropertyTableViewController
            let block = PHLOPAClient.sharedInstance().savedBlocks[indexPath!.row]
            propTableVC.title = block.streetAddress
        }
    }
    
    // MARK: - NSFetchedResultsControllerDelegate Methods
    
    // Satisfy the compiler that the NSFetchedResultsControllerDelegate's set up
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        
    }
}
