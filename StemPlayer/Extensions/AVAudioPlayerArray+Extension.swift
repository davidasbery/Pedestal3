//
//  AVAudioPlayerArray+Extension.swift
//  StemPlayer
//
//  Created by Adam Zarn on 7/10/22.
//

import Foundation
import AVFoundation

extension Array where Element == AVAudioPlayer {
    func playInSync(currentTime: Double, delay: TimeInterval? = nil) {
        pause()
        guard let first = first else { return }
        if count == 1 {
            first.play()
            return
        }
//        let currentTime = first.currentTime
        let startTime = first.deviceCurrentTime
        forEach { audioPlayer in
            audioPlayer.currentTime = currentTime
            audioPlayer.play(atTime: startTime)
        }
    }
    
    func startTime(delay: TimeInterval? = nil) -> TimeInterval {
        guard let first = first else { return 0 }
        if let delay = delay {
            return first.deviceCurrentTime + delay
        } else {
            return first.deviceCurrentTime + Double(count)*0.0
        }
    }
    
    func pause() {
        forEach { audioPlayer in
            audioPlayer.pause()
        }
    }
}
