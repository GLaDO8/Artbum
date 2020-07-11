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
    @State var playlistTitleInput: String = ""
    @State var playlistSubtitleInput: String = ""
    @State var currentActiveStyleTypeMenuItem = 0
    @State var appleMusicBrandingToggleValue = true
    static var roundedFont: Font = Font.custom("Roboto Rounded Regular.ttf", size: 12.0)
    
    let textAlignment: [HorizontalAlignment] = [.leading, .center, .trailing]
    let alignmentImageArray: [String] = ["text.alignleft", "text.aligncenter", "text.alignright"]
    
    var body: some View {
        GeometryReader{ viewGeometry in
            VStack{
                AlbumArtPreview(selectedStyle: self.selectedGradient, textAlignment: self.textAlignment[self.segmentedControlChoice], title: "Rap Caviar", subtitle: "Mix", isAMBranding: self.$appleMusicBrandingToggleValue)
                
                TextField("Enter Title", text: self.$playlistTitleInput)
                TextField("Enter SubTitle", text: self.$playlistSubtitleInput).textFieldStyle(RoundedBorderTextFieldStyle())
                
                
                Picker(selection: self.$segmentedControlChoice, label: Text("alignment")){
                    ForEach(0..<self.alignmentImageArray.count){ index in
                        Image(systemName: self.alignmentImageArray[index]).tag(index)
                    }
                }.pickerStyle(SegmentedPickerStyle())
                    .frame(width: viewGeometry.size.width - 100)
               
                appleMusicBrandingToggle(toggleValue: self.$appleMusicBrandingToggleValue)
                
                StyleTypeMenu(selection: self.$currentActiveStyleTypeMenuItem, menuWidth: viewGeometry.size.width)
                
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
    var textAlignment: HorizontalAlignment = .leading
    var title: String
    var subtitle: String
    @Binding var isAMBranding: Bool
    
    var body: some View{
        GeometryReader{ imageGeometry in
            ZStack{
                Image(uiImage: ((self.selectedStyle == nil ? UIImage(named: "Albumplaceholder"): self.selectedStyle)!)) .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: self.albumArtCornerRadius))
                    .frame(width: 240, height: 240)
                    .shadow(color: self.selectedStyle == nil ? Color.gray :  Color((self.selectedStyle?.averageColor)!) , radius: self.albumArtShadowRadius, x: 0, y: 0)
                    .overlay(
                        VStack(alignment: self.textAlignment){
                            PlaylistText(titleText: self.title, textColor: Color.white, fontWeight: .heavy, fontSize: self.albumTitleFontSize, textOpacity: 1.0)
                            PlaylistText(titleText: self.subtitle, textColor: Color.white, fontWeight: .medium, fontSize: self.albumSubtitleFontSize, textOpacity: 0.64)
                                .padding(.top, -5)
                            Spacer()
                            if(self.isAMBranding){
                                Group{
                                    Text("APPLE MUSIC")
                                        .fontWeight(.bold)
                                        .font(.system(size: 10))
                                        .foregroundColor(Color.white)
                                        .padding(16)
                                }
                            }
                        }
                        .frame(width: 240)
                        .padding(.top, 28)
                        .padding(.leading, -8)
                        ,
                        alignment: .topLeading
                )
            }
        }
    }
    
    struct PlaylistText: View{
        let titleText: String
        let textColor: Color
        let fontWeight: Font.Weight
        let fontSize: CGFloat
        let textOpacity: Double
        
        var body: some View{
            Text(titleText)
                .kerning(-0.14)
                .font(.system(size: fontSize))
                .fontWeight(fontWeight)
                .foregroundColor(textColor)
                .opacity(textOpacity)
        }
    }
    
    //MARK: - Album Art Control Knobs
    let albumArtCornerRadius: CGFloat = 16.0
    let albumArtShadowRadius: CGFloat = 12.0
    let albumTitleFontSize: CGFloat = 36.0
    let albumSubtitleFontSize: CGFloat = 34.0
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

struct appleMusicBrandingToggle: View{
    @Binding var toggleValue: Bool
    var body: some View{
        HStack{
            Text("Apple Music Branding")
                .font(Font.custom("Roboto-round-regular", size: 24.0))
                .foregroundColor(Color.black)
            Spacer()
            Image(systemName: toggleValue ? "checkmark.circle.fill" : "checkmark.circle").font(.system(size: 26)).onTapGesture {
                self.toggleValue.toggle()
            }
        }
        .padding(.leading, 30)
        .padding(.trailing, 30)
    }
}

struct StyleTypeMenu: View{
    //remembers the current selection
    @Binding var selection: Int
    var menuWidth: CGFloat
    var menuItemNameArr:[String] = ["Gradients", "Patterns", "Images"]
    var body: some View{
        HStack(alignment: .bottom){
            ForEach(0..<menuItemNameArr.count){ index in
                self.getStyleTypeMenuItem(for: index).onTapGesture{
                      self.onTapSelectionChange(for: index)
                }
                .padding(10)
            }
        }
        .frame(width: menuWidth, alignment: .leading)
        .padding(.leading, 30)
        .padding(.bottom, -15)
    }
    
    func getStyleTypeMenuItem(for index: Int) -> some View{
        let isActive = self.selection == index
        return
            VStack{
                Text(menuItemNameArr[index])
                    .font(Font.custom("Roboto-round-regular", size: isActive ? 24.0 : 22.0))
                    .foregroundColor(isActive ? Color.black : Color.gray)
        }
            
    }
    
    func onTapSelectionChange(for index: Int){
        self.selection = index
    }
    
}

