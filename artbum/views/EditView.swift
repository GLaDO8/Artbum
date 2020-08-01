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
                VStack{
                    AlbumArtPreview(
                        selectedStyle: self.playlistData.getSelectedStyleIndex() != nil ?
                            self.playlistData.AlbumStyleArr[self.playlistData.getSelectedStyleIndex()!].styleType : nil,
                        textAlignment: self.textAlignment[self.segmentedControlChoice],
                        title: $playlistTitleInput, subtitle: $playlistSubtitleInput,
                        titleData: self.$playlistData.titlePos,
                        subtitleData: self.$playlistData.subtitlePos,
                        amData: self.$playlistData.amBrandingPos,
                        isAMBranding: self.$appleMusicBrandingToggleValue
                    )
                    .padding(.top, -50)
                    HStack{
                        Button(action: {
                            withAnimation(.linear(duration: 0.15)){
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
                            withAnimation(.linear(duration: 0.15)){
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
                    
                    StyleTypeMenu(selection: self.$currentSelectedPlaylistItem, appleMusicBrandingToggleValue: $appleMusicBrandingToggleValue)
                    
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

struct appleMusicBrandingToggle: View{
    @Binding var toggleValue: Bool
    var body: some View{
        HStack{
            Text("Apple Music Branding")
                .font(Font.system(size: 22.0, weight: .semibold, design: .rounded))
                .foregroundColor(Color.black)
            Spacer()
            Image(systemName: toggleValue ? "checkmark.circle.fill" : "checkmark.circle").font(.system(size: 26)).onTapGesture {
                self.toggleValue.toggle()
            }
        }
    }
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
        .padding(.top, 5)
    }
    
    //MARK: - Playlist Button Control Knobs
    let selectionIndicatorCircleWidth: CGFloat = 3.0
}

