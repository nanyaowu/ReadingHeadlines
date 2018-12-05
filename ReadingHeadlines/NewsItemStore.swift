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
    
    @discardableResult func createItem() -> NewsItem {
        let newNewsItem = NewsItem(title: "first news", link: "https://www.apple.com")
        allNewsItems.append(newNewsItem)
        
        return newNewsItem
    }
    
    init() {
        createItem()
    }
    
    
}
