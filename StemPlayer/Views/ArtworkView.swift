//
//  ArtworkView.swift
//  StemPlayer
//
//  Created by David Asbery on 7/25/22.
//

import SwiftUI

struct ArtworkView: View {
    
    var screen = UIScreen.main.bounds
    let gradient = Gradient(colors: [.clear, .black])

    
    var body: some View {
        
            
            VStack {
                Image("MainSubject")
                    .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: screen.width - 35)

                Spacer()

            

        }
    }
}

struct ArtworkView_Previews: PreviewProvider {
    static var previews: some View {
        ArtworkView()
            .previewDevice("iPhone 13")
    }
}
