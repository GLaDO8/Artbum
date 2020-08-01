//
//  StyleTypeMenuView.swift
//  artbum
//
//  Created by shreyas gupta on 01/08/20.
//  Copyright © 2020 shreyas gupta. All rights reserved.
//

import SwiftUI

struct StyleTypeMenu: View{
    //remembers the current selection
    @Binding var selection: Int
    @Binding var appleMusicBrandingToggleValue: Bool
    @EnvironmentObject var playlistData: AppViewModel
    var menuItemNameArr:[String] = ["Gradients", "Unsplash", "Patterns", "Images"]
    
    @ViewBuilder
    var body: some View{
        VStack(alignment: .leading){
            appleMusicBrandingToggle(toggleValue: self.$appleMusicBrandingToggleValue)
                .padding(.leading, 25)
                .padding(.trailing, 25)
                .padding(.bottom, 10)
            
            ScrollView(.horizontal, showsIndicators: false){
                HStack{
                    ForEach(0..<menuItemNameArr.count){ index in
                        self.getStyleTypeMenuItem(for: index).onTapGesture{
                            withAnimation(.easeInOut(duration: 0.2)){
                                self.onTapSelectionChange(for: index)
                            }
                        }
                        .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .padding(.leading, 20)
            }
            .frame(alignment: .leading)
            if(selection == 0){
                ScrollView(.horizontal, showsIndicators: false){
                    HStack{
                        ForEach(0..<self.playlistData.AlbumStyleArr.count){ index in
                            PlaylistStyleButton(style: self.playlistData.AlbumStyleArr[index]).onTapGesture{
                                self.playlistData.chooseStyle(button: self.playlistData.AlbumStyleArr[index])
                            }
                        }
                    }
                    .padding(.leading, 20)
                    .padding(.bottom, 20)
                }
            }
        }
    }
    
    func getStyleTypeMenuItem(for index: Int) -> some View{
        let isActive = self.selection == index
        return
            VStack{
                Text(self.menuItemNameArr[index])
                    .font(.system(size: 22.0, weight: .semibold, design: .rounded))
                    .foregroundColor(isActive ? Color.black : Color.gray)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(5)
            }
    }
    
    func onTapSelectionChange(for index: Int){
        self.selection = index
    }
}
