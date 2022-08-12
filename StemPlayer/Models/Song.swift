//
//  Song.swift
//  StemPlayer
//
//  Created by Adam Zarn on 7/9/22.
//

import Foundation

class Song: Identifiable, Equatable {
    let id: UUID = UUID()
    let name: String
    let artistName: String
    let tracks: [Track]
    var on = true
    
    init(name: String,
         tracks: [Track?],
         artistName:String = "DAMMXIII") {
        self.name = name
        self.artistName = artistName
        self.tracks = tracks.compactMap { $0 }
        
    }
    
    static func == (lhs: Song, rhs: Song) -> Bool {
        return lhs.id == rhs.id
    }
}

struct Songs {
    static var all: [Song] {
        return [
            
            Song(name: "WuTang 1",
                tracks: [
                    Track(fileName: "WuTangM", padType: .melody)
                ]
            ),
            Song(name: "WuTang 2",
                tracks: [
                    Track(fileName: "WuTangB", padType: .bass),
                    Track(fileName: "WuTangM", padType: .melody)
                ]
            ),
            Song(name: "WuTang 3",
                tracks: [
                    Track(fileName: "WuTangB", padType: .bass),
                    Track(fileName: "WuTangD", padType: .drum),
                    Track(fileName: "WuTangM", padType: .melody)
                ]
            ),
            Song(name: "WuTang 4",
                tracks: [
                    Track(fileName: "WuTangB", padType: .bass),
                    Track(fileName: "WuTangD", padType: .drum),
                    Track(fileName: "WuTangM", padType: .melody),
                    Track(fileName: "WuTangDL", padType: .loop)
                ]
            
            )
        ]
    }
}
