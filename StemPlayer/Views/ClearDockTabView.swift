//
//  ClearDockTabView.swift
//  StemPlayer
//
//  Created by David Asbery on 8/3/22.
//

import SwiftUI

struct ClearDockTabView: View {
    var body: some View {
      
        Rectangle()
        .contentShape(Rectangle())
        .foregroundColor(Color.clear)
        
    }
}

struct ClearDockTabView_Previews: PreviewProvider {
    static var previews: some View {
        ClearDockTabView()
    }
}
