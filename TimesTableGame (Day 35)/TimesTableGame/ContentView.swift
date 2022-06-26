//
//  ContentView.swift
//  TimesTableGame
//
//  Created by Eric Di Gioia on 4/28/22.
//

import SwiftUI

struct ContentView: View {
    private let numQuestionsOptions = [5,10,20]
    
    @State private var UI_state = 0
    @State private var tableSelection = 0
    @State private var numQuestions = 0
    
    @State private var number_x = 0
    @State private var number_y = 0
    private var correctAnswer: Int {
        number_x * number_y
    }
    private var answerOptions: [Int] {
        [Int.random(in: 1...tableSelection),Int.random(in: 1...tableSelection),Int.random(in: 1...tableSelection),correctAnswer].shuffled()
    }
    
    @State private var score = 0
    @State private var roundCounter = 1
    
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    
    @State private var scaleAmount = 1.0
    
    var body: some View {
        NavigationView{
            VStack{
                switch UI_state{
                    
                case 0: // User selects which table to practice
                    Spacer()
                    
                    Text("Please select which multiplication tables you would like to practice:")
                        .font(.headline)
                    
                    Spacer()
                    
                    VStack{
                        ForEach(0..<4){ row in
                            HStack{
                                ForEach(1..<4){ col in
                                    Button{
                                        tableSelection = col+row*4
                                        UI_state = 1
                                        print("Entering state 1...")
                                    } label: {
                                        Text("\(col+row*4-(row))")
                                    }
                                    .padding(30)
                                    .background(.blue)
                                    .foregroundColor(.primary)
                                    .clipShape(Circle())
                                    .scaleEffect(scaleAmount)
                                    .animation(.easeInOut(duration: 0.5), value: scaleAmount)
                                }
                            }
                        }
                    }
                    
                    Spacer()
                    Spacer()
                    
                    Text("@2022 Eric Di Gioia")
                    
                case 1: // User selects number of questions
                    Spacer()
                    
                    Text("Please select the number of practice questions:")
                        .font(.headline)
                    
                    Spacer()
                    
                    HStack{
                        ForEach(numQuestionsOptions, id: \.self){ num in
                            Button{
                                numQuestions = num
                                generateNewQuestion()
                                UI_state = 2
                                print("Entering state 2...")
                            } label: {
                                Text("\(num)")
                            }
                            .padding(30)
                            .background(.blue)
                            .foregroundColor(.primary)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .scaleEffect(scaleAmount)
                            .animation(.easeInOut(duration: 0.5), value: scaleAmount)
                        }
                    }
                    
                    Spacer()
                    Spacer()
                    
                case 2: // User is asked questions / game loop
                    Spacer()
                    
                    Text("\(number_x) * \(number_y) = ?")
                        .font(.headline)
                    
                    Spacer()
                    
                    HStack{
                        ForEach(answerOptions, id: \.self){ num in
                            Button{
                                checkAnswer(num)
                                generateNewQuestion()
                            } label: {
                                Text("\(num)")
                            }
                            .padding(30)
                            .background(.blue)
                            .foregroundColor(.primary)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .scaleEffect(scaleAmount)
                            .animation(.easeInOut(duration: 0.5), value: scaleAmount)
                        }
                    }
                    
                    Spacer()
                    
                    Text("Score: \(score)")
                    Text("Round \(roundCounter)")
                    
                    Spacer()
                    
                default: // STATE ERROR
                    Text("There was a graphical error")
                        .padding()
                }
                
            }
        }
        .alert(alertTitle, isPresented: $showingAlert){
            Button("End Game"){
                roundCounter = 1
                score = 0
                UI_state = 0
                print("Entering state 0...")
            }
            Button("Try Again"){
                roundCounter = 1
                score = 0
                print("Restarting game...")
            }
        } message: {
            Text(alertMessage)
        }
        
    }
    
    func generateNewQuestion(){
        number_x = Int.random(in: 1...tableSelection)
        number_y = Int.random(in: 1...tableSelection)
    }
    
    func checkAnswer(_ ans: Int){
        score += ans == correctAnswer ? 1 : 0 // increment score
        roundCounter += 1 // increment round counter
        if roundCounter > numQuestions { // Game over
            alertTitle = "Game over!"
            alertMessage = "You got \(score)/\(numQuestions) correct!"
            showingAlert = true
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
