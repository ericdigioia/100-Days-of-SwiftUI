//
//  ExpenseItem.swift
//  iExpense
//
//  Created by Eric Di Gioia on 4/29/22.
//

import Foundation

struct ExpenseItem: Identifiable, Codable { // conform: has UUID, easier ForEach loops / conforms: codable for storage
    var id = UUID() // auto generate unique ID, declared as var to make XCode happy when encoding, will not actually be changed
    let name: String
    let type: String
    let amount: Double
}
