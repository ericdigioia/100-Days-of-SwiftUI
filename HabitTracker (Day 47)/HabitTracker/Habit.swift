//
//  Habit.swift
//  HabitTracker
//
//  Created by Eric Di Gioia on 5/12/22.
//

import Foundation

struct Habit: Identifiable, Codable {
    var id = UUID()
    var name: String
    var description: String
    var startDate: Date
    var targetFrequency: Int?
    var completionCount: Int
    
}
