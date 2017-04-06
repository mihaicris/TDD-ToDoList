//
//  LocationTests.swift
//  ToDo
//
//  Created by Mihai Cristescu on 27/03/2017.
//  Copyright © 2017 Mihai Cristescu. All rights reserved.
//

import XCTest
import CoreLocation
@testable import ToDo

class LocationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_WhenGivenName_SetsName() {
        let location = Location(name: "Foo")
        XCTAssertEqual(location.name, "Foo")
    }

    func test_WhenGivenCoordinate_SetsCoordinate() {
        let coordinate = CLLocationCoordinate2D(latitude: 1, longitude: 2)
        let location = Location(name: "", coordinate: coordinate)
        XCTAssertEqual(location.coordinate?.latitude, coordinate.latitude)
        XCTAssertEqual(location.coordinate?.longitude, coordinate.longitude)
    }
    
    func test_EqualItems_AreEqual() {
        let first = Location(name: "Foo")
        let second = Location(name: "Foo")
        XCTAssertEqual(first, second)
    }
    
    func test_Locations_WhenLatitudeDiffers_AreNotEqual() {
        let first = Location(name: "Foo", coordinate: CLLocationCoordinate2D(latitude: 1.0, longitude: 0.0))
        let second = Location(name: "Foo", coordinate: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0))
        XCTAssertNotEqual(first, second)
    }
    
    func test_Locations_WhenLongitudeDiffers_AreNotEqual() {
        let first = Location(name: "Foo", coordinate: CLLocationCoordinate2D(latitude: 0.0, longitude: 1.0))
        let second = Location(name: "Foo", coordinate: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0))
        XCTAssertNotEqual(first, second)
    }
    
    func test_CanBeSerializedAndDeserialized() {
        let location = Location(name: "Home",
                                coordinate: CLLocationCoordinate2D(latitude: 50.0, longitude: 6.0))
        let dict = location.plistDict
        XCTAssertNotNil(dict)
        
        let recreatedLocation = Location(dict: dict)
        XCTAssertEqual(location, recreatedLocation)
    }
    
}
