//
//  EditView-ViewModel.swift
//  BucketList
//
//  Created by Eric Di Gioia on 6/11/22.
//

import Foundation
import SwiftUI

extension EditView {
    @MainActor class ViewModel: ObservableObject {
        enum LoadingState {
            case loading, loaded, failed
        }
        
        var location: Location
        
        @Published var name: String
        @Published var description: String
        
        @Published var loadingState = LoadingState.loading
        @Published var pages = [Page]() // init empty page array
        
        init(location: Location) {
            self.location = location
            self.name = location.name
            self.description = location.description
        }
        
        func fetchNearbyPlaces() async {
            let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.coordinate.latitude)%7C\(location.coordinate.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
            
            guard let url = URL(string: urlString) else {
                print("Bad URL: \(urlString)")
                return
            }
            do {
                let (data, _) = try await URLSession.shared.data(from: url) // we don't care about the metadata returned from this so we ignore it by sending it to _
                let items = try JSONDecoder().decode(Result.self, from: data) // decode the raw data into a Result struct
                pages = items.query.pages.values.sorted() // only keep pages array sorted in alphabetical order
                loadingState = .loaded
            } catch {
                loadingState = .failed
            }
        }
        
    }
}
