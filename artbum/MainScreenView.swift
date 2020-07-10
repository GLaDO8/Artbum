//
//  MainScreenView.swift
//  artbum
//
//  Created by shreyas gupta on 09/07/20.
//  Copyright © 2020 shreyas gupta. All rights reserved.
//

import SwiftUI

struct MainScreenView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: albumArtCornerRadius)
        .frame(width: 200, height: 200)
    }
    
    //MARK: - Control Knobs
    private var albumArtCornerRadius: CGFloat = 16.0
}

struct MainScreenView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreenView()
    }
}
