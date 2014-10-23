//
//  FetchedResultsTableViewController.swift
//
//  Created by Jaimeeee on 3/06/14.
//  Updated: 22/10/14.
//

import UIKit
import CoreData

class FetchedResultsTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var changeIsUserDriven: Bool = false
    
    // MARK: Fetching
    var fetchedResultsController: NSFetchedResultsController? {
        didSet {
            if oldValue != fetchedResultsController {
                fetchedResultsController?.delegate = self
                performFetch()
            }
        }
    }
    
    func performFetch() {
        var error: NSError?
        var success: Bool = fetchedResultsController!.performFetch(&error)
        if (!success) {
            println("performFetch: failed")
        }
        if error != nil {
            println("\(error!.localizedDescription)")
        }
        tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        let sections = fetchedResultsController!.sections!.count
        return sections
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 0
        if fetchedResultsController!.sections!.count > 0 {
            let sectionInfo: NSFetchedResultsSectionInfo = fetchedResultsController!.sections?[section] as NSFetchedResultsSectionInfo
            rows = sectionInfo.numberOfObjects
        }
        return rows;
    }
    
    // FIXME:
    /*
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return fetchedResultsController!.sections?[section].name
    }
    */
    
    // MARK: NSFetchedResultsControllerDelegate
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        if !changeIsUserDriven {
            tableView.beginUpdates()
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        if !changeIsUserDriven {
            switch type {
            case NSFetchedResultsChangeType.Insert:
                tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: UITableViewRowAnimation.Fade)
                break
                
            case NSFetchedResultsChangeType.Delete:
                tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: UITableViewRowAnimation.Fade)
                
            default:
                println("Section")
            }
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        if !changeIsUserDriven {
            switch type {
            case NSFetchedResultsChangeType.Insert:
                tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
                
            case NSFetchedResultsChangeType.Delete:
                tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
                
            case NSFetchedResultsChangeType.Update:
                tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
                
            case NSFetchedResultsChangeType.Move:
                tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
                tableView.insertRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
                
            default:
                println("Object change")
            }
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        if !changeIsUserDriven {
            tableView.endUpdates()
        }
    }
}
