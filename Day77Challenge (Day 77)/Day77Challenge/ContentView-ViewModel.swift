//
//  ContentView-ViewModel.swift
//  Day77Challenge
//
//  Created by Eric Di Gioia on 6/12/22.
//

import CoreLocation
import Foundation
import UIKit

extension ContentView {
    @MainActor class ViewModel: ObservableObject {
        @Published var items: [Item]
        
        @Published var showingImagePicker = false
        @Published var showingEditView = false
        
        let locationFetcher = LocationFetcher() // to get user location to attach to image
        
        private let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedItems") // have a set save path for the locations array
        
        init() {
            do { // try to retrieve saved items from documents path
                let itemsData = try Data(contentsOf: savePath)
                items = try JSONDecoder().decode([Item].self, from: itemsData)
            } catch { // cannot retrieve items, start fresh
                items = []
            }
        }
        
        private func save() {
            do { // try to write items to documents path
                let itemsData = try JSONEncoder().encode(items)
                try itemsData.write(to: savePath, options: [.atomic, .completeFileProtection])
            } catch { // error: could not write items
                print("Error: could not save items")
            }
        }
        
        func addItem(image: UIImage?, name: String, coordinates: CLLocationCoordinate2D? = nil) {
            // adds new item to array, images compressed at 80% quality
            // NOTE: location data is completely optional, including its parameter
            if let image = image {
                let newItem = Item(id: UUID(), image: image.jpegData(compressionQuality: 0.8)!, name: name, loc_lat: coordinates?.latitude, loc_long: coordinates?.longitude)
                items.append(newItem)
                items = items.sorted() // alphabetically sort array whenever a new item is added
                save()
                print(coordinates == nil ? "Added item \(name) without location" : "Added item \(name) with location")
            } else {
                print("Error: attempted to create new item with invalid image")
            }
        }
        
        func deleteItems(at offsets: IndexSet) {
            items.remove(atOffsets: offsets)
            save()
        }
        
    }
}
