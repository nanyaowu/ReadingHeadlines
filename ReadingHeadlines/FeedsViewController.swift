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
        newsItemStore.fetchXML(withXMLAdress: "https://money.udn.com/rssfeed/news/1001/5591/7307?ch=money") {
            (parseData) in
            self.newsItemStore.allNewsItems.append(parseData)
            self.tableView.reloadData()
        }
        //getResult()
        print(newsItemStore.allNewsItems)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsItemStore.allNewsItems[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create an instance of UITableCell with default appereance
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "UITableViewCell")
        
        // Set the text of cell with the title of the newsItem
        let item = newsItemStore.allNewsItems[indexPath.section][indexPath.row] as NewsItem
        cell.textLabel?.text = item.title
        print(cell.textLabel?.text)
        
        return cell
    }
    
    func getResult() {
        newsItemStore.fetchXML(withXMLAdress: "https://money.udn.com/rssfeed/news/1001/5591/7307?ch=money") {
            (parseData) in
            self.newsItemStore.allNewsItems.append(parseData)
        }
    }

}

