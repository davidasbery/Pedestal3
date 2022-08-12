//
//  SFXView.swift
//  StemPlayer
//
//  Created by David Asbery on 8/7/22.
//

import SwiftUI

struct SFXButtonView: View {
    
    var buttonAction: () -> Void
    var buttonLabel: String
    
    
    var body: some View {
        
        Button(action: {
            
            buttonAction()
            
            print("clear")
            
        }, label: {
            HStack{
                Spacer()
                
                Text(buttonLabel)
                    .font(.custom("Helvetica Neue Condensed Bold", size: 18))
                Spacer()
            }
        
            .padding(.vertical, 10)
            .foregroundColor(.white)
            .background(.black)
            .border(Color(red: 0.766, green: 0.606, blue: 0.422), width: 3)

            
        })
        
        
    }
}
