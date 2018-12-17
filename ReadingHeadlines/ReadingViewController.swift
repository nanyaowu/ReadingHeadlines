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
    @IBOutlet var playButton: UIButton!
    
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    var newsItemStore: NewsItemStore!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.startAnimating()
        
        newsItemStore.fetchXML(withXMLAdress: "https://money.udn.com/rssfeed/news/1001/5591/7307?ch=money") {
            (parseData) in
            self.newsItemStore.allNewsItems = parseData
            
            self.spinner.stopAnimating()
            self.playButton.isHidden = false
        }
        
    }
    
    @IBAction func startReadingRSS(_ sender: UIButton) {
        
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
