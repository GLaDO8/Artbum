//
//  PopupBox.swift
//  artbum
//
//  Created by shreyas gupta on 01/08/20.
//  Copyright © 2020 shreyas gupta. All rights reserved.
//

import SwiftUI

struct PopUpBox: View{
    @Binding var titleText: String
    @Binding var subtitleText: String
    @Binding var closePopUpBox: Int
    @Binding var boxType: Int
    
    @ViewBuilder
    var body: some View{
        ZStack{
            if closePopUpBox != -1{
                Group{
                    Rectangle()
                        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                        .opacity(0.3)
                    Group{
                        RoundedRectangle(cornerRadius: 16)
                            .foregroundColor(Color.white)
                            .shadow(radius: 10)
                        VStack{
                            Group{
                                if(boxType == 1){
                                    Text("Title Text")
                                }else{
                                    Text("Subtitle Text")
                                }
                            }
                            .font(.headline)
                            .padding(.top, 20)
                            Spacer()
                            Group{
                                if(boxType == 1){
                                    TextField("Enter Title", text: $titleText)
                                        .padding(.leading, 15)
                                }else{
                                    TextField("Enter Subtitle", text: $subtitleText)
                                        .padding(.leading, 15)
                                }
                            }
                            .foregroundColor(Color.black)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .frame(height: 35)
                                    .foregroundColor(Color.gray)
                                    .opacity(0.2)
                            )
                            .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                            .padding(.leading, 10)
                            .padding(.trailing, 10)
                            Spacer()
                            Button(action: {
                                withAnimation(.linear(duration: 0.15)){
                                    closePopUpBox = -1
                                }
                            }){
                                Text("Done").font(.system(size: 15, weight: .semibold, design: .rounded))
                            }.buttonStyle(taskFinishButtonStyle())
                            .padding(.bottom, 20)
                        }
                    }
                    .frame(width: 250, height: 200, alignment: .center)
                    .padding(.bottom, 50)
                }
                .transition(.opacity)
            }
        }
    }
}
