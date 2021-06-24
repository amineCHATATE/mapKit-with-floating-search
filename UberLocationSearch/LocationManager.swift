//
//  LocationManager.swift
//  UberLocationSearch
//
//  Created by Amine CHATATE on 23/06/2021.
//

import Foundation
import CoreLocation

struct Location {
    let title: String
    let coordinates: CLLocationCoordinate2D?
}

class LocationManager: NSObject {
    
    static let shared = LocationManager()
    
    let cLocationManager = CLLocationManager()
    
    public func findLocation(with query: String, completion: @escaping(([Location ]) -> Void)){
        let geoCoder = CLGeocoder()
        
        geoCoder.geocodeAddressString(query) { places, error in
            guard let places = places, error == nil else {
                completion([])
                return
            }
            
            let models: [Location] = places.compactMap ({ placeMark in
                var name = ""
                if let locationName = placeMark.name {
                    name += locationName
                }
                
                if let adminRegion = placeMark.administrativeArea {
                    name += ", \(adminRegion)"
                }
                
                if let locality = placeMark.locality {
                    name += ", \(locality)"
                }
                
                if let country = placeMark.country {
                    name += ", \(country)"
                }
                
                print("\n\n \(placeMark) \n\n")

                let result = Location(title: name, coordinates: placeMark.location?.coordinate)
                return result
            })
            completion(models)
        }
    }
    
}
