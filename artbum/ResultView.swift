//
//  ResultView.swift
//  artbum
//
//  Created by shreyas gupta on 16/07/20.
//  Copyright © 2020 shreyas gupta. All rights reserved.
//

import SwiftUI


struct ResultView: View{
    var resultImage: UIImage?
    
    @ViewBuilder
    var body: some View{
        if(resultImage != nil){
            Image(uiImage: resultImage!)
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: 16.0))
                .frame(width: 300, height: 300)
        }
        else{
            Image(systemName: "timer")
        }
    }
}
