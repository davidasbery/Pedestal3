//
//  PlayerView.swift
//  StemPlayer
//
//  Created by Adam Zarn on 7/9/22.
//

import SwiftUI
import AVFoundation
import AZSlider

struct PlayerView: View {
   
    @State private var hideStatusBar = false
    @State var buttonSwitch = true
    @State var buttonSwitch2 = true
    @State var showSheet = false { didSet {
        blurRadius = showSheet ? 30 : 0
    }}
    @State var showSheet2 = false { didSet {
        blurRadius = showSheet2 ? 30 : 0
    }}
    
    @StateObject var stemPlayer: StemPlayer
    @State var listViewIsPresented: Bool = false
    var screen = UIScreen.main.bounds
    let gradient = Gradient(colors: [.clear, .black])

    @State var dockIndex: Int = 1
    @State var blurRadius: CGFloat = 0
    @State var editMode: EditMode = .inactive


    init() {
        self._stemPlayer = StateObject(wrappedValue: StemPlayer(songs: Songs.all))
    }
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        
        ZStack {
            
            
            Color.black
                .ignoresSafeArea(.all)
           // Backdrop
            Image("GreyBackground")
                .resizable()
            .ignoresSafeArea(.all)
            
            // Artwork view. 
            ArtworkView().blur(radius:blurRadius)
            
            VStack(spacing: 0) {
                Spacer()
                Rectangle()
                    .fill(LinearGradient(gradient: gradient, startPoint: .top, endPoint: .bottom))
                .frame( height: 360, alignment: .bottom)
                Rectangle()
                    .ignoresSafeArea()
                    .frame(height: 200, alignment: .bottom)

            }

            ZStack {
            
                VStack(spacing: 0) {
                    
                    DockView(stemPlayer:stemPlayer, dockIndex: $dockIndex, blurRadius: $blurRadius)
                    
                    Spacer()
 
                        Text(stemPlayer.currentSong.name)
                            .foregroundColor(.white)
                        Spacer()
                        
                        Spacer()
                        slider
                        .padding(.horizontal, 10)
                        .onReceive(stemPlayer.timer) { input in
                            guard stemPlayer.isScrubbing == false else { return }
                            stemPlayer.updateTimes()
                        }
                    Rectangle()
                        .ignoresSafeArea()
                        .frame(height: 50, alignment: .bottom)
                        
                    }
                ZStack{
                    
                if showSheet{
                    Menu1View(stemPlayer:stemPlayer, editMode: $editMode).transition(.move(edge:.bottom))
                }
                    VStack {
                        Spacer()
                        ZStack{
                        Rectangle()
                                .ignoresSafeArea(.all)
                                .foregroundColor(Color.black)
                                .frame(height: 70, alignment: .bottom)
                        playbackControls
                        }
                    }
                }
            }
        }
    }
    
    var slider: some View {
        AZSlider(value: $stemPlayer.currentTime,
                 in: stemPlayer.currentValueRange,
                 minimumValueLabel: {
            Text(stemPlayer.currentTimeString)
                .foregroundColor(.gray)
                .font(.caption)
                .padding(.vertical, 6)
        },
                 maximumValueLabel: {
            Text(stemPlayer.currentTotalTimeString)
                .foregroundColor(.gray)
                .font(.caption)
                .padding(.vertical, 6)

        },
                 didStartDragging: didStartDragging,
                 didStopDragging: didStopDragging,
                 track: {
            Capsule()
                .foregroundColor(Color.gray)
                .frame(maxWidth: .infinity, maxHeight: 4)
                .fixedSize(horizontal: false, vertical: true)
        }, fill: {
            Capsule()
                .foregroundColor(Color.lightGray)
        }, thumb: {
            Circle()
                .fill(Color.white, strokeBorder: Color.white)
        }, thumbSize: CGSize(width: 12, height: 12))
    }
    
    var playbackControls: some View {
        HStack {
           

            Group{
                Spacer()
                Image(stemPlayer.replayButtonMode.image)
                    .onTapGesture {
                        stemPlayer.replayButton(); stemPlayer.replayButtonMode = stemPlayer.replayButtonMode.next
                }
                
                Spacer()
                Image(stemPlayer.shuffleOn ? "Shuffle CC" : "Shuffle C")
                    .onTapGesture {
                        stemPlayer.shuffleOn.toggle()
                }
                
                Spacer()
            }
            
            Group{
           
            Image("backward")
                .onTapGesture {
                stemPlayer.playPreviousSong()
            }
            Spacer()
            Image(stemPlayer.isPlaying ? "Play Pause Combo2" : "Play Pause Combo")
                .onTapGesture {
                stemPlayer.toggle()
            }
            Spacer()
            Image("forward")
                .onTapGesture {
                stemPlayer.playNextSong()
            }
            }
            Group{
                Spacer()
                Image(showSheet ? "Playlist CC" : "Playlist C")
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 1.5)){
                        if showSheet2 == true {
                            
                            self.showSheet2.toggle()
                        
                       self.showSheet.toggle();
                        
                        } else{
                            self.hideStatusBar.toggle()
                            self.showSheet.toggle();
                      
                        }
                        }
                    }
                
                Spacer()
                Image("Info C")
                Spacer()
            }
            
        }
    }
    
    
    func didStartDragging(_ value: Double) {
        stemPlayer.isScrubbing = true
    }
    
    func didStopDragging(_ value: Double) {
        stemPlayer.isScrubbing = false
        stemPlayer.seek(to: value)
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView()
            .previewDevice("iPhone 12")
    }
}
