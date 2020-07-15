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
    var result: UIImage?
    
    private var oneAndOnlySelectedStyleButton: Int?{
        get{
            albumStyleArr.indices.filter{albumStyleArr[$0].isSelected}.only
        }
        set{
            for index in albumStyleArr.indices{
                albumStyleArr[index].isSelected = (index == newValue)
            }
        }
    }
    
    
    mutating func chooseStyleButton(styleButton: stylePickerButton){
        if let chosenStyleButton = albumStyleArr.indexOfFirstItemFound(of: styleButton){
            oneAndOnlySelectedStyleButton = chosenStyleButton
        }
    }
    
    mutating func ImageGenerator(titleLoc: CGRect, subtitleLoc: CGRect, brandingLoc: CGRect, titleString title: String, subtitleString subtitle: String, isbranding: Bool){
        let textColor = UIColor.white
        let style = albumStyleArr[oneAndOnlySelectedStyleButton!]
        let image = style.styleType!
        let textFont = UIFont.systemFont(ofSize: CGFloat(36 * style.imageSize), weight: .heavy)
        
        UIGraphicsBeginImageContextWithOptions(image.size, false, 0.0)
        let textFontAttributes = [
            NSAttributedString.Key.font: textFont,
            NSAttributedString.Key.foregroundColor: textColor,
            ] as [NSAttributedString.Key : Any]
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        
        let rect = CGRect(
            origin: CGPoint(
                x: titleLoc.origin.x * style.imageSize,
                y: titleLoc.origin.y * style.imageSize),
            size: image.size)
        
        title.draw(in: rect, withAttributes: textFontAttributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        result = newImage!
    }
    
    struct stylePickerButton: Identifiable{
        var id = UUID()
        var styleType: UIImage?
        var imageSize: CGFloat{
            let y = styleType!.size.height
            let x = styleType!.size.width
            let imageScale = y/x
            return imageScale >= 0 ? x/240 : y/240
        }
        
        var isSelected: Bool = false
        
        init(gradientStyleName name: String){
            if let image = UIImage(named: name){
                styleType = image
            }
        }
    }
}
