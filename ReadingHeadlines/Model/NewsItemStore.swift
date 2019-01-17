//
//  NewsItemStore.swift
//  ReadingHeadlines
//
//  Created by freakytune on 2018/12/4.
//  Copyright © 2018 freakytune. All rights reserved.
//

import UIKit

class NewsItemStore {
    
    var allNewsItems = [[NewsItem]]()
    var newsURLs = ["https://money.udn.com/rssfeed/news/1001/5591/7307?ch=money", "https://www.chinatimes.com/rss/chinatimes-focus.xml", "http://news.ltn.com.tw/rss/focus.xml"]
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    //let serialQueue = DispatchQueue(label: "com.nanyao.serial")
    
    func fetchXML(withXMLAdress xmlAdress: String, completion: @escaping ([NewsItem]) -> Void) {
        
        if let url = URL(string: xmlAdress) {
            let task = session.dataTask(with: url) {
                (data, response, error) -> Void in
                // 如果出現error就跳出
                if error != nil {
                    print(error!.localizedDescription)
                    return
                }
                // 確認出現data
                if let rssData = data {
                    let parser = XMLParser(data: rssData)
                    let rssParserDelegate = RSSParserDelegate()
                    parser.delegate = rssParserDelegate
                    if parser.parse() == true {
                        print("Parse succeed. \(xmlAdress)")
                        let parseData = rssParserDelegate.getResult()
                        completion(parseData)
                        
                    } else {
                        print("Parse fail")
                    }
                }
            }
            task.resume()
        }
    }
    
    func downloadTask() -> String {
        
        
        // 將newsURL中的網址下載到allNewItems
        let group = DispatchGroup()
        let serialQueue = DispatchQueue(label: "com.nanyao")
        serialQueue.async(group: group) {
            
            for url in self.newsURLs {
                group.enter()
                self.fetchXML(withXMLAdress: url) {
                    (parseData) in
                    self.allNewsItems.append(parseData)
                    group.leave()
                }
            }
            
        }
        print("fetchstart")
        group.wait()
        print("fetch finished")
        return "Fetching finished"
    }
    
    
    
    
    
    func combinString(_: [[NewsItem]]) -> String {
        
        var newsString = String()
        
        for news in self.allNewsItems {
            for item in news {
                
                // addding where the news is from
                switch item.link?.prefix(15) {
                case "http://news.ltn":
                    newsString.append("自由時報。")
                case "https://www.chi":
                    newsString.append("中國時報。")
                case "https://money.u":
                    newsString.append("經濟日報。")
                default:
                    newsString.append("，")
                }
                
                let tempTitle = item.title!.replacingOccurrences(of: " ", with: "，", options: .literal, range: nil)
                let currentTitle = tempTitle.replacingOccurrences(of: "，，", with: "，", options: .literal, range: nil)
                newsString.append(currentTitle)
                newsString.append("。")
                print("\(item.title ?? "no title")")
            }
        }
        
        return newsString
        
    }
    
}
