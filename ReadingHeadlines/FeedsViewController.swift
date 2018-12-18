//
//  ViewController.swift
//  ReadingHeadlines
//
//  Created by freakytune on 2018/12/3.
//  Copyright © 2018 freakytune. All rights reserved.
//

import UIKit


class FeedsViewController: UITableViewController {
    
    var newsItemStore: NewsItemStore!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print("FeedsViewController loaded its view")
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsItemStore.allNewsItems[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create dequeueReusableCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // Set the text of cell with the title of the newsItem
        let item = newsItemStore.allNewsItems[indexPath.section][indexPath.row] as NewsItem
        cell.textLabel?.text = item.title
        print(cell.textLabel?.text)
        
        return cell
    }
    
    // MARK: Prepare segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "RSSWeb"?:
            let destinationVC = segue.destination as! WebViewController
            if let section = tableView.indexPathForSelectedRow?.section,
                let row = tableView.indexPathForSelectedRow?.row {
                print(section)
                print(row)
                destinationVC.rssLink = newsItemStore.allNewsItems[section][row].link
            }
            
        default:
            preconditionFailure("Unexpected segue identifier")
        }
    }
    

}

