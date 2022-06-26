//
//  HabitDetailedView.swift
//  HabitTracker
//
//  Created by Eric Di Gioia on 5/15/22.
//

import SwiftUI

struct HabitDetailedView: View {
    @ObservedObject var habits: Habits // passed in habits list obj
    @State var habit: Habit // which habit to be displayed in this view
    private var habitArrayIndex: Int { // get index of the habit that is passed into view for direct edit
        for i in 0..<habits.habits.count {
            if (habits.habits[i].id == habit.id) {
                return i
            }
        }
        fatalError("HabitDetailedView: Habit that was pass in was not found inside actual habit array")
    }
        
    var body: some View {
        VStack{
            Form{
                Section{
                    Text("\(habit.startDate.formatted())")
                } header: {
                    Text("Start date")
                }
                Section{
                    Text(habit.description == "" ? "N/A" : habit.description)
                } header: {
                    Text("Description")
                }
                Section{
                    Text(habit.targetFrequency == nil ? "N/A" : (habit.targetFrequency == 1 ? "\(habit.targetFrequency!) time per week" : "\(habit.targetFrequency!) times per week"))
                } header: {
                    Text("Target frequency")
                }
                Section{
                    Stepper("Times completed: \(habits.habits[habitArrayIndex].completionCount)", value: $habits.habits[habitArrayIndex].completionCount, in: 0...Int.max)
                } header: {
                    Text("Completion count")
                }
            }
        }
        .navigationTitle(habit.name)
    }
    
}

struct HabitDetailedView_Previews: PreviewProvider {
    static var previews: some View {
        //HabitDetailedView()
        EmptyView()
    }
}
