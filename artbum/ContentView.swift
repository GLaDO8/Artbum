//
//  ContentView.swift
//  artbum
//
//  Created by shreyas gupta on 09/07/20.
//  Copyright © 2020 shreyas gupta. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var playlistData = AppViewModel()
    
    @State private var segmentedControlChoice = 0
    private var textAlignment: [Alignment] = [.leading, .center, .trailing]
    private var alignmentImageArray: [String] = ["text.alignleft", "text.aligncenter", "text.alignright"]
    
    var body: some View {
        GeometryReader{ viewGeometry in
            VStack{
                GeometryReader{ imageGeometry in
                    ZStack{
                        Image("blueblue").resizable()
                            .clipShape(RoundedRectangle(cornerRadius: self.albumArtCornerRadius))
                            .frame(width: 300, height: 300)
                            .shadow(color: Color((UIImage(named: "blueblue")?.averageColor)!) , radius: self.albumArtShadowRadius, x: 0, y: 0)
                            .overlay(
                                PlaylistTitle(titleText: "Old Skool Cool", textColor: Color.white, fontStyle: .largeTitle)
                                    .frame(width: imageGeometry.size.width - 150, alignment: self.textAlignment[self.segmentedControlChoice]),
                                alignment: .topLeading)
                    }
                }
                
                Picker(selection: self.$segmentedControlChoice, label: Text("alignment")){
                    ForEach(0..<self.alignmentImageArray.count){ index in
                        Image(systemName: self.alignmentImageArray[index]).tag(index)
                    }
                }.pickerStyle(SegmentedPickerStyle())
                    .frame(width: viewGeometry.size.width - 100)
                
                // TODO: Create three way segmented control menu
                ScrollView(.horizontal, showsIndicators: false){
                    HStack{
                        ForEach(0..<self.playlistData.AlbumStyleArr.count){ index in
                            PlaylistStyleButton(style: self.playlistData.AlbumStyleArr[index]).onTapGesture{
                                withAnimation(.linear){
                                    self.playlistData.chooseStyle(button: self.playlistData.AlbumStyleArr[index])
                                }
                            }
                        .padding(3)
                        }
                    }
                .padding()
                }
            }
        }
    }
    
    //MARK: - Control Knobs
    private var albumArtCornerRadius: CGFloat = 16.0
    private var albumArtShadowRadius: CGFloat = 12.0
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct PlaylistStyleButton: View{
    var style: AppModel.stylePickerButton
    
    var body: some View{
        ZStack{
            if(style.isSelected){
                Circle()
                    .stroke(lineWidth: selectionIndicatorCircleWidth)
                    .foregroundColor(Color.black)
                    .frame(width: 60, height: 65)
            }
            Image(uiImage: style.styleType!)
                .resizable()
                .clipShape(Circle())
                .frame(width: 50, height: 50)
        }
    }
    var selectionIndicatorCircleWidth: CGFloat = 4.0
}

struct PlaylistTitle: View{
    let titleText: String
    let textColor: Color
    let fontStyle: Font
    
    var body: some View{
        Text(titleText)
            //            .font(fontStyle)
            .font(.system(size: 40))
            .fontWeight(.bold)
            .foregroundColor(textColor)
            .padding(20)
    }
}
