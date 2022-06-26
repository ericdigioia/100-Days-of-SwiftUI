//
//  ContentView.swift
//  CoreDataChallenge_v2
//
//  Created by Eric Di Gioia on 6/1/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \CachedUser.name, ascending: true)],
        animation: .default)
    private var users: FetchedResults<CachedUser>

    var body: some View {
        NavigationView {
            List {
                ForEach(users, id: \.id) { user in
                    NavigationLink {
                        DetailView(user: user)
                    } label: {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(user.name!)
                                    .fontWeight(.bold)
                                Spacer()
                                Text(user.company!)
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
            .navigationTitle("Data Challenge v2")
        } .task {
            //if users.isEmpty {
            if true {
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
            // for each user object decoded from JSON
            var newUser: CachedUser
            var newFriend: CachedFriend
            print("Decoded User count: \(decodedData.count)")
            for i in 0..<decodedData.count { // each loop iteration creates one new CachedUser
                print("i = \(i)")
                newUser = CachedUser(context: viewContext)
                newUser.id = decodedData[i].id
                newUser.isActive = decodedData[i].isActive
                newUser.name = decodedData[i].name
                newUser.age = Int16(decodedData[i].age)
                newUser.company = decodedData[i].company
                newUser.email = decodedData[i].email
                newUser.address = decodedData[i].address
                newUser.about = decodedData[i].about
                newUser.registered = decodedData[i].registered
                // convert individual tag strings to single comma-separated tag string
                newUser.tags = decodedData[i].tags.joined(separator: ",")
                // convert Friends to CachedFriends and then add CachedFriends to CachedUser
                print("Decoded User friend count: \(decodedData[i].friends.count)")
                    for j in 0..<decodedData[i].friends.count { // each loop iteration adds one CachedFriend
                        print("j = \(j)")
                        newFriend = CachedFriend(context: viewContext)
                        newFriend.name = decodedData[i].friends[j].name
                        newFriend.id = decodedData[i].friends[j].id
                        newUser.addToFriends(newFriend)
                        try? viewContext.save()
                    }
                try? viewContext.save()
            }
            print("Users now saved!")
        } catch {
            print("Invalid data")
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .preferredColorScheme(.dark)
    }
}
