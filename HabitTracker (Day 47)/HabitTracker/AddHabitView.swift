//
//  AddHabitView.swift
//  HabitTracker
//
//  Created by Eric Di Gioia on 5/13/22.
//

import SwiftUI

struct AddHabitView: View {
    @ObservedObject var habits: Habits // passed in habits list obj
    
    @Environment(\.dismiss) var dismiss // dismiss this view
    
    @State private var showingAlert = false
    
    @State private var name = ""
    @State private var description = ""
    @State private var startDate = Date()
    @State private var targetFrequency: Int? = nil
    
    var body: some View {
        NavigationView{
            Form{
                Section{
                    TextField("Habit name", text: $name)
                    TextField("Habit description (optional)", text: $description)
                    DatePicker("Start date", selection: $startDate, displayedComponents: .date)
                } header: {
                    Text("Give some basic info about this activity")
                }
                Section{
                    TextField("Times per week (optional)", value: $targetFrequency, format: .number)
                        .keyboardType(.numberPad)
                } header: {
                    Text("Choose how many times per week you wish to complete this activity (optional)")
                }
            }
            .navigationTitle("Add new habit")
            .toolbar {
                Button("Save"){
                    saveHabitThenDismiss()
                }
            }
            .alert("Could not add habit", isPresented: $showingAlert){
                Button("OK"){showingAlert = false}
            } message: {
                Text("Please make sure you have filled out all required sections before proceeding")
            }
        }
    }
    
    func saveHabitThenDismiss() {
        if (name != "") {
            habits.habits.append(Habit(name: name, description: description, startDate: startDate, targetFrequency: targetFrequency, completionCount: 0))
            dismiss()
            return
        } else {
            showingAlert = true
            return
        }
    }
    
}

struct AddHabitView_Previews: PreviewProvider {
    static var previews: some View {
        AddHabitView(habits: Habits())
            .preferredColorScheme(.dark)
    }
}
