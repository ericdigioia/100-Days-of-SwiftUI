//
//  Habits.swift
//  HabitTracker
//
//  Created by Eric Di Gioia on 5/12/22.
//

import Foundation

class Habits: ObservableObject {
    @Published var habits = [Habit](){
        didSet{ // save array with new habit
            if let encoded = try? JSONEncoder().encode(habits){
                UserDefaults.standard.set(encoded, forKey: "Habits")
            }
        }
    }
    
    init() { // retrieve saved habit array
        if let savedHabits = UserDefaults.standard.data(forKey: "Habits"){
            if let decodedHabits = try? JSONDecoder().decode([Habit].self, from: savedHabits){
                habits = decodedHabits
                return
            }
        }
        // if saved habits not found, init new one
        habits = []
    }
    
    
    
}
