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
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        context.delete(favorFeeds[indexPath.row])
        favorFeeds.remove(at: indexPath.row)
        
        saveFeeds()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
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
    
}


