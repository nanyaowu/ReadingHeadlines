//
//  ViewController.swift
//  ReadingHeadlines
//
//  Created by freakytune on 2018/12/3.
//  Copyright © 2018 freakytune. All rights reserved.
//

import UIKit
import CoreData


class FeedsViewController: UITableViewController {
    
    var newsItemStore: NewsItemStore!
    var cellID = "cellID"
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // var favorFeeds = [FavorFeeds]()
    
    @IBAction func FavorPage(_ sender: UIBarButtonItem) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        print("FeedsViewController loaded its view")
        print(newsItemStore.allNewsItems.count)
        
        tableView.rowHeight = 100
        tableView.register(FeedCell.self, forCellReuseIdentifier: cellID)
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return newsItemStore.allNewsItems.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
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
        let item = newsItemStore.allNewsItems[indexPath.section][indexPath.row]
        cell.textLabel?.text = item.title
        
        cell.accessoryView?.tintColor = .lightGray //item.isFavored ? UIColor.red : UIColor.lightGray
        
        
        print(cell.textLabel?.text ?? "no text")
        
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
            
        case "Favorite"?:
            print("switching to Favorite page.")
            //let destinationVC = segue.destination as! FavoriteViewController
            //destinationVC.favorFeeds = favorFeeds
            
        default:
            preconditionFailure("Unexpected segue identifier")
            
        }
        
    }
    
    

}

// MARK: - Favorited
extension FeedsViewController: Favorited {
    
    // 傳遞favored button被按到
    func clickFavored(cell: UITableViewCell) {
        print("now in FeedsViewController")
        
        guard let tappedIndexPath = tableView.indexPath(for: cell) else{
            print("did not generate indexPath.")
            return
        }
        
        //reverse the favorite icon
        let tappedFeed = newsItemStore.allNewsItems[tappedIndexPath.section][tappedIndexPath.row]
        newsItemStore.allNewsItems[tappedIndexPath.section][tappedIndexPath.row].isFavored = !tappedFeed.isFavored
        tableView.reloadRows(at: [tappedIndexPath], with: .fade)
        
        
        // copy the information of the rows to foverFeeds
        let favorFeed = FavorFeeds(context: self.context)
        favorFeed.title = tappedFeed.title
        favorFeed.link = tappedFeed.link
        favorFeed.detail = tappedFeed.description
        
        var hasFavored = false
        for feed in favorFeeds.reversed() {
            if tappedFeed.title == feed.title {
                print("has favorited")
                hasFavored = true
                break
            }
        }
        
        //如果已經加過了加警示 沒有的話就直接加
        if hasFavored == true {
            let title = "這則新聞已在你的最愛中"
            let message = "確定要增加這則新聞嗎?"
            let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            ac.addAction(cancelAction)
            
            // 若按新增 將該feed加進最愛
            let addAction = UIAlertAction(title: "新增", style: .destructive) { (action) in
                favorFeeds.append(favorFeed)
                self.saveFeeds()
            }
            ac.addAction(addAction)
            present(ac, animated: true, completion: nil)
            
        } else {
            favorFeeds.append(favorFeed)
            self.saveFeeds()
            
            // 顯示已加入最愛
            let title = "已加入最愛"
            let ac = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
            present(ac, animated: true)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                ac.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    func saveFeeds() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}
