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
    
    var isPlaying = false
    var isPausing = false
    
    
    @IBAction func startReadingRSS(_ sender: UIButton) {
        synth.delegate = self
        var itemsString = String()
        
        if isPlaying == false {
            
            isPlaying = true
            playButton.setTitle("Pause", for: .normal)
            
            for item in newsItemStore.allNewsItems {
                itemsString.append(item.title!)
            }
            
            myUtterance = AVSpeechUtterance(string: itemsString)
            myUtterance.rate = 0.5
            myUtterance.pitchMultiplier = 1.2
            myUtterance.postUtteranceDelay = 0.1
            myUtterance.volume = 1
            myUtterance.voice = AVSpeechSynthesisVoice(language: "zh-TW")
            synth.speak(myUtterance)
            
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
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        isPlaying = false
        playButton.setTitle("Play", for: .normal)
    }
    
}
