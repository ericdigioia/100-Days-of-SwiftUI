//
//  ContentView.swift
//  Flashzilla
//
//  Created by Eric Di Gioia on 6/17/22.
//

import SwiftUI

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = Double(total - position)
        return self.offset(x: 0, y: offset * 10)
    }
}

struct ContentView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled
    
    @State private var cards = [Card]() // init to empty array of cards
    
    @State private var timeRemaining = 100 // 100 sec
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect() // timer object that fires every 1 sec, .autoconnect(): makes timer start immediately
    
    @Environment(\.scenePhase) var scenePhase // will tell us if app is inactive or backgrounded
    @State private var isActive = true
    
    @State private var showingEditScreen = false
    
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                Text("Time: \(timeRemaining)")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .background(.black.opacity(0.7))
                    .clipShape(Capsule())
                
                ZStack {
                    ForEach(cards, id: \.id) { card in
                        CardView(card: card) { isCorrect in
                            withOptionalAnimation {
                                if isCorrect { // remove if correct
                                    removeCard(at: cards.firstIndex { $0.id == card.id }!)
                                } else { // put on bottom of deck if wrong (BROKEN)
                                    removeCard(at: cards.firstIndex { $0.id == card.id }!)
                                }
                            }
                        }
                        .stacked(at: cards.firstIndex { $0.id == card.id }!, in: cards.count)
                        .allowsHitTesting(cards.firstIndex { $0.id == card.id } == cards.count - 1) // can swipe top card only
                        .accessibilityHidden(cards.firstIndex { $0.id == card.id } != cards.count - 1) // bottom cards hidden from VO
                    }
                }
                .allowsHitTesting(timeRemaining > 0) // can only interact with this view when condition TRUE
                
                if cards.isEmpty {
                    Button("Start again", action: resetCards)
                        .padding()
                        .background(.white)
                        .foregroundColor(.black)
                        .clipShape(Capsule())
                }
            }
            
            VStack {
                HStack {
                    Spacer()
                    
                    Button {
                        showingEditScreen = true
                    } label: {
                        Image(systemName: "plus.circle")
                            .padding()
                            .background(.black.opacity(0.7))
                            .clipShape(Circle())
                    }
                }
                Spacer()
            }
            .foregroundColor(.white)
            .font(.largeTitle)
            .padding()
            
            if differentiateWithoutColor || voiceOverEnabled {
                VStack {
                    Spacer()
                    
                    HStack {
                        Button {
                            removeCard(at: cards.count - 1)
                        } label: {
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibilityLabel("Wrong")
                        .accessibilityHint("Mark your answer as being incorrect")
                        
                        Spacer()
                        
                        Button {
                            removeCard(at: cards.count - 1)
                        } label: {
                            Image(systemName: "checkmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibilityLabel("Correct")
                        .accessibilityHint("Mark your answer as being correct")
                        
                    }
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding()
                }
            }
        }
        .onReceive(timer) { time in // on every timer fire (1 sec), decrement timeRemaining
            guard isActive else { return } // return if not active
            if timeRemaining > 0 {
                timeRemaining -= 1
            }
        }
        .onChange(of: scenePhase) { newPhase in // update our isActive bool
            if newPhase == .active {
                if !cards.isEmpty {
                    isActive = true
                }
            } else {
                isActive = false
            }
        }
        .sheet(isPresented: $showingEditScreen, onDismiss: resetCards, content: EditView.init)
        .onAppear(perform: resetCards)
    }
    
    func removeCard(at index: Int) {
        guard index >= 0 else { return } // dont try and remove card when there are no cards
        
        cards.remove(at: index)
        
        if cards.isEmpty {
            isActive = false
        }
    }
    
    func moveCardToBottom(at index: Int) {
        guard index >= 0 else { return } // dont try and remove card when there are no cards
        
        let card = cards.remove(at: index)
        cards.insert(card, at: index)
    }
    
    func loadData() {
        if let data = try? Data(contentsOf: FileManager.documentsDirectory.appendingPathComponent("Cards")) {
            if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
                cards = decoded
            }
        }
    }
    
    func resetCards() {
        loadData()
        timeRemaining = 100
        isActive = true
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
