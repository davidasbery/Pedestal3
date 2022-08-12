//
//  DockView.swift
//  StemPlayer
//
//  Created by David Asbery on 8/3/22.
//

import SwiftUI

struct DockView: View {
    
    var screen = UIScreen.main.bounds
    @ObservedObject var stemPlayer:StemPlayer

    @Binding var dockIndex: Int
    @Binding var blurRadius: CGFloat
    
    var body: some View {
        
        VStack{
                    TabView(selection: $dockIndex) {
                        
                        PadDockTabView(stemPlayer:stemPlayer).tabItem{
                            
                        }.tag(0).padding(.bottom, 20)
                    
                        ClearDockTabView().tabItem{
                            
                        }.tag(1)
                        
                        ClearDockTabView().tabItem{
                            
                        }.tag(2)
                        
                    }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .always)).onChange(of: dockIndex) { newIndex in
                        withAnimation(.easeInOut(duration: 1.0)){
                            if newIndex == 1 { blurRadius = 0
                            } else {blurRadius = 30 }
                }
            }
        }
    }
}
    

struct DockView_Previews: PreviewProvider {
    static var previews: some View {
        DockView(stemPlayer: StemPlayer(songs: []), dockIndex: .constant(1), blurRadius: .constant(0))
        
        
        

    }
}
       
