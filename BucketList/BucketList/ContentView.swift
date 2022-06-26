//
//  ContentView.swift
//  BucketList
//
//  Created by Eric Di Gioia on 6/7/22.
//

import MapKit
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        if viewModel.isUnlocked {
            ZStack {
                Map(coordinateRegion: $viewModel.mapRegion, annotationItems: viewModel.locations) { location in
                    // for each location in locations, have the following map marker or map annotation:
                    MapAnnotation(coordinate: location.coordinate) {
                        // for each annotation, have the following:
                        VStack {
                            Image(systemName: "star.circle")
                                .resizable()
                                .foregroundColor(.red)
                                .frame(width: 44, height: 44) // NOTE: 44x44 is min recommended size for interactive UI elements
                                .background(.white)
                                .clipShape(Circle())
                            
                            Text(location.name)
                                .fixedSize()
                        }
                        .onTapGesture {
                            viewModel.selectedPlace = location
                        }
                    }
                    
                }
                    .ignoresSafeArea()
                
                Circle()
                    .fill(.blue)
                    .opacity(0.3)
                    .frame(width: 32, height: 32)
                
                VStack { // add new location button
                    Spacer()
                    HStack {
                        Spacer()
                        Button { // add new location
                            viewModel.addLocation()
                        } label: {
                            Image(systemName: "plus")
                                .padding()
                                .background(.black.opacity(0.75))
                                .foregroundColor(.white)
                                .font(.title)
                                .clipShape(Circle())
                                .padding(.trailing)
                        }
                    }
                }
            }
            .sheet(item: $viewModel.selectedPlace) { place in // place is an unwrapped version of selectedPlace here
                EditView(location: place) { newLocation in // this closure called when save button is tapped
                    viewModel.updateLocation(location: newLocation)
                }
            }
        } else { // not unlocked
            Button("Unlock Places") {
                viewModel.authenticate()
            }
            .padding()
            .background(.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .alert(viewModel.alertTitle, isPresented: $viewModel.showingAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.alertDescription)
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

 
