//
//  FetchedResultsTableViewController.swift
//  Planbok
//
//  Created by Jaime on 10/22/14.
//  Copyright (c) 2014 Jaime Zaragoza. All rights reserved.
//

import UIKit
import CoreData

class FetchedResultsTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    required init?(coder aDecoder: NSCoder) {
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
        do {
            try fetchedResultsController!.performFetch()
        } catch let error as NSError {
            print("performFetch: failed")
            print("CoreData Error: \(error.localizedDescription)")
        }
        tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController!.sections!.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController!.sections![section] as NSFetchedResultsSectionInfo
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionInfo = fetchedResultsController!.sections![section] as NSFetchedResultsSectionInfo
        return sectionInfo.name
    }
    
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
                tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
                
            case NSFetchedResultsChangeType.Delete:
                tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
                
            default:
                return
            }
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        if !changeIsUserDriven {
            switch type {
            case NSFetchedResultsChangeType.Insert:
                tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
                
            case NSFetchedResultsChangeType.Delete:
                tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
                
            case NSFetchedResultsChangeType.Move:
                tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
                tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
                
            case NSFetchedResultsChangeType.Update:
                tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
                tableView.insertRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
            }
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        if !changeIsUserDriven {
            tableView.endUpdates()
        }
    }
}
