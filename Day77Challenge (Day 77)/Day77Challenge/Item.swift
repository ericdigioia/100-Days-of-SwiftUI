//
//  Item.swift
//  Day77Challenge
//
//  Created by Eric Di Gioia on 6/12/22.
//

import Foundation
import MapKit // for Map and CLLocationCoordinate2D
import SwiftUI // For Image
import UIKit // for UIImage

struct Item: Codable, Comparable, Identifiable {
    var id: UUID
    var image: Data
    var name: String
    var loc_lat: Double?
    var loc_long: Double?
    
    var displayImage: Image { // returns SwiftUI Image type
        Image(uiImage: UIImage(data: image)!)
    }
    
    var coordinates: CLLocationCoordinate2D? { // returns coordinates of image
        if let loc_lat = loc_lat {
            if let loc_long = loc_long {
                return CLLocationCoordinate2D(latitude: loc_lat, longitude: loc_long)
            }
        }
        return nil
    }
    
    var hasLocationData: Bool {
        if coordinates != nil {
            return true
        }
        return false
    }
    
    static func <(lhs: Self, rhs: Self) -> Bool {
        lhs.name < rhs.name
    }
    
}
