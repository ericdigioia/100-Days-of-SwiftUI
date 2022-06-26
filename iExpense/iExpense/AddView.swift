//
//  AddView.swift
//  iExpense
//
//  Created by Eric Di Gioia on 4/29/22.
//

import SwiftUI

struct AddView: View {
    @ObservedObject var expenses: Expenses // Expenses object to be passed into this view like a function
    @Environment(\.dismiss) var dismiss // This acts as a function to set showingAddExpenses to false to dismiss view
    
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = 0.0
    
    let types = ["Business","Personal"]
    
    var body: some View {
        NavigationView{
            Form{
                TextField("Name", text: $name)
                
                Picker("Type", selection: $type){
                    ForEach(types, id: \.self){
                        Text($0)
                    }
                }
                
                TextField("Amount", value: $amount, format: .currency(code: Locale.current.currencyCode ?? "USD"))
                    .keyboardType(.decimalPad)
                
            }
            .navigationTitle("Add new expense")
            .toolbar{
                Button("Save"){
                    // create new ExpenseItem struct and append to expenses array that was passed into this view
                    expenses.items.append(ExpenseItem(name: name, type: type, amount: amount))
                    // dismiss this view, set showingAddExpenses to false
                    dismiss()
                }
            }
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}
