//
//  AppModel.swift
//  artbum
//
//  Created by shreyas gupta on 09/07/20.
//  Copyright © 2020 shreyas gupta. All rights reserved.
//

import UIKit

struct AppModel{
    var albumStyleArr: [stylePickerButton]
    var oneAndOnlySelectedStyleButton: Int?{
        get{
            albumStyleArr.indices.filter{albumStyleArr[$0].isSelected}.only
        }
        set{
            for index in albumStyleArr.indices{
                print(index == newValue)
                albumStyleArr[index].isSelected = (index == newValue)
            }
        }
    }
    
    mutating func chooseStyleButton(styleButton: stylePickerButton){
        if let chosenStyleButton = albumStyleArr.indexOfFirstItemFound(of: styleButton){
            oneAndOnlySelectedStyleButton = chosenStyleButton
//            print(chosenStyleButton)
//            print(albumStyleArr[chosenStyleButton].isSelected)
        }
    }

    
    struct stylePickerButton: Identifiable{
        var id = UUID()
        var styleType: UIImage?
        var isSelected: Bool = false
        
        init(gradientStyleName name: String){
            if let image = UIImage(named: name){
                styleType = image
            }
        }
    }
}
