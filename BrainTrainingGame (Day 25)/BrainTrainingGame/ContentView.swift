//
//  ContentView.swift
//  BrainTrainingGame
//
//  Created by Eric Di Gioia on 4/19/22.
//

import SwiftUI

struct ContentView: View {
    private let answers = ["✊", "✋", "✌️"]
    @State private var cpuChoice = Int.random(in: 0...2)
    @State private var shouldWin = Bool.random()
    @State private var score = 0
    @State private var roundCounter = 0
    @State private var showingResults = false
    private var correctAnswer: Int {
        switch cpuChoice{
        case 0: return shouldWin ? 1 : 2
        case 1: return shouldWin ? 2 : 0
        case 2: return shouldWin ? 0 : 1
        default: return 3
        }
    }
    
    var body: some View {
        ZStack{
            
            LinearGradient(gradient: Gradient(colors: [.cyan, .black]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack{
                
                Spacer()
                
                VStack(spacing: 60){
                    
                    Text("CPU chooses: \(answers[cpuChoice])")
                        .font(.largeTitle)
                        .foregroundStyle(.primary)
                    
                    Group{
                        Text("Goal: ")
                            .font(.largeTitle)
                            .foregroundColor(.primary)
                        + Text(shouldWin ? "Win" : "Lose")
                            .font(.largeTitle)
                            .foregroundColor(shouldWin ? .green : .red)
                    }
                    
                    HStack(spacing: 30){
                        ForEach(0..<3){ num in
                            Button{
                                CheckAnswer(num)
                            } label: {
                                Text(answers[num])
                                    .font(.largeTitle)
                            }
                        }
                    }
                    
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding()
                
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title)
                
                Spacer()
                
                Text("@2022 Eric Di Gioia")
                    .foregroundColor(.white)
                
            }
            
        }
        .alert("Game Over!", isPresented: $showingResults){
            Button("Restart"){NewGame()}
        } message: {
            Text("Your score was \(score)/10")
        }
    }
    
    func CheckAnswer(_ num: Int){
        score += num == correctAnswer ? 1 : -1
        roundCounter += 1
        if roundCounter < 9 {
            NewRound()
        } else {
            showingResults = true
        }
    }
    
    func NewRound(){
        cpuChoice = Int.random(in: 0...2)
        shouldWin = Bool.random()
    }
    
    func NewGame(){
        score = 0
        roundCounter = 0
        NewRound()
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
