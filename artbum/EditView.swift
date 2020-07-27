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
    @State var playlistTitleInput: String = "Title"
    @State var playlistSubtitleInput: String = "Subtitle"
    @State var appleMusicBrandingToggleValue = true
    @State var currentSelectedPlaylistItem = 0
    @State var presentResult: Int? = 0
    @State var displayTitleTextBox: Int = -1
    @State var displayBoxType: Int = 0
    
    
    let textAlignment: [Alignment] = [.leading, .center, .trailing]
    let alignmentImageArray: [String] = ["text.alignleft", "text.aligncenter", "text.alignright"]
    
    @ViewBuilder
    var body: some View {
        NavigationView {
            GeometryReader{ viewGeometry in
                ZStack{
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
                        
                        HStack{
                            Button(action: {
                                withAnimation(.linear(duration: 0.2)){
                                    displayTitleTextBox = 1
                                    displayBoxType = 1
                                }
                            }){
                                HStack{
                                    Text("Title").font(.system(size: 22, weight: .semibold, design: .rounded))
                                    Image(systemName: "pencil")
                                }
                                
                            }.buttonStyle(taskFinishButtonStyle())
                            Button(action: {
                                withAnimation(.linear(duration: 0.2)){
                                    displayTitleTextBox = 1
                                    displayBoxType = 2
                                }
                            }){
                                HStack{
                                    Text("Subtitle").font(.system(size: 22, weight: .semibold, design: .rounded))
                                    Image(systemName: "pencil")
                                }
                            }.buttonStyle(taskFinishButtonStyle())
                        }
                        .padding(.top, 10)
                        
//                        Picker(selection: self.$segmentedControlChoice, label: Text("alignment")){
//                            ForEach(0..<self.alignmentImageArray.count){ index in
//                                Image(systemName: self.alignmentImageArray[index]).tag(index)
//                            }
//                        }.pickerStyle(SegmentedPickerStyle())
//                        .frame(width: viewGeometry.size.width - 100)
                        Spacer()
                        appleMusicBrandingToggle(toggleValue: self.$appleMusicBrandingToggleValue)
                            .padding(.leading, 20)
                            .padding(.bottom, 10)
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
                        .padding(.bottom, 20)
                    }
                    PopUpBox(titleText: $playlistTitleInput, subtitleText:$playlistSubtitleInput, closePopUpBox: $displayTitleTextBox, boxType: $displayBoxType)
                    Spacer()
                }
            }
        }
        .navigationBarTitle("Make")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let playlist = AppViewModel()
        return Group {
            EditView().environmentObject(playlist)
                .environment(\.colorScheme, .light)
//            EditView().environmentObject(playlist)
//                .environment(\.colorScheme, .dark)
        }
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

struct PopUpBox: View{
    @Binding var titleText: String
    @Binding var subtitleText: String
    @Binding var closePopUpBox: Int
    @Binding var boxType: Int
    
    var body: some View{
        ZStack{
            if closePopUpBox != -1{
                Group{
                    Rectangle()
                        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                        .opacity(0.3)
                    GeometryReader{ geometry in
                        RoundedRectangle(cornerRadius: 16)
                            .foregroundColor(Color.white)
                            .shadow(radius: 10)
                        VStack{
                            Group{
                                if(boxType == 1){
                                    Text("Title Text")
                                }else{
                                    Text("Subtitle Text")
                                }
                            }
                            .font(.headline)
                                .padding(.top, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                            Group{
                                if(boxType == 1){
                                    TextField("Enter Title", text: $titleText)
                                }else{
                                    TextField("Enter Subtitle", text: $subtitleText)
                                }
                            }
                                .textFieldStyle(DefaultTextFieldStyle())
                                .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                            Spacer()
                            Button(action: {
                                withAnimation(.linear(duration: 0.2)){
                                    closePopUpBox = -1
                                }
                            }){
                                Text("Done").font(.system(size: 15, weight: .medium, design: .rounded))
                            }.buttonStyle(taskFinishButtonStyle())
                            .padding(.bottom, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                        }
                    }
                    .frame(width: 250, height: 200, alignment: .center)
                }
                .transition(.opacity)
            }
        }
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
                            PlaylistText(titleText: "APPLE MUSIC", textColor: Color.white, fontWeight: .semibold, fontDesign: .rounded, fontSize: 10, textOpacity: 1.0)
                                
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
        var fontDesign: Font.Design = .default
        let fontSize: CGFloat
        let textOpacity: Double
        
        init(titleText: String, textColor: Color, fontWeight: Font.Weight, fontDesign: Font.Design = .default, fontSize: CGFloat, textOpacity: Double){
            self.titleText = titleText
            self.textColor = textColor
            self.fontDesign = fontDesign
            self.fontWeight = fontWeight
            self.fontSize = fontSize
            self.textOpacity = textOpacity
        }
        
        var body: some View{
            Text(titleText)
                .kerning(-0.14)
                .font(.system(size: fontSize, weight: fontWeight, design: fontDesign))
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
            }
            .frame(alignment: .leading)
            .padding(.leading, 20)

            
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
                    .font(.system(size: 22.0, weight: .semibold, design: .rounded))
                    .foregroundColor(isActive ? Color.black : Color.gray)
        }
    }
    
    func onTapSelectionChange(for index: Int){
        self.selection = index
    }
}

