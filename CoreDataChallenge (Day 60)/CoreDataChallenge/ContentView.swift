//
//  ContentView.swift
//  CoreDataChallenge
//
//  Created by Eric Di Gioia on 5/29/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @ObservedObject var users = Users() // create new Users obj

    var body: some View {
        NavigationView {
            List {
                ForEach(users.users, id: \.id) { user in
                    NavigationLink {
                        DetailView(user: user)
                    } label: {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(user.name)
                                    .fontWeight(.bold)
                                Spacer()
                                Text(user.company)
                                    .fontWeight(.thin)
                            }
                            Spacer()
                            Circle()
                                .foregroundColor(user.isActive ? .green : .orange)
                                .frame(width: 7, height: 7)
                                //.offset(y: -6)
                        }
                    }
                }
            }
            .padding(.top)
            .navigationTitle("Data Challenge")
        } .task {
            if users.users.isEmpty {
                await loadJSON()
            } else {
                print("user array already populated!")
            }
        }
    }
    
    func loadJSON() async {
        // set URL from which to load JSON
        guard let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json") else {
            print("Invalid URL")
            return
        }
        
        do {
            // read in JSON into 'data' variable from URL
            print("reading data from https://www.hackingwithswift.com/samples/friendface.json")
            let (data, _) = try await URLSession.shared.data(from: url)
            // decode JSON
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let decodedData = try decoder.decode([User].self, from: data)
            users.users = decodedData
            print("Users now saved!")
        } catch {
            print("Invalid data")
        }
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
