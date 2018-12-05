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
        return newsItemStore.allNewsItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create an instance of UITableCell with default appereance
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "UITableViewCell")
        
        // Set the text of cell with the title of the newsItem
        let item = newsItemStore.allNewsItems[indexPath.row]
        cell.textLabel?.text = item.title
        
        return cell
    }

}

