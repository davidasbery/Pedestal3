//
//  PadType.swift
//  StemPlayer
//
//  Created by Adam Zarn on 7/9/22.
//

import Foundation

enum PadType {
    case soprano, alto, tenor, bass, melody, vocal, drum, loop
    
    var displayName: String {
        switch self {
        case .soprano: return "Soprano"
        case .alto: return "Alto"
        case .tenor: return "Tenor"
        case .bass: return "Bass"
        case .melody: return "Melody"
        case .vocal: return "Vocal"
        case .drum: return "Drum"
        case .loop: return "Loop"
        }
    }
}
