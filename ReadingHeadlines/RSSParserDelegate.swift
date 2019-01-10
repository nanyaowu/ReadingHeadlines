//
//  RSSParserDelegate.swift
//  ReadingHeadlines
//
//  Created by freakytune on 2018/12/6.
//  Copyright © 2018 freakytune. All rights reserved.
//

import Foundation

class RSSParserDelegate: NSObject, XMLParserDelegate {
    
    var currentItem: NewsItem?
    var currentElementValue: String?
    var resultArray = [NewsItem]()
    
    
    // 開始parsing的辨識
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "item" {
            // Start a new item
            currentItem = NewsItem()
        } else if elementName == "title" {
            currentElementValue = nil
        } else if elementName == "link" {
            currentElementValue = nil
        } else if elementName == "description" {
            currentElementValue = nil
        }
    }
    
    // parsing 結束賦值
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            if currentItem != nil {
                self.resultArray.append(currentItem!)
                currentItem = nil
            }
        } else if elementName == "title" {
            // 調整title的字串
            let tempTitle = currentElementValue!.replacingOccurrences(of: " ", with: "，", options: .literal, range: nil)
            currentItem?.title = tempTitle.replacingOccurrences(of: "，，", with: "，", options: .literal, range: nil)
            //currentItem?.title = currentElementValue!
            //print(currentItem?.title)
        } else if elementName == "link" {
            currentItem?.link = currentElementValue!
        } else if elementName == "description" {
            currentItem?.description = currentElementValue!
        }
        currentElementValue = nil
    }
    
    // parsing過程
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if currentElementValue == nil {
            currentElementValue = string
        } else {
            currentElementValue = currentElementValue! + string
        }
    }
    
    func getResult() -> [NewsItem] {
        //print(resultArray)
        return resultArray
    }
}
