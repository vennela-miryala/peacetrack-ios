//
//  ActivityTableViewController.swift
//  PeaceTrack
//
//  Created by apple on 8/18/15.
//  Copyright (c) 2015 Systers. All rights reserved.
//

import UIKit
import CoreData

class ActivityTableViewController: UITableViewController, UISearchResultsUpdating {
    
    var tableData = [String]()
    
    var filteredTableData = [String]()
    
    var resultSearchController = UISearchController()
    
    var activities = [NSManagedObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            
            self.tableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
        
        self.tableView.reloadData()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName: "Activity")
        
        var error: NSError?
        
        let fetchedResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as? [NSManagedObject]
        
        let results = fetchedResults
        
        tableData.removeAll(keepCapacity: false);
        if (results != nil) {
            activities = results!
            for (var i=0;i<activities.count;i++) {
                tableData.append((activities[i].valueForKey("name") as? String)!)
            }
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
        
        self.tableView.reloadData()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if (self.resultSearchController.active) {
            return self.filteredTableData.count
        } else {
            return activities.count
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ActivityCell", forIndexPath: indexPath) as! UITableViewCell
        
        if (self.resultSearchController.active) {
            cell.textLabel?.text = filteredTableData[indexPath.row]
            
            return cell
        } else {
            let cohort = activities[indexPath.row]
            cell.textLabel?.text = cohort.valueForKey("name") as? String
            
            return cell
            
        }
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filteredTableData.removeAll(keepCapacity: false)
        
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text)
        
        let array = (tableData as NSArray).filteredArrayUsingPredicate(searchPredicate)
        filteredTableData = array as! [String]
        
        self.tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showActivity" {
            let indexPath:NSIndexPath = self.tableView.indexPathForSelectedRow()!
            let activityDetailVC:ActivityDetailViewController = segue.destinationViewController as! ActivityDetailViewController
            
            let activity = activities[indexPath.row]
            activityDetailVC.name = (activity.valueForKey("name") as? String)!
            activityDetailVC.desc = (activity.valueForKey("activityDescription") as? String)!
            activityDetailVC.cohort = (activity.valueForKey("activityCohort") as? String)!
            activityDetailVC.output = (activity.valueForKey("activityOutput") as? String)!
            activityDetailVC.date = (activity.valueForKey("activityDate") as? String)!
            
        }
    }

    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
