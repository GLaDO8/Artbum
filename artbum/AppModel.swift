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
    
    func getSelectedStyleIndex() -> Int?{
        return oneAndOnlySelectedStyleButton
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
        let titleTextFont = UIFont.systemFont(ofSize: CGFloat(36 * style.imageSize), weight: .heavy)
        let subtitleTextFont = UIFont.systemFont(ofSize: CGFloat(34 * style.imageSize), weight: .medium)
        let brandingTextFont = UIFont.systemFont(ofSize: CGFloat(10 * style.imageSize), weight: .bold)
        
        UIGraphicsBeginImageContextWithOptions(image.size, false, 0.0)
        
        let titleTextFontAttributes = [
            NSAttributedString.Key.font: titleTextFont,
            NSAttributedString.Key.foregroundColor: textColor,
            ] as [NSAttributedString.Key : Any]
        
        let subtitleTextFontAttributes = [
            NSAttributedString.Key.font: subtitleTextFont,
            NSAttributedString.Key.foregroundColor: textColor,
            ] as [NSAttributedString.Key : Any]
        
        
        
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        
        title.draw(
            in: CGRect(
                origin: CGPoint(
                    x: titleLoc.origin.x * style.imageSize,
                    y: titleLoc.origin.y * style.imageSize),
                size: image.size),
            withAttributes: titleTextFontAttributes
        )
        
        subtitle.draw(
            in: CGRect(
                origin: CGPoint(
                    x: subtitleLoc.origin.x * style.imageSize,
                    y: subtitleLoc.origin.y * style.imageSize),
                size: image.size),
            withAttributes: subtitleTextFontAttributes
        )
        
        if (isbranding){
            let brandingTextFontAttributes = [
                NSAttributedString.Key.font: brandingTextFont,
                NSAttributedString.Key.foregroundColor: textColor,
                ] as [NSAttributedString.Key : Any]
            
            "APPLE MUSIC".draw(
                in: CGRect(
                    origin: CGPoint(
                        x: brandingLoc.origin.x * style.imageSize,
                        y: brandingLoc.origin.y * style.imageSize),
                    size: image.size),
                withAttributes: brandingTextFontAttributes
            )
        }
        
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
