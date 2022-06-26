//
//  Favorites.swift
//  SnowSeeker
//
//  Created by Eric Di Gioia on 6/24/22.
//

import Foundation
import SwiftUI

class Favorites: ObservableObject {
    private var resorts: Set<String>
    private let saveKey = "Favorites"
    
    init() {
        if let data = try? Data(contentsOf: FileManager.documentsDirectory.appendingPathComponent(saveKey)) {
            if let decoded = try? JSONDecoder().decode(Set<String>.self, from: data) {
                resorts = decoded
                return
            }
        }
        // if no save data found
        resorts = []
    }
    
    func contains(_ resort: Resort) -> Bool {
        resorts.contains(resort.id)
    }
    
    func add(_ resort: Resort) {
        objectWillChange.send()
        resorts.insert(resort.id)
        save()
    }
    
    func remove(_ resort: Resort) {
        objectWillChange.send()
        resorts.insert(resort.id)
        save()
    }
    
    private func save() {
        if let data = try? JSONEncoder().encode(resorts) {
            try? data.write(to: FileManager.documentsDirectory.appendingPathComponent(saveKey), options: [.atomicWrite, .completeFileProtection])
        }
    }
}
