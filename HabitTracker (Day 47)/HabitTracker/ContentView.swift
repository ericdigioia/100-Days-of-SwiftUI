//
//  ContentView.swift
//  HabitTracker
//
//  Created by Eric Di Gioia on 5/12/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var habits = Habits() // new obj
    
    @State private var showingAddHabit = false
    
    var body: some View {
        NavigationView{
            List{
                ForEach(habits.habits){ habit in
                    NavigationLink{
                        // Go to detailed habit view
                        HabitDetailedView(habits: habits, habit: habit)
                    } label: {
                        HStack{
                            VStack{
                                HStack{
                                    Text(habit.name)
                                        .font(.headline)
                                    Spacer()
                                }
                                HStack{
                                    Text(habit.completionCount == 1 ? "Completed \(habit.completionCount) time" : "Completed \(habit.completionCount) times")
                                        .font(.body)
                                        .foregroundColor(.secondary)
                                    Spacer()
                                }
                            }
                            Spacer()
                        }
                    }
                }
                .onDelete(perform: deleteHabit)
            }
            .navigationTitle("Habit Tracker")
            .toolbar{
                Button(){
                    showingAddHabit = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddHabit){
                AddHabitView(habits: habits)
            }
        }
    }
    
    func deleteHabit(at offsets: IndexSet) {
        habits.habits.remove(atOffsets: offsets)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
