//
//  PadDockTabView.swift
//  StemPlayer
//
//  Created by David Asbery on 8/3/22.
//

import SwiftUI

struct PadDockTabView: View {
    
    @ObservedObject var stemPlayer: StemPlayer
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    var screen = UIScreen.main.bounds

    
    var body: some View {
    
        VStack{
        if stemPlayer.hasPads {
            LazyVGrid(columns: columns) {
                ForEach(stemPlayer.tracks) { track in
                    PadView(stemPlayer: stemPlayer, track: track)
                }
            }.frame(width: screen.width - 20)

        } else {Text("No Pads")}
        
//            SFXButtonView(buttonAction: return, buttonLabel: "SFX1")
            
        }
    }
}

struct PadDockTabView_Previews: PreviewProvider {
    static var previews: some View {
        PadDockTabView(stemPlayer: StemPlayer(songs: [Songs.all[0]]))
    }
}
