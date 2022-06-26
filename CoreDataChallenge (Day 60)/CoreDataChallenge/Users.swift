//
//  Users.swift
//  CoreDataChallenge
//
//  Created by Eric Di Gioia on 5/30/22.
//

import Foundation

class Users: ObservableObject {
    @Published var users = [User]() { // array of users
        didSet { // save changes to user array
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            if let encoded = try? encoder.encode(users) {
                UserDefaults.standard.set(encoded, forKey: "Users")
            }
        }
    }
    
    init() {
        // attempt to retrieve saved users
        if let savedUsers = UserDefaults.standard.data(forKey: "Users"){
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            if let decodedUsers = try? decoder.decode([User].self, from: savedUsers){
                users = decodedUsers
                return
            }
        }
        // if no saved users found in UserDefaults
        users = []
    }
}
