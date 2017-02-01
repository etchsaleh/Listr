//
//  MainVC.swift
//  Listr
//
//  Created by Hesham Saleh on 1/29/17.
//  Copyright © 2017 Hesham Saleh. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    
    @IBOutlet weak var segment: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    var controller: NSFetchedResultsController<Item>!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //generateTestData()
        attemptFetch()
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Creating cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        
        return cell
    }
    
    func configureCell(cell: ItemCell, indexPath:NSIndexPath) {
        
        let item = controller.object(at: indexPath as IndexPath)
        cell.configureCell(item: item)
    }
    
    //Make sure there are objects in controller, then set 'item' to the selected object.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let objects = controller.fetchedObjects , objects.count > 0 {
            
            let item = objects[indexPath.row]
            performSegue(withIdentifier: "ItemDetailsVC", sender: item)
        }
    }
    
    //Set the destination VC as 'ItemDetailsVC' and cast sender 'item' as type Item, then set 'itemToEdit' to 'item'.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ItemDetailsVC" {
            if let destination = segue.destination as? ItemDetailsVC {
                if let item = sender as? Item {
                    destination.itemToEdit = item
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sections = controller.sections {
            
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = controller.sections {
            
            return sections.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 150
    }
    
    func attemptFetch() {
        
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        
        //Sorting (Segment Control)
        let dateSort = NSSortDescriptor(key: "created", ascending: false) //Sort results according date.
        
        let priceSort = NSSortDescriptor(key: "price", ascending: false)
        
        let titleSort = NSSortDescriptor(key: "title", ascending: true)
        
        if segment.selectedSegmentIndex == 0 {
            
            fetchRequest.sortDescriptors = [dateSort]
            
        } else if segment.selectedSegmentIndex == 1 {
            
            fetchRequest.sortDescriptors = [priceSort]
            
        } else if segment.selectedSegmentIndex == 2 {
            
            fetchRequest.sortDescriptors = [titleSort]
        }
    
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        //in order for methods below to work
        controller.delegate = self
        
        self.controller = controller
        
        do {
            try controller.performFetch()
        } catch {
            
            let error = error as NSError
            print("\(error)")
        }
    }
    
    @IBAction func segmentChange(_ sender: UISegmentedControl) {
        
        attemptFetch()
        tableView.reloadData()
    }
    
    
    
    
    
    //Whenever TableView is about to update, this will start to listen for changes and handle them.
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.endUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch(type) {
            
        case.insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case.delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case.update:
            if let indexPath = indexPath {
                let cell = tableView.cellForRow(at: indexPath) as! ItemCell
                configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
            }
            break
        case.move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        }
    }
    
    func generateTestData() {
        
        let item1 = Item(context: context)
        item1.title = "MacBook Pro"
        item1.price = 1800
        item1.details = "I can't wait until the September event, I hope they release the new MBPs"
        
        let item2 = Item(context: context)
        item2.title = "Tesla Model S"
        item2.price = 110000
        item2.details = "Oh man, this is a beautiful car. One day I will have it."
        
        let item3 = Item(context: context)
        item3.title = "Bose Headphones"
        item3.price = 400
        item3.details = "Man! Its damn great to have those noise cancelling headphones"
        
        ad.saveContext()
        
    }
    
    
    
}

