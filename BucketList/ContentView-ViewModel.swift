//
//  ContentView-ViewModel.swift
//  BucketList
//
//  Created by Eric Di Gioia on 6/10/22.
//
// ContentView's ViewModel to conform to MVVM software architecture (separating draw code and logic)

import Foundation
import LocalAuthentication
import MapKit

extension ContentView {
    // Paul Hudson says: every time you have a class that conforms to ObservableObject, add @MainActor ("just do it")
    @MainActor class ViewModel: ObservableObject {
        @Published var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25))
        
        @Published private(set) var locations: [Location] // empty array, private(set) basically mean read-only for anything outside this class
        @Published var selectedPlace: Location?
        
        @Published var isUnlocked = false
        @Published var showingAlert = false
        @Published var alertTitle = ""
        @Published var alertDescription = ""
        
        let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedPlaces") // have a set save path for the locations array
        
        init() {
            do {
                let data = try Data(contentsOf: savePath) // try to load data stored in the locations savePath
                locations = try JSONDecoder().decode([Location].self, from: data) // try to decode the stored data into a Location array
            } catch {
                locations = [] // otherwise just init an empty array (no saved locations found)
            }
        }
        
        func save() {
            do {
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savePath, options: [.atomicWrite, .completeFileProtection]) // atomicWrite: write entire file before setting file name, completeFileProtection: encrypt data
            } catch {
                print("Unable to save data")
            }
        }
        
        func addLocation() {
            let newLocation = Location(id: UUID(), name: "New location", description: "", latitude: mapRegion.center.latitude, longitude: mapRegion.center.longitude)
            locations.append(newLocation)
            save()
        }
        
        func updateLocation(location: Location) {
            guard let selectedPlace = selectedPlace else { return } // make sure selectedPlace is not nil

            if let index = locations.firstIndex(of: selectedPlace) { // finds index of this location in the array
                locations[index] = location // overwrites that spot in the array with updated location
                save()
            }
        }
        
        func authenticate() {
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Please authenticate yourself to unlock your places."
                
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                    if success { // must specify this to run on MainActor
                        Task { @MainActor in // new task that should run on the MainActor
                            self.isUnlocked = true // set isUnlocked to be true
                        }
                    } else {
                        Task { @MainActor in
                            self.alertTitle = "Oops!"
                            self.alertDescription = "We could not authenticate you. Please try again."
                            self.showingAlert = true
                        }
                    }
                }
            } else {
                Task { @MainActor in
                    alertTitle = "Oops!"
                    alertDescription = "It looks like biometric authentication is not enabled."
                    showingAlert = true
                }
            }
        }
        
        
    }
}
