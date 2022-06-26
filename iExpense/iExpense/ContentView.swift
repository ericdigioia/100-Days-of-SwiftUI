//
//  ContentView.swift
//  iExpense
//
//  Created by Eric Di Gioia on 4/29/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var expenses = Expenses() // create object here
    
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationView{
            List{
//                ForEach(expenses.items){ item in
//                    HStack{
//                        VStack(alignment: .leading){
//                            Text(item.name)
//                                .font(.headline)
//                            Text(item.type)
//                        }
//
//                        Spacer()
//
//                        Text(item.amount, format: .currency(code: Locale.current.currencyCode ?? "USD"))
//                            .foregroundColor(item.amount < 10 ? .green : (item.amount < 100 ? .yellow : .red))
//
//                    }
//                }
//                .onDelete(perform: removeItems)
                
                // Personal List
                Section{
                    ForEach(expenses.items.filter({$0.type == "Personal"})) { item in
                        HStack{
                            VStack(alignment: .leading){
                                Text(item.name)
                                    .font(.headline)
                            }

                            Spacer()

                            Text(item.amount, format: .currency(code: Locale.current.currencyCode ?? "USD"))
                                .foregroundColor(item.amount < 10 ? .green : (item.amount < 100 ? .yellow : .red))

                        }
                    }
                    .onDelete(perform: removeItems)
                } header: {
                    Text("Personal Expenses")
                }
                
                // Business List
                Section{
                    ForEach(expenses.items.filter({$0.type == "Business"})) { item in
                        HStack{
                            VStack(alignment: .leading){
                                Text(item.name)
                                    .font(.headline)
                            }

                            Spacer()

                            Text(item.amount, format: .currency(code: Locale.current.currencyCode ?? "USD"))
                                .foregroundColor(item.amount < 10 ? .green : (item.amount < 100 ? .yellow : .red))

                        }
                    }
                    .onDelete(perform: removeItems)
                } header: {
                    Text("Business Expenses")
                }
                
            }
            .navigationTitle("iExpense")
            .toolbar{
                Button{
                    showingAddExpense = true // bring up AddView
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddExpense){
                AddView(expenses: expenses) // pass our object 'expenses' into AddView for manipulation
            }
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
