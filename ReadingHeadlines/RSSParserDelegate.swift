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
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            if currentItem != nil {
                self.resultArray.append(currentItem!)
                currentItem = nil
            }
        } else if elementName == "title" {
            currentItem?.title = currentElementValue!
            //print(currentItem?.title)
        } else if elementName == "link" {
            currentItem?.link = currentElementValue!
        } else if elementName == "description" {
            currentItem?.description = currentElementValue!
        }
        currentElementValue = nil
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if currentElementValue == nil {
            currentElementValue = string
        } else {
            if string == " " {
                currentElementValue = currentElementValue! + "，"
            } else {
                currentElementValue = currentElementValue! + string
            }
        }
    }
    
    func getResult() -> [NewsItem] {
        //print(resultArray)
        return resultArray
    }
}
