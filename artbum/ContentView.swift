//
//  ContentView.swift
//  artbum
//
//  Created by shreyas gupta on 09/07/20.
//  Copyright © 2020 shreyas gupta. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var playlistData: AppViewModel
    @State var segmentedControlChoice = 0
    @State var selectedGradient: UIImage?
    let textAlignment: [Alignment] = [.leading, .center, .trailing]
    let alignmentImageArray: [String] = ["text.alignleft", "text.aligncenter", "text.alignright"]
    
    var body: some View {
        GeometryReader{ viewGeometry in
            VStack{
                AlbumArtPreview(selectedStyle: self.selectedGradient, textAlignment: self.textAlignment[self.segmentedControlChoice], title: PlaylistTitle(titleText: "Old Skool Cool", textColor: Color.white, fontStyle: .largeTitle))
                
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
                                self.playlistData.chooseStyle(button: self.playlistData.AlbumStyleArr[index])
                                self.selectedGradient = self.playlistData.AlbumStyleArr[index].styleType
                            }
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let playlist = AppViewModel()
        return ContentView(playlistData: playlist)
    }
}

struct AlbumArtPreview: View{
    var selectedStyle: UIImage?
    var textAlignment: Alignment = .leading
    var title: PlaylistTitle
    
    var body: some View{
        GeometryReader{ imageGeometry in
            ZStack{
                Image(uiImage: ((self.selectedStyle == nil ? UIImage(named: "placeholder"): self.selectedStyle)!)) .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: self.albumArtCornerRadius))
                    .frame(width: 300, height: 300)
                    .shadow(color: self.selectedStyle == nil ? Color.white :  Color((self.selectedStyle?.averageColor)!) , radius: self.albumArtShadowRadius, x: 0, y: 0)
                    .overlay(
                        self.title
                            .frame(width: imageGeometry.size.width - 150, alignment: self.textAlignment),
                        alignment: .topLeading
                )
            }
        }
    }
    
    //MARK: - Album Art Control Knobs
    let albumArtCornerRadius: CGFloat = 16.0
    let albumArtShadowRadius: CGFloat = 12.0
}

struct PlaylistStyleButton: View{
    var style: AppModel.stylePickerButton
    
    var body: some View{
        ZStack{
            Group{
                Circle()
                    .stroke(lineWidth: selectionIndicatorCircleWidth)
                    .foregroundColor(Color.black)
                    .frame(width: 60, height: 60)
            }.opacity(style.isSelected ? 1 : 0)
            Image(uiImage: style.styleType!)
                .resizable()
                .clipShape(Circle())
                .frame(width: 50, height: 50)
        }
    }
    
    //MARK: - Playlist Button Control Knobs
    let selectionIndicatorCircleWidth: CGFloat = 3.0
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
