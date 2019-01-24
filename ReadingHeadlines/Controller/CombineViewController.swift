//
//  CombineViewController.swift
//  ReadingHeadlines
//
//  Created by freakytune on 2019/1/20.
//  Copyright © 2019 freakytune. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class CombineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AVSpeechSynthesizerDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var playView: UIView!
    @IBOutlet weak var playButton: UIButton!
    let spinner1 = UIActivityIndicatorView()
    
    
    let synth = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: "")
    
    var newsItemStore: NewsItemStore!
    var cellID = "cell"
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("CombineView loaded")
        
        synth.delegate = self
        newsItemStore = NewsItemStore()
        setLoadingScreen()
        print("spinner start animating")
        
        DispatchQueue.main.async {
            self.downloadAndRenew()
            print("stop group queue")
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
        tableView.register(FeedCell.self, forCellReuseIdentifier: cellID)
        
    }
    
    
    
    func downloadAndRenew() {
        print(newsItemStore.downloadTask())
        print("download task finished")
        self.tableView.reloadData()
        //self.spinner.stopAnimating()
        print("stop spinnng")
        self.playButton.isHidden = false
        self.removeLoadingScreen()
        
    }
    
    private func setLoadingScreen() {
        
        // Sets the view which contains the loading text and the spinner
        let width: CGFloat = 30
        let height: CGFloat = 30
        let x = (tableView.frame.width / 2) - width / 2
        let y = (tableView.frame.height / 2) - height / 2 + (navigationController?.navigationBar.frame.height)!
        
        // Sets spinner
        spinner1.style = .gray
        spinner1.frame = CGRect(x: x, y: y, width: width, height: height)
        spinner1.startAnimating()
        
        tableView.addSubview(spinner1)
        
    }
    
    // Remove the activity indicator from the main view
    private func removeLoadingScreen() {
        
        // Hides and stops the text and the spinner
        spinner1.stopAnimating()
        spinner1.isHidden = true
        
    }
    
    // MARK:- UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return newsItemStore.allNewsItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsItemStore.allNewsItems[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create dequeueReusableCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FeedCell
        cell.delegate = self
        
        // Set the text of cell with the title of the newsItem
        let item = newsItemStore.allNewsItems[indexPath.section][indexPath.row]
        cell.textLabel?.text = item.title
        
        cell.accessoryView?.tintColor = .lightGray //item.isFavored ? UIColor.red : UIColor.lightGray
        
        return cell
    }
    
    // MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "RSSWeb", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    // MARK: prepare segure
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
    
    
    
    // MARK:- 播放控制
    var isPlaying = false
    var isPausing = false
    var feedsCounter = 0
    var feedsTotal = 0
    
    @IBAction func startReadingRSS(_ sender: UIButton) {
        
        if isPlaying == false {
            
            isPlaying = true
            playButton.setTitle("Pause", for: .normal)
            
            for newsItem in newsItemStore.allNewsItems {
                for item in newsItem {
                    feedsTotal += 1
                }
            }
            
            print(feedsTotal)
            
            
            for newsItem in newsItemStore.allNewsItems {
                for item in newsItem {
                    feedsCounter += 1
                    let readingString = newsItemStore.readingString(newsItem: item)
                    myUtterance = AVSpeechUtterance(string: readingString)
                    myUtterance.rate = 1
                    myUtterance.pitchMultiplier = 1.2
                    myUtterance.postUtteranceDelay = 0.4
                    myUtterance.volume = 1
                    
                    myUtterance.voice = AVSpeechSynthesisVoice(language: "zh-TW")
                    synth.speak(myUtterance)
                    
                }
            }
            
            

            
            
        } else {
            if isPausing == false {
                isPausing = true
                synth.pauseSpeaking(at: .immediate)
                playButton.setTitle("Continue", for: .normal)
            } else {
                isPausing = false
                synth.continueSpeaking()
                playButton.setTitle("Pause", for: .normal)
            }
        }
    }
    
    //播放結束後button調整
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        
        if feedsCounter == feedsTotal {
            isPlaying = false
            playButton.setTitle("Play", for: .normal)
            feedsCounter = 0
            feedsTotal = 0
        }
        
    }
    
    
    
}

// MARK: - Conform to Favorited
extension CombineViewController: Favorited {
    
    // 傳遞favored button被按到
    func clickFavored(cell: UITableViewCell) {
        print("now in FeedsViewController")
        
        guard let tappedIndexPath = tableView.indexPath(for: cell) else{
            print("did not generate indexPath.")
            return
        }
    
        // copy the information of the rows to foverFeeds
         let tappedFeed = newsItemStore.allNewsItems[tappedIndexPath.section][tappedIndexPath.row]
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
