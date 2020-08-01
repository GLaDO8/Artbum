//
//  meshView.swift
//  artbum
//
//  Created by shreyas gupta on 16/07/20.
//  Copyright © 2020 shreyas gupta. All rights reserved.
//

import SwiftUI

struct Wave: Shape{
    var amplitude: Double
    var frequency: Double
    var phase: Double
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath()
        let width = Double(rect.width)
        let height = Double(rect.height)
        let midWeight = width/2
        let midHeight = height/2
        let wavelenth = width/frequency
        
        path.move(to: CGPoint(x: 0, y: midHeight))
        
        for x in stride(from: 0, to: width, by: 10){
            let y = amplitude * sin(x/wavelenth + phase) + midHeight
            path.addLine(to: CGPoint(x: x, y: y))
        }
        return Path(path.cgPath)
    }
}

struct meshView: View {
    @State var phase: Double = 0.0
    var body: some View {
        ZStack{
            Wave(amplitude: 50, frequency: 10, phase: phase)
                .stroke(Color.white, lineWidth: 4)
        }
        .background(Color.blue)
        .edgesIgnoringSafeArea(.all)
        .onAppear{
            withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: false)){
                self.phase = .pi * 2
            }
        }
    }
}

struct meshView_Previews: PreviewProvider {
    static var previews: some View {
        meshView()
    }
}
