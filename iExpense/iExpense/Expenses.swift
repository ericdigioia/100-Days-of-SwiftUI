//
//  Expenses.swift
//  iExpense
//
//  Created by Eric Di Gioia on 4/29/22.
//

import Foundation

class Expenses: ObservableObject {
    @Published var items = [ExpenseItem](){
        didSet{
            if let encoded = try? JSONEncoder().encode(items){
                // if JSONEncoder was able to encode our items array
                UserDefaults.standard.set(encoded, forKey: "Items") // store our array in UserDefaults
            }
        }
    }
    
    init(){
        // try to find data stored under key 'Items' inside UserDefaults
        if let savedItems = UserDefaults.standard.data(forKey: "Items"){
            // try to decode found data as array of ExpenseItem
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems){
                // load decoded array into var 'items'
                items = decodedItems
                return
            }
        }
        // if the above has failed, initialize items as empty array
        items = []
    }
    
    deleteByID(_ ids: [UUID]){
        for id in ids{
            items.remove(items.firstIndex(of: id == id))
        }
    }
    
}

