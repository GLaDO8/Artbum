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
    @State private var showSheet = false
    
    @ViewBuilder
    var body: some View{
        VStack{
            if(resultImage != nil){
                Image(uiImage: resultImage!)
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 16.0))
                    .frame(width: 300, height: 300)
            }
            else{
                Image(systemName: "timer")
            }
            HStack{
                Button(action: {
                    withAnimation(.linear(duration: 0.15)){

                    }
                }){
                    HStack{
                        Text("Save").font(.system(size: 22, weight: .semibold, design: .rounded))
                        Image(systemName: "square.and.arrow.down")
                            .font(.system(size: 20, weight: .semibold))
                    }
                    
                }.buttonStyle(taskFinishButtonStyle())
                Button(action: {
                    withAnimation(.linear(duration: 0.15)){
                        showSheet = true
                    }
                }){
                    HStack{
                        Text("Share").font(.system(size: 22, weight: .semibold, design: .rounded))
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 20, weight: .semibold))
                    }
                }
                .buttonStyle(taskFinishButtonStyle())
            }
            .padding(.top, 20)
        }
        .sheet(isPresented: $showSheet) {
            ShareSheetView(activityItems: [resultImage, "Album Art"])
        }
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView(resultImage: UIImage(named: "copperblue"))
    }
}
