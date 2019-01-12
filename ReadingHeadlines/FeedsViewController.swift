//
//  ViewController.swift
//  ReadingHeadlines
//
//  Created by freakytune on 2018/12/3.
//  Copyright © 2018 freakytune. All rights reserved.
//

import UIKit


class FeedsViewController: UITableViewController, Favorited {
    // 傳遞favored button被按到
    func clickFavored(cell: UITableViewCell) {
        print("now in FeedsViewController")
        
        guard let tappedIndexPath = tableView.indexPath(for: cell) else{
            print("did not generate indexPath.")
            return
        }
        
        //reverse the favorite icon
        newsItemStore.allNewsItems[tappedIndexPath.section][tappedIndexPath.row].isFavored = !newsItemStore.allNewsItems[tappedIndexPath.section][tappedIndexPath.row].isFavored
        
        tableView.reloadRows(at: [tappedIndexPath], with: .fade)
    }
    
    
    var newsItemStore: NewsItemStore!
    var cellID = "cellID"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print("FeedsViewController loaded its view")
        print(newsItemStore.allNewsItems.count)
        
        tableView.register(FeedCell.self, forCellReuseIdentifier: cellID)
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return newsItemStore.allNewsItems.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsItemStore.allNewsItems[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        if newsItemStore.allNewsItems[section][0].link!.hasPrefix("http://news.ltn") {
            return "自由時報"
        } else if newsItemStore.allNewsItems[section][0].link!.hasPrefix("https://www.chinatimes") {
            return "中國時報"
        } else if newsItemStore.allNewsItems[section][0].link!.hasPrefix("https://money.udn") {
            return "經濟日報"
        } else {
            return nil
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create dequeueReusableCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as! FeedCell
        cell.delegate = self
        
        // Set the text of cell with the title of the newsItem
        let item = newsItemStore.allNewsItems[indexPath.section][indexPath.row] as NewsItem
        cell.textLabel?.text = item.title
        
        cell.accessoryView?.tintColor = item.isFavored ? UIColor.red : UIColor.lightGray
        
        
        print(cell.textLabel?.text)
        
        return cell
    }
    
    // MARK: Prepare segue
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "RSSWeb", sender: self)
    }
    
    
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

