//
//  ContentView.swift
//  SnowSeeker
//
//  Created by Eric Di Gioia on 6/23/22.
//

import SwiftUI

extension View {
    @ViewBuilder func phoneOnlyNavigationView() -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone { // if device is a phone
            self.navigationViewStyle(.stack) // use the stack nav style
        } else {
            self
        }
    }
}

struct ContentView: View {
    let resorts: [Resort] = Bundle.main.decode("resorts.json")
    
    @StateObject var favorites = Favorites()
    @State private var searchText = ""
    
    @State private var isShowingSortConfirmationDialog = false
    @State private var sortMethod: SortType = .none
    
    enum SortType {
        case none, name, country
    }
    
    var body: some View {
        NavigationView {
            List(searchFilteredResorts) { resort in
                NavigationLink {
                    ResortView(resort: resort)
                } label: {
                    HStack {
                        Image(resort.country)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 25)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .overlay( // overlay to act as a black border around flag
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(.black, lineWidth: 1)
                            )
                        
                        VStack(alignment: .leading) {
                            Text(resort.name)
                                .font(.headline)
                            Text("\(resort.runs) runs")
                                .foregroundColor(.secondary)
                        }
                        
                        if favorites.contains(resort) {
                            Spacer()
                            Image(systemName: "heart.fill")
                                .accessibilityLabel("This is a favorite resort")
                                .foregroundColor(.red)
                            
                        }
                    }
                }
            }
            .navigationTitle("Resorts")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        isShowingSortConfirmationDialog = true
                    } label: {
                        Label("Sort contacts", systemImage: "arrow.up.arrow.down")
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search for a resort")
            .confirmationDialog("Choose list sort method", isPresented: $isShowingSortConfirmationDialog) {
                Button("none") {
                    sortMethod = .none
                }
                
                Button("name, alphabetical") {
                    sortMethod = .name
                }
                
                Button("country, alphabetical") {
                    sortMethod = .country
                }
            } message: {
                Text("Choose list sort method")
            }
            
            WelcomeView()
        }
        .environmentObject(favorites) // share this object with all views inside the NavigationView
//        .phoneOnlyNavigationView() // use our extension
    }
    
    var orderedResorts: [Resort] { // ordered array of resorts
        switch sortMethod {
        case .none:
            return resorts
        case .name:
            return resorts.sorted {
                $0.name < $1.name
            }
        case .country:
            return resorts.sorted {
                $0.country < $1.country
            }
        }
    }
    
    var searchFilteredResorts: [Resort] { // filtered from search bar
        if searchText.isEmpty {
            return orderedResorts
        } else {
            return orderedResorts.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .previewDevice("iPhone 13 Pro")
            
            ContentView()
                .previewDevice("iPhone 13 Pro Max")
                .previewInterfaceOrientation(.landscapeLeft)
            
            ContentView()
                .previewDevice("iPad Pro (12.9-inch) (5th generation)")
        }
        .preferredColorScheme(.dark)
    }
}
