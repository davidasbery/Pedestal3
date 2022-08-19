//
//  Menu1View.swift
//  StemPlayer
//
//  Created by David Asbery on 8/6/22.
//

import SwiftUI

struct Menu1View: View {
    
    @Environment(\.dismiss) var dismiss: DismissAction
    @ObservedObject var stemPlayer: StemPlayer
    @Binding var editMode: EditMode
    @State private var updateId: UUID = UUID()

    var body: some View {
        
        ZStack {
            Color.black
                .ignoresSafeArea(.all)
            .opacity(0.80)
            
            VStack (alignment: .trailing){
                
                HStack{
                    Button(editMode == .active ? "Done" : "Edit") {
                        if editMode == .inactive {
                            editMode = .active
                            updateId = UUID()
                        } else {
                            editMode = .inactive
                            updateId = UUID()
                        }
                    }
                    .font(Font.custom("Helvetica Neue Bold", size: 18))
                    .foregroundColor(Color(red: 0.766, green: 0.606, blue: 0.422))
                    .padding(.bottom, 20.0)
                    
                }.padding(.trailing, 17.0)
                    .padding(.top, 60.0)
                
                List {
                    ForEach(stemPlayer.songs) { song in
                        HStack {
                            if shouldShowIsPlayingIcon(for: song) {
                            if stemPlayer.isPlaying == false {
                                GifImage("Decrease").frame(width: 17, height: 17, alignment: .center)
                            }else{
                                GifImage("Jumping").frame(width: 17, height: 17, alignment: .center)
                            }
                            }
                            
                            Text(song.name)
                                .foregroundColor(Color.white)
                            Spacer()
                            
                            
                            Button {
                                stemPlayer.onToggle(song: song )
                                
                            } label: {
                                Image(!stemPlayer.disabledSongs.contains(song) ? "toggleOn" : "toggleOff")
                            }

                        }
                        .tint(.red)
                                .listRowSeparatorTint(.gray)
                                .listRowBackground(
                                    Color.clear)
                        .buttonStyle(.plain)
                        .frame(maxWidth: .infinity)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            stemPlayer.play(song: song)
                            
                        }
                        
                        
                    }
                    .onMove(perform: move)
                        .padding(.leading, self.editMode == .inactive ? 0 : -40)
                    
                }.listStyle(.plain)
                    .environment(\.editMode, $editMode)
                    .id(updateId)
                    .padding(.bottom, 30)
            }
            
        }
        
        
    }
    func shouldShowIsPlayingIcon(for song: Song) -> Bool {
        return stemPlayer.isPlaying && stemPlayer.currentSong == song
    }
    func move(from source: IndexSet, to destination: Int) {
        stemPlayer.songs.move(fromOffsets: source, toOffset: destination)
    }
}

//struct Menu1View_Previews: PreviewProvider {
//    static var previews: some View {
//        Menu1View()
//    }
//}
