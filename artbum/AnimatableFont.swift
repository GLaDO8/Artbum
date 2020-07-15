//
//  AnimatableFont.swift
//  artbum
//
//  Created by shreyas gupta on 11/07/20.
//  Copyright © 2020 shreyas gupta. All rights reserved.
//

import SwiftUI

struct AnimatableFont: AnimatableModifier {
    var fontSize: CGFloat
    
    var animatableData: CGFloat{
        get{
            self.fontSize
        }
        set{
            self.fontSize = newValue
        }
    }
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: self.fontSize, weight: .semibold, design: .rounded))
    }
}

extension View{
    func animatableFontModifier(size: CGFloat) -> some View{
        return self.modifier(AnimatableFont(fontSize: size))
    }
}
