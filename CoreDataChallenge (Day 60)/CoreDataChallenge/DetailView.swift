//
//  DetailView.swift
//  CoreDataChallenge
//
//  Created by Eric Di Gioia on 5/30/22.
//

import SwiftUI

struct DetailView: View {
    var user: User
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(user.id)
                .fontWeight(.thin)
                .offset(x: 17)
            Form {
                Section {
                    Text(user.isActive ? "Status: online" : "Status: offline")
                    Text("Age: \(user.age)")
                    Text("Company: \(user.company)")
                    Text("email: \(user.email)")
                    Text("Address: \(user.address)")
                } header: {
                    Text("Info")
                }
                Section {
                    Text(user.about)
                } header: {
                    Text("About")
                }
                Section {
                    Text("Member since \(user.registered.formatted(date: .abbreviated, time: .omitted))")
                }
                Section {
                    ForEach(user.tags, id: \.self) { tag in
                        Text(tag)
                    }
                } header: {
                    Text("Tags")
                }
                Section {
                    ForEach(user.friends, id: \.self) { friend in
                        VStack(alignment: .leading) {
                            Text(friend.name)
                                .fontWeight(.bold)
                            Text(friend.id)
                                .font(.footnote)
                                .fontWeight(.thin)
                        }
                    }
                } header: {
                    Text("Friends")
                }
                
            }
            .navigationTitle(user.name)
        }
    }
}
