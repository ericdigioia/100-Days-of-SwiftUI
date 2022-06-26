//
//  ContentView.swift
//  BetterRest
//
//  Created by Eric Di Gioia on 4/19/22.
//

import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    var body: some View {
        NavigationView{
            Form{
                Section(){
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                } header: {
                    Text("When you do want to wake up?")
                        //.font(.headline)
                }
                
                Section{
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                } header: {
                    Text("Desired amount of sleep")
                        //.font(.headline)
                }
                
                Section{
                    //Stepper(coffeeAmount == 1 ? "1 cup" : "\(coffeeAmount) cups", value: $coffeeAmount, in: 1...20)
                    Picker("Amount of coffee", selection: $coffeeAmount){
                        ForEach(1..<21){
                            Text($0 == 1 ? "1 cup" : "\($0) cups")
                        }
                    }
                } header: {
                    
                        Text("Daily coffee intake")
                            //.font(.headline)
                }
                
                Section{
                    Text(giveCalculatedBedtime().formatted(date: .omitted, time: .shortened))
                } header: {
                    Text("Recommended Bedtime")
                        .font(.headline)
                }
                
            }
            .navigationTitle("BetterRest")
                //.toolbar{
                //    Button("Calculate", action: calculateBedtime)
                //}
            .alert(alertTitle, isPresented: $showingAlert) {
                Button("OK"){}
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    func calculateBedtime() {
        
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60 // in seconds
            let minute = (components.minute ?? 0) * 60 // in seconds
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            alertTitle = "Your ideal bedtime is..."
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry, there was an error calculating your bedtime"
        }
        
        showingAlert = true
        
    }
    
    func giveCalculatedBedtime() -> Date{
        var sleepTime = Date.now
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60 // in seconds
            let minute = (components.minute ?? 0) * 60 // in seconds
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            sleepTime = wakeUp - prediction.actualSleep
        } catch {
            sleepTime = Date.now
        }
        
        return sleepTime
        
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 11")
    }
}
