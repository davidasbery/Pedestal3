//
//  StemPlayer.swift
//  StemPlayer
//
//  Created by Adam Zarn on 7/9/22.
//

import Foundation
import SwiftUI
import AVFoundation

class StemPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {
    @Published var songs: [Song]
    @Published var tracks: [Track] = []
    @Published var isPlaying: Bool = false
    
    @Published var replayButtonMode: ReplayButtonMode = .off
    @Published var shuffleOn = false
    var buttonIndex = 0
    
    @Published var currentTime: Double = 0 {
        didSet {
            currentTimeString = tracks.referenceAudioPlayer?.currentTime.timeString ?? "-:--"
        }
    }
    @Published var currentTotalTime: Double = 1 {
        didSet {
            currentTotalTimeString = tracks.referenceAudioPlayer?.duration.timeString ?? "-:--"
            currentValueRange = 0...currentTotalTime
        }
    }
    @Published var currentValueRange: ClosedRange<Double> = 0...1
    @Published var currentTimeString: String = "-:--"
    @Published var currentTotalTimeString: String = "-:--"
    @Published var isScrubbing: Bool = false
    let timer: Timer.TimerPublisher

    var index: Int = 0 {
        didSet {
            setupNewSong()
        }
    }
    
    var currentSong: Song {
        return songs[index]
    }
    
    var hasPads: Bool {
        return !tracks.compactMap { $0.padType }.isEmpty
    }
    
    init(songs: [Song]) {
        self.songs = songs
        self.timer = Timer.publish(every: 0.01, on: .main, in: .common)
        super.init()
        setupNewSong()
        updateTimes()
        let _ = self.timer.connect()
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)  //Play music in silent mode
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: []) // Play music in background mode Part I
            try AVAudioSession.sharedInstance().setActive(true) // Play music in background mode Part II
        }
        catch let error {
            print("Error \(error.localizedDescription)")
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        switch replayButtonMode {
        case .off:
            if replayButtonMode == .off && index == songs.count - 1 {
            index = 0
            pauseSongFromStart()
            }else{
                playNextSong()
            }
        case .single:
            playSongFromStart()
            shuffleOn = false
        case .all:
               playNextSong()
        }
    }
    
    func play() {
        tracks.playInSync(currentTime: tracks.referenceAudioPlayer?.currentTime ?? 0)
        isPlaying = true
    }
    
    func play(song: Song) {
        pause()
        guard let songIndex = songs.firstIndex(where: { $0.id == song.id }) else { return }
        self.index = songIndex
        playSongFromStart()
    }
    
    func playNextSong() {
        if isPlaying == false {
            pause()
            if index < songs.count - 1 {
                if shuffleOn == false{ index += 1} else {index = getRandomIndex()}
                pauseSongFromStart()
            } else {
                if shuffleOn == false{ index = 0} else {index = getRandomIndex()}
                pauseSongFromStart()
            }
            
        } else{
                pause()
                if index < songs.count - 1 {
                    if shuffleOn == false{ index += 1} else {index = getRandomIndex()
                    }
                    playSongFromStart()
                } else {
                    if shuffleOn == false{ index = 0} else {index = getRandomIndex()
                    }
                    playSongFromStart()
            }
        }
    }
    
    func playPreviousSong() {
       
        if isPlaying == false {
        if currentTime >= 1.0 {
        pause()
        pauseSongFromStart()
        } else{
        pause()
        if index > 0 {
            index -= 1
        } else {
            index = 0
            //songs.count - 1
          }
                     pauseSongFromStart()
          }
        } else {
        if currentTime >= 1.0 {
        pause()
        playSongFromStart()
        } else{
        pause()
        if index > 0 {
            index -= 1
        } else {
            index = 0
            //songs.count - 1
          }
                     playSongFromStart()
          }
            }
    }
    func playSongFromStart() {
        setupNewSong()
        seek(to: 0)
        play()
    }
    func pauseSongFromStart() {
        pause()
        setupNewSong()
        seek(to: 0)
        
    }
    
    func pause() {
        tracks.pause()
        isPlaying = false
    }
    
    func toggle() {
        isPlaying ? pause() : play()
    }
    
    func mute(padType: PadType?) {
        guard let padType = padType else { return }
        tracks.forEach { track in
            track.isSoloed = false
            guard track.padType == padType else { return }
            track.isMuted.toggle()
        }
        self.tracks = tracks
    }
    
    func solo(padType: PadType?) {
        guard let padType = padType else { return }
        tracks.forEach { track in
            track.isMuted = track.padType != padType
            track.isSoloed = track.padType == padType
        }
        self.tracks = tracks
    }
    
    func setupNewSong() {
        guard index < songs.count else { return }
        self.tracks = songs[index].tracks
        self.tracks.referenceAudioPlayer?.delegate = self
    }
    
    func onToggle(song: Song) {
        guard let songIndex = songs.firstIndex(where: { $0.id == song.id }) else { return }
        songs[songIndex].on.toggle()
        self.songs = songs
    }
    
    func seek(to time: Double) {
//        tracks.pause()
        tracks.referenceAudioPlayer?.currentTime = time
        updateTimes()
        if isPlaying {
            tracks.playInSync(currentTime:time)
        }
    }
    
    // Where does this get used?
    func skip(seconds: Double) {
        let newTime = currentTime + seconds
        seek(to: newTime <= currentTotalTime ? newTime : currentTotalTime)
    }
    
    func updateTimes() {
        guard tracks.referenceAudioPlayer?.duration ?? 0 > 0 else { return }
        currentTime = tracks.referenceAudioPlayer?.currentTime ?? 0
        currentTotalTime = tracks.referenceAudioPlayer?.duration ?? 0
    }
    
    func replayButton() {
        
        if buttonIndex < 2{
            buttonIndex += 1
        } else {
            buttonIndex = 0
        }
        if replayButtonMode != .off{
            shuffleOn = false
        }
    }
    
    enum ReplayButtonMode {
        case off
        case single
        case all
        
        var image: String {
            switch self {
            case .off: return "replay 3"
            case .single: return "replay 1 cc"
            case .all: return "replay 2"
            }
        }
        
        var next: ReplayButtonMode {
            switch self {
            case .off: return .all
            case .all: return .single
            case .single: return .off
            }
        }
    }
    
    func getRandomIndex() -> Int {
        let currentIndex = index
       
        let onIndices = songs.enumerated().filter { (index, song) in
            return song.on
        }.map { (index, _) in
           return index
        }
        
        let randomIndexOfOnIndicesArray = Int.random(in: 0...onIndices.count-1)
        let randomIndex = onIndices[randomIndexOfOnIndicesArray]
        if randomIndex == currentIndex && onIndices.count > 1{
            return getRandomIndex()
        } else {
            return randomIndex
        }
    }
    
    
}
