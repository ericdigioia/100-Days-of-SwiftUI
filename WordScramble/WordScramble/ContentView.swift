//
//  ContentView.swift
//  WordScramble
//
//  Created by Eric Di Gioia on 4/21/22.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    @State private var score = 0 {
        didSet{
            highScore = score > highScore ? score : highScore
        }
    }
    @State private var highScore = 0
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    var body: some View {
        
        VStack{
            NavigationView{
                List{
                    Section{
                        TextField("Enter your word", text: $newWord)
                            .autocapitalization(.none)
                    }
                    Section{
                        ForEach(usedWords, id: \.self){ word in
                            HStack{
                                Image(systemName: "\(word.count).circle.fill")
                                Text(word)
                            }
                            .accessibilityElement(children: .ignore)
                            .accessibilityLabel(word)
                            .accessibilityHint(Text("\(word.count) letters"))
                        }
                    }
                }
                .navigationTitle(rootWord)
                .toolbar{
                    Button("New word"){
                        usedWords.removeAll()
                        score = 0
                        startGame()
                    }
                }
                .onSubmit(addNewWord)
                .onAppear(perform: startGame)
                .alert(errorTitle, isPresented: $showingError){
                    Button("OK", role: .cancel){}
                } message: {
                    Text(errorMessage)
                }
            }
            Group{
                Text("Score: \(score)")
                Spacer()
                Text("Highest score: \(highScore)")
                Spacer()
                Spacer()
                Text("@2022 Eric Di Gioia")
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        
    }
    
    func addNewWord(){
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard answer.count > 0 else {return}
        
        guard isLongEnough(answer) else {
            wordError(title: "Word must be at least 3 characters long", message: "Try harder!")
            return
        }
        
        guard isNotRootWord(answer) else {
            wordError(title: "Nice try", message: "Shame on you")
            return
        }
        
        guard isOriginal(answer) else {
            wordError(title: "Word used already", message: "Be more original!")
            return
        }
        
        guard isPossible(answer) else {
            wordError(title: "Word not possible", message: "You can't spell that word from \(rootWord)")
            return
        }
        
        guard isReal(answer) else {
            wordError(title: "Word not recognized", message: "You cant just make them up, you know!")
            return
        }
        
        withAnimation{
            usedWords.insert(answer, at: 0)
        }
        
        addToScore(answer)
        
        newWord = ""
    }
    
    func startGame(){
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt"){
            // start.txt was found in app bundle
            if let startWords = try? String(contentsOf: startWordsURL){
                // loaded contents into startWords string
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
                return
            }
        }
        
        fatalError("Could not load start.txt from bundle.")
        
    }
    
    func isOriginal(_ word: String) -> Bool{
        !usedWords.contains(word)
    }
    
    func isPossible(_ word: String) -> Bool{
        var tempWord = rootWord
        
        for letter in word{
            if let pos = tempWord.firstIndex(of: letter){
                tempWord.remove(at: pos) // remove found letter
            } else {
                return false
            }
        }
        return true
    }
    
    func isReal(_ word: String) -> Bool{
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    func isLongEnough(_ word: String) -> Bool{
        word.count >= 3
    }
    
    func isNotRootWord(_ word: String) -> Bool{
        word != rootWord
    }
    
    func addToScore(_ word: String){
        score += word.count
    }
    
    func wordError(title: String, message: String){
        errorTitle = title
        errorMessage = message
        showingError = true
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 11")
    }
}


