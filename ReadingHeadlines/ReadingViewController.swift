//
//  ReadingViewController.swift
//  ReadingHeadlines
//
//  Created by freakytune on 2018/12/10.
//  Copyright © 2018 freakytune. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class ReadingViewController: UIViewController, AVSpeechSynthesizerDelegate {
    
    let synth = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: "")
    
    var newsItemStore: NewsItemStore!
    
    
    @IBAction func startReadingRSS(_ sender: UIButton) {
        
        newsItemStore.fetchXML(withXMLAdress: "https://money.udn.com/rssfeed/news/1001/5591/7307?ch=money")
        
        for item in newsItemStore.allNewsItems {
            myUtterance = AVSpeechUtterance(string: item.title!)
            myUtterance.rate = 0.4
            myUtterance.pitchMultiplier = 1.2
            myUtterance.postUtteranceDelay = 0.1
            myUtterance.volume = 1
            myUtterance.voice = AVSpeechSynthesisVoice(language: "zh-TW")
            synth.speak(myUtterance)
        }
        
    }
    
    
    
    
}
