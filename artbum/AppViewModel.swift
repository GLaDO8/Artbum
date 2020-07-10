//
//  AppViewModel.swift
//  artbum
//
//  Created by shreyas gupta on 09/07/20.
//  Copyright © 2020 shreyas gupta. All rights reserved.
//

import SwiftUI

class AppViewModel: ObservableObject{
    @Published private var appModel: AppModel

    init(){
        appModel = AppViewModel.gradientInit(gradientImagesArr: ["blueblue", "bluegreen", "purple", "copperblue", "purpleblue", "purplepink", "whitered"])
    }
    
    static func gradientInit(gradientImagesArr: [String]) -> AppModel{
        var tempArr = [AppModel.stylePickerButton]()
        for gradientName in gradientImagesArr{
            tempArr.append(AppModel.stylePickerButton(gradientStyleName: gradientName))
        }
        return AppModel(albumStyleArr: tempArr)
    }
    
    var AlbumStyleArr: [AppModel.stylePickerButton]{
        return appModel.albumStyleArr
    }
    
    func chooseStyle(button: AppModel.stylePickerButton){
        appModel.chooseStyleButton(styleButton: button)
    }
}
