//
//  Card.swift
//  Flashzilla
//
//  Created by Eric Di Gioia on 6/18/22.
//

import Foundation

struct Card: Codable {
    let id: UUID
    let prompt: String
    let answer: String
    
    static let example = Card(id: UUID(), prompt: "睡覺", answer: "to sleep")
}
