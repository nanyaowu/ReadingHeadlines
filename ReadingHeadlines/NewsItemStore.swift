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
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    let serialQueue = DispatchQueue(label: "com.nanyao.serial")
    
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
                        print("Parse succeed.")
                        let parseData = rssParserDelegate.getResult()
                        self.serialQueue.async {
                            completion(parseData)
                        }
                        
                    } else {
                        print("Parse fail")
                    }
                }
            }
            
            task.resume()
        }
        print("fetching finished.")
    }
}
