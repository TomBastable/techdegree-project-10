//
//  MasterViewController.swift
//  P10 Diary
//
//  Created by Tom Bastable on 02/12/2019.
//  Copyright © 2019 Tom Bastable. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UITableViewController, UISearchBarDelegate {
    
    //MARK: - Properties
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let managedObjectContext = CoreDataStack().managedObjectContext
    
    //fetched results controller - this will change when a user searches.
    lazy var fetchedResultsController: EntryFetchedResultsController = {
        return EntryFetchedResultsController(managedObjectContext: self.managedObjectContext, tableView: self.tableView, request: Entry.fetchRequest())
    }()
    
    //MARK: - VWA
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //reload tableview to ensure cells are accurately reflected
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    //MARK: - TableView Data Source
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard let section = fetchedResultsController.sections?[section] else { return 0 }
        return section.numberOfObjects
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //initialise cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath) as! MasterTableViewCell
        // Configure the cell...
        return configureCell(cell, at: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        //setup delete swipe option
        return .delete
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //remove entry and save
        let entry = fetchedResultsController.object(at: indexPath)
        managedObjectContext.delete(entry)
        managedObjectContext.saveChanges()
    }
    
    //Configure each cell
    
    private func configureCell(_ cell: MasterTableViewCell, at indexPath: IndexPath) -> MasterTableViewCell {
        //get entry at indexpath
        let entry = fetchedResultsController.object(at: indexPath)
        //set entry details to UI
        cell.titleLabel.text = entry.title
        cell.subtitleLabel.text = entry.subTitle
        cell.dateLabel.text = "Last Updated: \(entry.dateCreated!)"
        //return
        return cell
    }
    
    //MARK: - Add Entry IBAction
    
    @IBAction func addEntry(_ sender: Any) {
        
        performSegue(withIdentifier: "addEntry", sender: self)
        
    }
    
    //MARK: - Search Bar Delegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        //setup an NSPredicate for the search contents
        var predicate: NSPredicate = NSPredicate()
        predicate = NSPredicate(format: "title CONTAINS[cd] %@ || subTitle CONTAINS[cd] %@ || mainBody CONTAINS[cd] %@", searchText, searchText, searchText)
        //setup request
        let request = NSFetchRequest<Entry>(entityName: "Entry")
        //setup required sort descriptor
        request.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: false)]
        //add predicate
        request.predicate = predicate
        
        //if search bar is empty or next best, display all results
        if searchText == "" || searchText.count == 0 || searchText == " " {
            
            fetchedResultsController = EntryFetchedResultsController(managedObjectContext: self.managedObjectContext, tableView: self.tableView, request: Entry.fetchRequest())
        
        //else display search results
        }else{
        fetchedResultsController = EntryFetchedResultsController(managedObjectContext: self.managedObjectContext, tableView: self.tableView, request: request)
        }
        
        //dispatch to main queue - reload tableview
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    //MARK: - Prepare for segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "addEntry"{
            
            let entryCreationVC = segue.destination as! EntryCreationViewController
            //ensure the same context is passed
            entryCreationVC.managedObjectContext = self.managedObjectContext
            
        }else if segue.identifier == "viewEntry"{
            
            let entryVC = segue.destination as! EntryViewController
            let cell = sender as! MasterTableViewCell
            //find index for selected cell
            let index = self.tableView.indexPath(for: cell)
            //retrieve relevant entry
            let entry = fetchedResultsController.object(at: index!)
            //set entry to VC
            entryVC.context = self.managedObjectContext
            entryVC.entry = entry
            
        }
        
    }

}
