//
//  DetailView.swift
//  Day77Challenge
//
//  Created by Eric Di Gioia on 6/12/22.
//

import MapKit
import SwiftUI

struct DetailView: View {
    @State var item: Item
    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 15, longitudeDelta: 15)) // temporary value to be overwritten in the .onAppear modifier closure
    @State private var mapAnnotationItems: [Item] = [] // temporary value to be overwritten in the .onAppear modifier closure
    
    var body: some View {
        VStack {
            item.displayImage
                .resizable()
                .scaledToFit()
                .navigationTitle(item.name)
            
            if item.hasLocationData {
                Map(coordinateRegion: $mapRegion, annotationItems: mapAnnotationItems) { loc in
                    MapMarker(coordinate: loc.coordinates!, tint: .none)
                }
            } else {
                Text("No location data")
            }
            
        }
        .onAppear {
            if item.hasLocationData {
                mapRegion = MKCoordinateRegion(center: item.coordinates!, span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))
                mapAnnotationItems.append(item)
            }
        }
    }
}
