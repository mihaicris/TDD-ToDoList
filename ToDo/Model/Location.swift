//
//  Location.swift
//  ToDo
//
//  Created by Mihai Cristescu on 27/03/2017.
//  Copyright © 2017 Mihai Cristescu. All rights reserved.
//

import CoreLocation

struct Location: Equatable {
    let name: String
    let coordinate: CLLocationCoordinate2D?
    
    fileprivate let nameKey = "nameKey"
    fileprivate let latitudeKey = "latitudeKey"
    fileprivate let longitudeKey = "longitudeKey"
    
    init(name: String,
         coordinate: CLLocationCoordinate2D? = nil) {
        self.name = name
        self.coordinate = coordinate
    }
    
    var plistDict: [String: Any] {
        var dict: [String: Any] = [:]
        
        dict[nameKey] = name
        
        if let coordinate = coordinate {
            dict[longitudeKey] = coordinate.longitude
            dict[latitudeKey] = coordinate.latitude
        }
        return dict
    }
}

extension Location {
    init?(dict: [String: Any]) {
        
        guard let name = dict[nameKey] as? String else {
            return nil
        }
        
        let coordinate: CLLocationCoordinate2D?
        
        if let latitude = dict[latitudeKey] as? Double, let longitude = dict[longitudeKey] as? Double {
            coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        } else {
            coordinate = nil
        }
        
        self.name = name
        self.coordinate = coordinate
    }
}

func ==(lhs: Location, rhs: Location) -> Bool {
    if lhs.coordinate?.latitude != rhs.coordinate?.latitude ||
       lhs.coordinate?.longitude != rhs.coordinate?.longitude ||
       lhs.name != rhs.name {
        return false
    }
    return true
}
