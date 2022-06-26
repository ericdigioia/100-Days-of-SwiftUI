//
//  EditView.swift
//  Flashzilla
//
//  Created by Eric Di Gioia on 6/19/22.
//

import SwiftUI

struct EditView: View {
    @Environment(\.dismiss) var dismiss
    @State private var cards = [Card]()
    @State private var newPrompt = ""
    @State private var newAnswer = ""
    
    var body: some View {
        NavigationView {
            List {
                Section("Add new card") {
                    TextField("Promp", text: $newPrompt)
                    TextField("Answer", text: $newAnswer)
                    Button("Add card", action: addCard)
                }
                
                Section {
                    ForEach(0..<cards.count, id: \.self) { index in
                        VStack(alignment: .leading) {
                            Text(cards[index].prompt)
                                .font(.headline)
                            
                            Text(cards[index].answer)
                                .foregroundColor(.secondary)
                        }
                    }
                    .onDelete(perform: removeCards)
                }
            }
            .navigationTitle("Edit Cards")
            .toolbar {
                Button("Done", action: done)
            }
            .listStyle(.grouped)
            .onAppear(perform: loadData)
        }
    }
    
    func loadData() {
        if let data = try? Data(contentsOf: FileManager.documentsDirectory.appendingPathComponent("Cards")) {
            if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
                cards = decoded
            }
        }
    }
    
    func saveData() {
        if let data = try? JSONEncoder().encode(cards) {
            try? data.write(to: FileManager.documentsDirectory.appendingPathComponent("Cards"), options: [.atomicWrite, .completeFileProtection])
        }
    }
    
    func addCard() {
        let trimmedPromp = newPrompt.trimmingCharacters(in: .whitespaces)
        let trimmedAnswer = newAnswer.trimmingCharacters(in: .whitespaces)
        guard trimmedPromp.isEmpty == false && trimmedAnswer.isEmpty == false else { return }
        
        let card = Card(id: UUID(), prompt: trimmedPromp, answer: trimmedAnswer)
        cards.insert(card, at: 0)
        saveData()
        
        newPrompt = ""
        newAnswer = ""
    }
    
    func removeCards(at offsets: IndexSet) {
        cards.remove(atOffsets: offsets)
        saveData()
    }
    
    func done() {
        dismiss()
    }
    
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
