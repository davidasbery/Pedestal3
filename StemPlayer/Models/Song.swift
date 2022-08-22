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
            
            Song(name: "Pedestal 4",
                tracks: [
                    Track(fileName: "PedestalB", padType: .bass),
                    Track(fileName: "PedestalD", padType: .drum),
                    Track(fileName: "PedestalM", padType: .melody),
                    Track(fileName: "PedestalDL", padType: .loop)

                ]
            ),
            Song(name: "Pedestal 3",
                tracks: [
                    Track(fileName: "PedestalB", padType: .bass),
                    Track(fileName: "PedestalD", padType: .drum),
                    Track(fileName: "PedestalM", padType: .melody)
                ]
            
            )
        ]
    }
}
