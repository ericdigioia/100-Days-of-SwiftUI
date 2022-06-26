//
//  Prospect.swift
//  HotProspects
//
//  Created by Eric Di Gioia on 6/15/22.
//

import SwiftUI

class Prospect: Identifiable, Codable {
    var id = UUID()
    var name = "Anonymous"
    var emailAddress = ""
    fileprivate(set) var isContacted = false // fileprivate(set): value can only be modified from somewhere inside this file (Prospect.swift)
}

// NOTE: always use @MainActor when you make an ObservableObject class
@MainActor class Prospects: ObservableObject {
    @Published private(set) var people: [Prospect]
    private let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedData")
    
    init() {
        if let data = try? Data(contentsOf: savePath) {
            if let decoded = try? JSONDecoder().decode([Prospect].self, from: data) {
                people = decoded
                return
            }
        }
        // no saved data
        people = []
    }
    
    private func save() {
        if let encoded = try? JSONEncoder().encode(people) {
            try? encoded.write(to: savePath, options: [.atomicWrite, .completeFileProtection])
        }
    }
        
    func add(_ prospect: Prospect) {
        people.append(prospect)
        save()
    }
    
    func toggle(_ prospect: Prospect) {
        objectWillChange.send() // announce a change to update UI
        prospect.isContacted.toggle()
        save()
    }
}
