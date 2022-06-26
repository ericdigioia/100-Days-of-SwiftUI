//
//  ContentView.swift
//  WeSplit
//
//  Created by Eric Di Gioia on 4/16/22.
//

import SwiftUI

struct ContentView: View {
    let tipPercentages = [0,10,15,20,25]
    
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 0
    @State private var tipPercentage = 15
    private var amountPerPerson: Double {
        return checkAmount * (1 + Double(tipPercentage)/100) / Double(numberOfPeople + 2)
    }
    
    @FocusState private var amountIsFocused: Bool
    
    var body: some View {
        NavigationView{
            Form{
                
                Section{
                    TextField("Amount", value: $checkAmount, format: .currency(code: Locale.current.currencyCode ?? "USD"))
                        .keyboardType(.decimalPad)
                        .focused($amountIsFocused)
                    Picker("Number of People", selection: $numberOfPeople){
                        ForEach(2..<100){
                            Text("\($0) people")
                        }
                    }
                }
                
//                Section{
//                    Picker("Tip Percentage", selection: $tipPercentage){
//                        ForEach(tipPercentages, id: \.self){
//                            Text($0, format: .percent)
//                        }
//                    }
//                    .pickerStyle(.segmented)
//                } header: {
//                    Text("How much tip do you want to leave?")
//                }
                
                Section{
                    Picker("Tip Percentage", selection: $tipPercentage){
                        ForEach(0..<101){
                            Text($0, format: .percent)
                        }
                    }
                    .pickerStyle(.automatic)
                } header: {
                    Text("How much tip do you want to leave?")
                }
                
                Section{
                    Text(checkAmount * (1 + Double(tipPercentage)/100), format: .currency(code: Locale.current.currencyCode ?? "USD"))
                } header: {
                    Text("Total amount with tip")
                        .foregroundColor(tipPercentage == 0 ? .red : .primary)
                }
                
                Section{
                    Text(amountPerPerson, format: .currency(code: Locale.current.currencyCode ?? "USD"))
                } header: {
                    Text("Amount per person")
                } footer: {
                    Text("@2022 Eric Di Gioia")
                }
                
            }
            .navigationTitle("WeSplit")
            .toolbar{
                ToolbarItemGroup(placement: .keyboard){
                    Spacer()
                    Button("Done"){
                        amountIsFocused = false
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
