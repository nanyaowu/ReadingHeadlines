//
//  NewsItemStore.swift
//  ReadingHeadlines
//
//  Created by freakytune on 2018/12/4.
//  Copyright © 2018 freakytune. All rights reserved.
//

import UIKit

class NewsItemStore {
    
    var allNewsItems = [NewsItem]()
    var tableView: UIView!
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    
    func fetchXML(withXMLAdress xmlAdress: String, completion: @escaping ([NewsItem]) -> Void) {
        
        if let url = URL(string: xmlAdress) {
            let task = session.dataTask(with: url) {
                (data, response, error) -> Void in
                if error != nil {
                    print(error!.localizedDescription)
                    return
                }
                if let rssData = data {
                    let parser = XMLParser(data: rssData)
                    let rssParserDelegate = RSSParserDelegate()
                    parser.delegate = rssParserDelegate
                    if parser.parse() == true {
                        print("Parse succeed.")
                        let parseData = rssParserDelegate.getResult()
                        OperationQueue.main.addOperation {
                            completion(parseData)
                        }
                        
                        
//                        DispatchQueue.main.async {
//                            self.tableView.reloadData()
//                        }
                    } else {
                        print("Parse fail")
                    }
                }
            }
            // 錯誤 資料傳不出來這邊
            task.resume()
//            print(self.allNewsItems[0].title)
//            print("aa")
//            print("aa")
        }
        print("fetching finished.")
        //print(self.allNewsItems)
    }
    
    
    
}
