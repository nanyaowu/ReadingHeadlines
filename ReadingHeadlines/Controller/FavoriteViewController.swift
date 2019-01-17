//
//  FavoriteViewController.swift
//  ReadingHeadlines
//
//  Created by freakytune on 2019/1/14.
//  Copyright © 2019 freakytune. All rights reserved.
//

import UIKit
import CoreData

var favorFeeds = [FavorFeeds]()

class FavoriteViewController: UITableViewController {
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        tableView.rowHeight = 60
        
        loadFeeds()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorFeeds.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create dequeueReusableCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavorCell", for: indexPath)
        
        let item = favorFeeds[indexPath.row] // as FavorFeed
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.detail
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // If the table view is asking to commit a delete command...
        if editingStyle == .delete {
            let item = favorFeeds[indexPath.row]
            
            let title = "刪除: \(item.title!)?"
            let message = "確定要刪除這則新聞嗎?"
            
            let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            ac.addAction(cancelAction)
            let deleteAction = UIAlertAction(title: "刪除", style: .destructive, handler: { (action) -> Void in
                // Remove the item from the store
                self.context.delete(favorFeeds[indexPath.row])
                favorFeeds.remove(at: indexPath.row)
                
                self.saveFeeds()
            })
            ac.addAction(deleteAction)
            
            // Present the alert controller
            present(ac, animated: true, completion: nil)
        }
    }
    
    func loadFeeds() {
        let request: NSFetchRequest<FavorFeeds> = FavorFeeds.fetchRequest()
        do {
            favorFeeds = try context.fetch(request)
            favorFeeds = favorFeeds.reversed()
        } catch {
            print("Error fetching data from context: \(error)")
        }
    }
    
    
    func saveFeeds() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
        tableView.reloadData()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "favorToRSSWeb"?:
            let destinationVC = segue.destination as! WebViewController
            if let section = tableView.indexPathForSelectedRow?.section,
                let row = tableView.indexPathForSelectedRow?.row {
                print(section)
                print(row)
                destinationVC.rssLink = favorFeeds[row].link
            }
            
        default:
            preconditionFailure("Unexpected segue identifier")
            
        }
        
    }
    
}


