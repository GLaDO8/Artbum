//
//  ContentView.swift
//  artbum
//
//  Created by shreyas gupta on 09/07/20.
//  Copyright © 2020 shreyas gupta. All rights reserved.
//

import SwiftUI

struct EditView: View {
    @EnvironmentObject var playlistData: AppViewModel
    @State var segmentedControlChoice = 0
    @State var playlistTitleInput: String = "Rap Caviar"
    @State var playlistSubtitleInput: String = "Mix"
    @State var appleMusicBrandingToggleValue = true
    @State var currentSelectedPlaylistItem = 0
    @State var presentResult: Int? = 0
    
    let textAlignment: [Alignment] = [.leading, .center, .trailing]
    let alignmentImageArray: [String] = ["text.alignleft", "text.aligncenter", "text.alignright"]
    
    var body: some View {
        NavigationView {
            GeometryReader{ viewGeometry in
                VStack{
                    AlbumArtPreview(
                        selectedStyle: self.playlistData.getSelectedStyleIndex() != nil ?
                            self.playlistData.AlbumStyleArr[self.playlistData.getSelectedStyleIndex()!].styleType : nil,
                        textAlignment: self.textAlignment[self.segmentedControlChoice],
                        title: "Rap Caviar", subtitle: "Mix",
                        titleData: self.$playlistData.titlePos,
                        subtitleData: self.$playlistData.subtitlePos,
                        amData: self.$playlistData.amBrandingPos,
                        isAMBranding: self.$appleMusicBrandingToggleValue)
                    
                    TextField("Enter Title", text: self.$playlistTitleInput)
                    TextField("Enter SubTitle", text: self.$playlistSubtitleInput).textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Picker(selection: self.$segmentedControlChoice, label: Text("alignment")){
                        ForEach(0..<self.alignmentImageArray.count){ index in
                            Image(systemName: self.alignmentImageArray[index]).tag(index)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                        .frame(width: viewGeometry.size.width - 100)
                    
                    appleMusicBrandingToggle(toggleValue: self.$appleMusicBrandingToggleValue)
                        .padding(.leading, 20)
                        .frame(width: viewGeometry.size.width)
                    
                    StyleTypeMenu(selection: self.$currentSelectedPlaylistItem)
                    
                    NavigationLink(destination: ResultView(resultImage: self.playlistData.getResultingImage()), tag: 1, selection: self.$presentResult){
                        EmptyView()
                    }
                    Button(action: {
                        self.playlistData.GenerateAlbumArt(title: self.playlistTitleInput, subtitle: self.playlistSubtitleInput, isBranding: self.appleMusicBrandingToggleValue)
                        self.presentResult = 1
                    }){
                        Text("Done").font(.system(size: 15, weight: .medium, design: .rounded))
                    }.buttonStyle(taskFinishButtonStyle())
                }
            }
        }
        .navigationBarTitle("Make")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let playlist = AppViewModel()
        return EditView().environmentObject(playlist)
    }
}

struct taskFinishButtonStyle: ButtonStyle{
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(Color.white)
            .padding(10)
            .padding(.leading, 10)
            .padding(.trailing, 10)
            .background(Color.black)
            .cornerRadius(24)
    }
}

struct AlbumArtPreview: View{
    var selectedStyle: UIImage?
    var textAlignment: Alignment = .leading
    var title: String
    var subtitle: String
    @Binding var titleData: CGRect?
    @Binding var subtitleData: CGRect?
    @Binding var amData: CGRect?
    @Binding var isAMBranding: Bool
    
    var body: some View{
        ZStack{
            Image(uiImage: ((self.selectedStyle == nil ? UIImage(named: "Albumplaceholder"): self.selectedStyle)!))
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: self.albumArtCornerRadius))
                .frame(width: self.albumPreviewSize, height: self.albumPreviewSize)
                .shadow(color: self.selectedStyle == nil ? Color.gray :  Color((self.selectedStyle?.averageColor)!) , radius: self.albumArtShadowRadius, x: 0, y: 0)
                .overlay(
                    ZStack{
                        VStack{
                            VStack(alignment: .leading){
                                Group{
                                    PlaylistText(titleText: self.title, textColor: Color.white, fontWeight: .heavy, fontSize: self.albumTitleFontSize, textOpacity: 1.0)
                                        .background( GeometryReader { textGeometry -> Color in
                                            self.titleData = textGeometry.frame(in:.named("imageSpace"))
                                            return Color.clear
                                        })
                                        .padding(.top, 28)
                                    PlaylistText(titleText: self.subtitle, textColor: Color.white, fontWeight: .medium, fontSize: self.albumSubtitleFontSize, textOpacity: 0.64)
                                        .background( GeometryReader { textGeometry -> Color in
                                            self.subtitleData = textGeometry.frame(in:.named("imageSpace"))
                                            return Color.clear
                                        })
                                        .padding(.top, -5)
                                }
                                .padding(.leading, 20)
                            }
                        }
                        .frame(width: self.albumPreviewSize, height: self.albumPreviewSize, alignment: .topLeading)
                        if(self.isAMBranding){
                            PlaylistText(titleText: "APPLE MUSIC", textColor: Color.white, fontWeight: .bold, fontSize: 10, textOpacity: 1.0)
                                .background( GeometryReader { textGeometry -> Color in
                                    self.amData = textGeometry.frame(in:.named("imageSpace"))
                                    return Color.clear
                                })
                                .padding(16)
                                .frame(width: self.albumPreviewSize, height: self.albumPreviewSize, alignment: .bottomTrailing)
                        }
                    }
                    .coordinateSpace(name: "imageSpace")
            )
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
    let albumPreviewSize: CGFloat = 240
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
                .font(Font.system(size: 22.0, weight: .semibold, design: .rounded))
                .fontWeight(.medium)
                .foregroundColor(Color.black)
            Spacer()
            Image(systemName: toggleValue ? "checkmark.circle.fill" : "checkmark.circle").font(.system(size: 26)).onTapGesture {
                self.toggleValue.toggle()
            }
        }
        .padding(.trailing, 20)
    }
}

struct StyleTypeMenu: View{
    //remembers the current selection
    @Binding var selection: Int
    @EnvironmentObject var playlistData: AppViewModel
    var menuItemNameArr:[String] = ["Gradients", "Patterns", "Images"]
    
    @ViewBuilder
    var body: some View{
        VStack{
            HStack{
                Group{
                    ForEach(0..<menuItemNameArr.count){ index in
                        self.getStyleTypeMenuItem(for: index).onTapGesture{
                            withAnimation(.easeInOut(duration: 0.2)){
                                self.onTapSelectionChange(for: index)
                            }
                        }
                    }
                }
                .padding(.trailing, 24)
            }
            
            if(selection == 0){
                ScrollView(.horizontal, showsIndicators: false){
                    HStack{
                        ForEach(0..<self.playlistData.AlbumStyleArr.count){ index in
                            PlaylistStyleButton(style: self.playlistData.AlbumStyleArr[index]).onTapGesture{
                                self.playlistData.chooseStyle(button: self.playlistData.AlbumStyleArr[index])
                            }
                        }
                    }
                    .padding(.top, 5)
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
                    .animatableFontModifier(size: 22.0)
                    .foregroundColor(isActive ? Color.black : Color.gray)
        }
    }
    
    func onTapSelectionChange(for index: Int){
        self.selection = index
    }
}

