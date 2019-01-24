//
//  newsTalker.swift
//  ReadingHeadlines
//
//  Created by freakytune on 2019/1/24.
//  Copyright © 2019 freakytune. All rights reserved.
//

import UIKit
import AVFoundation

class NewsTalker: NSObject, AVSpeechSynthesizerDelegate {
    
    var isPlaying = false
    var isPausing = false
    var feedsCounter = 0
    var feedsTotal = 0
    var playButton: UIButton?
    
    let synth = AVSpeechSynthesizer()

    
    var myUtterance = AVSpeechUtterance(string: "")


    
    //var playButton: UIButton?
    
    func playButtonPressed(newsItemStore: NewsItemStore, synth: AVSpeechSynthesizer) {
        
        guard playButton != nil else {
            print("playButton not initialized")
            return
        }
        
        synth.delegate = self
        
        if isPlaying == false {
            
            isPlaying = true
            playButton!.setTitle("Pause", for: .normal)
            
            for newsItem in newsItemStore.allNewsItems {
                for item in newsItem {
                    feedsTotal += 1
                }
            }
            
            print(feedsTotal)
            
            
            for newsItem in newsItemStore.allNewsItems {
                for item in newsItem {
                    
                    let readingString = newsItemStore.readingString(newsItem: item)
                    myUtterance = AVSpeechUtterance(string: readingString)
                    myUtterance.rate = 1
                    myUtterance.pitchMultiplier = 1.2
                    myUtterance.postUtteranceDelay = 0.4
                    myUtterance.volume = 1
                    
                    myUtterance.voice = AVSpeechSynthesisVoice(language: "zh-TW")
                    synth.speak(myUtterance)
                    
                }
            }
            
            
        } else {
            if isPausing == false {
                isPausing = true
                synth.pauseSpeaking(at: .immediate)
                playButton!.setTitle("Continue", for: .normal)
            } else {
                isPausing = false
                synth.continueSpeaking()
                playButton!.setTitle("Pause", for: .normal)
            }
        }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        
        guard playButton != nil else {
            print("playButton not initialized")
            return
        }
        
        feedsCounter += 1
        if feedsCounter == feedsTotal {
            isPlaying = false
            playButton!.setTitle("Play", for: .normal)
            feedsCounter = 0
            feedsTotal = 0
        }
        
    }
    
}

