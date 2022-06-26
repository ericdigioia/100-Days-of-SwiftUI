//
//  Location.swift
//  BucketList
//
//  Created by Eric Di Gioia on 6/9/22.
//

import Foundation
import CoreLocation

struct Location: Identifiable, Codable, Equatable {
    var id: UUID
    var name: String
    var description: String
    let latitude: Double
    let longitude: Double
    
    var coordinate: CLLocationCoordinate2D { // computed property to conform to protocols
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    // example for easy previewing
    static let example = Location(id: UUID(), name: "Buckingham Palace", description: "Where Queen Elizabeth lives with her dorgies", latitude: 51.501, longitude: -0.141)
    
    static func ==(lhs: Location, rhs: Location) -> Bool { // overriding Equatable built-in == func (which compares every struct property)
        lhs.id == rhs.id // this is more efficient as it only compared one value per struct
    }
    
}
