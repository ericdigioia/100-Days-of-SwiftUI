//
//  ContentView.swift
//  Drawing
//
//  Created by Eric Di Gioia on 5/7/22.
//
// BROKEN: Cannot dynamically change animation durations when using .repeatForever
//

import SwiftUI

struct RotatingArrow: Shape {
    var rotationAmount: CGFloat = 1/3
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX, y: rect.midY*3/4))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY*3/4))
        path.addLine(to: CGPoint(x: rect.maxX*rotationAmount, y: rect.maxY*3/5))
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY*3/4))
        path.addLine(to: CGPoint(x: rect.maxX*(1-rotationAmount), y: rect.maxY*3/5))
        
        return path
    }
}

struct Arrow: Shape {
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX*1/3, y: rect.maxY*3/5))
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX*5/3, y: rect.maxY*3/5))
        
        return path
    }
}

struct ContentView: View {
    @State private var scaleAmount = 0.0
    @State private var scaleSpeed = 0.5
    @State private var xRotationAmount = 0.0
    @State private var xRotationSpeed = 0.5
    @State private var yRotationAmount = 0.0
    @State private var yRotationSpeed = 0.5
    @State private var strokeThickness = 0.5
    
    var body: some View {
        VStack{
            
            Spacer()
            Spacer()
            Spacer()
            
            Arrow()
                .stroke(.red, lineWidth: strokeThickness*5)
                .frame(width: 100, height: 100)
                .rotation3DEffect(.degrees(360*yRotationAmount), axis: (x:0,y:1,z:0))
                .animation(
                    .linear(duration: yRotationSpeed)
                    .repeatForever(autoreverses: false),
                    value: yRotationAmount
                )
                .rotation3DEffect(.degrees(360*xRotationAmount), axis: (x:0,y:0,z:1), anchor: .top)
                .animation(
                    .linear(duration: xRotationSpeed*15)
                    .repeatForever(autoreverses: false),
                    value: xRotationAmount
                )
            
            Group{
                HStack{
                    Text("Line Thickness     ")
                    Slider(value: $strokeThickness)
                }
                    .padding()
                HStack{
                    Text("Scale Speed          ")
                    Slider(value: $scaleSpeed)
                }
                    .padding()
                HStack{
                    Text("X Rotation Speed ")
                    Slider(value: $xRotationSpeed)
                }
                    .padding()
                HStack{
                    Text("Y Rotation Speed ")
                    Slider(value: $yRotationSpeed)
                }
                    .padding()
            }
            
            Spacer()
            
            Arrow()
                .stroke(.red, lineWidth: strokeThickness*5)
                .frame(width: 150, height: 150)
                .scaleEffect(scaleAmount*0.3+0.9)
                .animation(
                    .easeInOut(duration: scaleSpeed*3)
                    .repeatForever(autoreverses: true),
                    value: scaleAmount
                )
                .padding()
            
            Spacer()
            
            Text("@2022 Eric Di Gioia")
            
        }
        .onAppear{
            scaleAmount = 1
            xRotationAmount = 1
            yRotationAmount = 1
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
