//
//  FetchedResultsTableViewController.swift
//
//  Created by Jaimeeee on 6/3/14.
//

import UIKit
import CoreData

class FetchedResultsTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var changeIsUserDriven = false
    
    var fetchedResultsController: NSFetchedResultsController = NSFetchedResultsController() {
        didSet {
            if (fetchedResultsController != oldValue) {
                fetchedResultsController.delegate = self;
                
                if ((!self.title || self.title == oldValue.fetchRequest.entity.name) && (!self.navigationController || !self.navigationItem.title)) {
                    self.title = fetchedResultsController.fetchRequest.entity.name;
                }
                
                if (fetchedResultsController.isKindOfClass(NSFetchedResultsController)) {
                    self.performFetch()
                } else {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func performFetch() {
        if (self.fetchedResultsController.isKindOfClass(NSFetchedResultsController))
        {
            var error: NSError?
            var success = self.fetchedResultsController.performFetch(&error)
            
            if (success) {
                println("Success")
            } else {
                println("Failed")
            }
        }
        self.tableView.reloadData()
    }
    
    // #pragma mark - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        // Return the number of sections.
        return fetchedResultsController.sections.count
    }

    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        var rows = 0
        if (fetchedResultsController.sections.count > 0)
        {
            rows = fetchedResultsController.sections[section].numberOfObjects
        }
        return rows
    }
    
    override func tableView(tableView: UITableView!, titleForHeaderInSection section: Int) -> String! {
        return fetchedResultsController.sections[section].name?
    }

    // #pragma mark - NSFetchedResultsControllerDelegate
    func controllerWillChangeContent(controller: NSFetchedResultsController!) {
        if (!changeIsUserDriven) {
            self.tableView.beginUpdates()
        }
    }
    
    func controller(controller: NSFetchedResultsController!, didChangeSection sectionInfo: NSFetchedResultsSectionInfo!, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        if (!changeIsUserDriven)
        {
            switch type {
            case NSFetchedResultsChangeInsert:
                self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: UITableViewRowAnimation.Fade)
                break
            
            case NSFetchedResultsChangeDelete:
                self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: UITableViewRowAnimation.Fade)
                break
            
            default:
                break
            }
        }
    }
    
    func controller(controller: NSFetchedResultsController!, didChangeObject anObject: AnyObject!, atIndexPath indexPath: NSIndexPath!, forChangeType type: NSFetchedResultsChangeType, newIndexPath : NSIndexPath!) {
        if (!changeIsUserDriven)
        {
            switch type {
            case NSFetchedResultsChangeInsert:
                self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                break;
                
            case NSFetchedResultsChangeDelete:
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                break;
                
            case NSFetchedResultsChangeUpdate:
                self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                break;
                
            case NSFetchedResultsChangeMove:
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                break;
                
            default:
                break
            }
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController!)
    {
        if (!changeIsUserDriven) {
            self.tableView.endUpdates()
        }
    }

}
