//
//  AppViewModel.swift
//  artbum
//
//  Created by shreyas gupta on 09/07/20.
//  Copyright © 2020 shreyas gupta. All rights reserved.
//

import SwiftUI

class AppViewModel: ObservableObject{
    @Published private(set) var appModel: AppModel
    
    var titlePos: CGRect?
    var subtitlePos: CGRect?
    var amBrandingPos: CGRect?

    init(){
        appModel = AppViewModel.gradientInit(gradientImagesArr: ["blueblue", "bluegreen", "purple", "copperblue", "purpleblue", "purplepink", "whitered"])
    }
    
    static func gradientInit(gradientImagesArr: [String]) -> AppModel{
        var tempArr = [AppModel.stylePickerButton]()
        for gradientName in gradientImagesArr{
            tempArr.append(AppModel.stylePickerButton(gradientStyleName: gradientName))
        }
        tempArr[0].isSelected = true
        return AppModel(albumStyleArr: tempArr)
    }
    
    
    //MARK: - User Intents
    func chooseStyle(button: AppModel.stylePickerButton){
        appModel.chooseStyleButton(styleButton: button)
    }
    
    func GenerateAlbumArt(title: String, subtitle: String, isBranding: Bool){
        self.appModel.ImageGenerator(titleLoc: self.titlePos!, subtitleLoc: self.subtitlePos!, brandingLoc: self.amBrandingPos!, titleString: title, subtitleString: subtitle, isbranding: isBranding)
    }
    
    func getResultingImage() -> UIImage?{
        return appModel.result
    }
    
    //MARK: - Access to model
    var AlbumStyleArr: [AppModel.stylePickerButton]{
        return appModel.albumStyleArr
    }
    
    func getSelectedStyleIndex() -> Int?{
        return appModel.getSelectedStyleIndex()
    }
}
