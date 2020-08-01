//
//  AlbumArtPreviewView.swift
//  artbum
//
//  Created by shreyas gupta on 01/08/20.
//  Copyright © 2020 shreyas gupta. All rights reserved.
//

import SwiftUI

struct AlbumArtPreview: View{
    var selectedStyle: UIImage?
    var textAlignment: Alignment = .leading
    @Binding var title: String
    @Binding var subtitle: String
    @Binding var titleData: CGRect?
    @Binding var subtitleData: CGRect?
    @Binding var amData: CGRect?
    @Binding var isAMBranding: Bool
    
    @ViewBuilder
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
                            PlaylistText(titleText: "APPLE MUSIC", textColor: Color.white, fontWeight: .semibold, fontDesign: .default, fontSize: 10, textOpacity: 1.0)
                                
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
                .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    //MARK: - Album Art Control Knobs
    let albumArtCornerRadius: CGFloat = 16.0
    let albumArtShadowRadius: CGFloat = 12.0
    let albumTitleFontSize: CGFloat = 36.0
    let albumSubtitleFontSize: CGFloat = 34.0
    let albumPreviewSize: CGFloat = 240
}
