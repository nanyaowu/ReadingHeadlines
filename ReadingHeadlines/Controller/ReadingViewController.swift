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
        print("Reading View is loaded")
        synth.delegate = self
        
        DispatchQueue.main.async {
            self.spinner.startAnimating()
            print("spinner start animating")
            self.downloadAndRenew()
            print("stop group queue")
        }
        
    }
    
    func downloadAndRenew() {
        let notify = newsItemStore.downloadTask()
        print(notify)
        self.spinner.stopAnimating()
        self.playButton.isHidden = false
        
    }
    
    // MARK: 播放控制
    var isPlaying = false
    var isPausing = false
    
    @IBAction func startReadingRSS(_ sender: UIButton) {
        
        if isPlaying == false {
            
            isPlaying = true
            playButton.setTitle("Pause", for: .normal)
            
            
            let itemsString = newsItemStore.combinString(newsItemStore.allNewsItems)
            
            print(itemsString)
            
            myUtterance.rate = 0.5
            myUtterance.pitchMultiplier = 1.2
            myUtterance.postUtteranceDelay = 0.1
            myUtterance.volume = 1
            
            myUtterance = AVSpeechUtterance(string: itemsString)
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
    
    //播放結束後button調整
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        isPlaying = false
        playButton.setTitle("Play", for: .normal)
    }
    
    
    // MARK: prepare segure
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "tableDetail"?:
            let destinationVC = segue.destination as! FeedsViewController
            destinationVC.newsItemStore = newsItemStore
            
        default:
            preconditionFailure("Unexpected segue identifier")
        }
    }
    
    
}
