//
//  ContentView.swift
//  DiceRoll
//
//  Created by Eric Di Gioia on 6/22/22.
//

import SwiftUI

struct ContentView: View {
    private let dieTypes = [4, 6, 8, 10, 12, 20, 100]
    
    @State private var numberOfDice = 2
    @State private var typeOfDie = 6
    
    @State private var timeRemaining = -0.25
    private let timer = Timer.publish(every: 0.075, on: .main, in: .common).autoconnect()
    
    @State private var rolledNumber = 1
    private var maxRoll: Int {
        typeOfDie * numberOfDice
    }
    
    @State private var isShowingDie = false // do not show die until roll button is pressed
    
    @State private var rollLog = [Int]()
    @State private var isShowingRollLog = false
    @State private var rollSavedFlag = true // set false to queue a log save at the end of the coming roll
    
    @State private var hapticFeedback = UINotificationFeedbackGenerator()
    
    var body: some View {
        NavigationView {
            ZStack {
                Form {
                    Section {
                        Picker("Number of dice", selection: $numberOfDice) {
                            ForEach(1...25, id: \.self) {
                                Text("\($0)")
                            }
                        }
                        
                        Picker("Type of die", selection: $typeOfDie) {
                            ForEach(dieTypes, id: \.self) {
                                Text("\($0)-sided")
                            }
                        }
                    } header: {
                        Text("Configure dice roll")
                    }
                }
                .accessibilitySortPriority(1)
                
                VStack {
                    Spacer()
                    Spacer()
                    
                    Button {
                        isShowingDie = true
                        timeRemaining = 1.00
                        rollSavedFlag = false
                        hapticFeedback.notificationOccurred(.success)
                    } label: {
                        Label("Roll", systemImage: "dice.fill")
                    }
                    .tint(.blue)
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.roundedRectangle(radius: 20))
                    .controlSize(.large)
                    
                    Spacer()
                    
                    if isShowingDie {
                    Text("\(rolledNumber)")
                        .font(.largeTitle)
                        .frame(width: 110, height: 110)
                        .foregroundColor(.black)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(radius: 10)
                        .accessibilityLabel("You rolled a, \(rolledNumber)")
                    } else {
                        Spacer()
                    }
                    
                    Spacer()
                    
                    Button {
                        isShowingRollLog = true
                    } label: {
                        Label("View previous rolls", systemImage: "bookmark.square")
                    }
                    .tint(.purple)
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.roundedRectangle(radius: 20))
                    .controlSize(.small)
                    .padding().padding()
                }
                .accessibilitySortPriority(0)
                
            }
            .navigationTitle("Dice Roll")
            .onAppear(perform: loadData)
            .onReceive(timer) { time in
                if timeRemaining > 0 {
                    timeRemaining -= 0.075 // deduct time
                    rolledNumber = Int.random(in: 1...maxRoll) // cycle through possible rolls
                } else if !rollSavedFlag { // only enters once per roll at the end
                    rollLog.append(rolledNumber) // record the roll
                    UIAccessibility.post(notification: .announcement, argument: "You rolled a, \(rolledNumber)")
                    saveData() // save the updated roll log
                    rollSavedFlag = true
                } else {
                    hapticFeedback.prepare() // always be preparing feedback engine when not roling
                }
            }
            .sheet(isPresented: $isShowingRollLog) {
                RollLogView(rollLog: $rollLog)
            }
        }
    }
    
    func loadData() {
        if let data = try? Data(contentsOf: FileManager.documentsDirectory.appendingPathComponent("RollLog")) {
            if let decoded = try? JSONDecoder().decode([Int].self, from: data) {
                rollLog = decoded
            }
        }
    }
    
    func saveData() {
        if let data = try? JSONEncoder().encode(rollLog) {
            try? data.write(to: FileManager.documentsDirectory.appendingPathComponent("RollLog"), options: [.atomicWrite, .completeFileProtection])
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
