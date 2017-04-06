//
//  ToDoItemTests.swift
//  ToDo
//
//  Created by Mihai Cristescu on 27/03/2017.
//  Copyright © 2017 Mihai Cristescu. All rights reserved.
//

import XCTest
@testable import ToDo

class ToDoItemTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func test_Init_WhenGivenTitle_SetsTitle() {
        let item = ToDoItem(title: "Foo")
        XCTAssertEqual(item.title, "Foo", "should set title")
    }

    func test_Init_WhenGivenGivenDescription_SetsDescription() {
        let item = ToDoItem(title: "", itemDescription: "Bar")
        XCTAssertEqual(item.itemDescription, "Bar", "should set itemDescription")
    }

    func test_Init_WhenGivenGivenTimestamp_SetsTimestamp() {
        let item = ToDoItem(title: "", timestamp: 0.0)
        XCTAssertEqual(item.timestamp, 0.0, "should set timstamp")
    }

    func test_Init_WhenGivenLocation_SetsLocation() {
        let location = Location(name: "Foo")
        let item = ToDoItem(title: "", location: location)
        XCTAssertEqual(item.location?.name, location.name, "should set location")
    }

    func test_EqualItems_AreEqual() {
        let first = ToDoItem(title: "Foo")
        let second = ToDoItem(title: "Foo")
        XCTAssertEqual(first, second)
    }

    func test_Items_WhenLocationDiffers_AreNotEqual() {
        let first = ToDoItem(title: "", location: Location(name: "Foo"))
        let second = ToDoItem(title: "", location: Location(name: "Bar"))
        XCTAssertNotEqual(first, second)
    }

    func test_Items_WhenOneLocationIsNilAndOtherIsnt_AreNotEqual() {
        var first = ToDoItem(title: "Foo", location: Location(name: "Foo"))
        var second = ToDoItem(title: "Foo", location: nil)
        XCTAssertNotEqual(first, second)
        first = ToDoItem(title: "Foo", location: nil)
        second = ToDoItem(title: "Foo", location: Location(name: "Foo"))
        XCTAssertNotEqual(first, second)
    }

    func test_Items_WhenTimeStampDiffer_AreNotEqual() {
        let first = ToDoItem(title: "Foo", timestamp: 1.0)
        let second = ToDoItem(title: "Foo", timestamp: 0.0)
        XCTAssertNotEqual(first, second)
    }

    func test_Items_WhenItemDescriptionDiffer_AreNotEqual() {
        let first = ToDoItem(title: "Foo", itemDescription: "Bar")
        let second = ToDoItem(title: "Foo", itemDescription: "Baz")
        XCTAssertNotEqual(first, second)
    }

    func test_Items_WhenTitleDiffer_AreNotEqual() {
        let first = ToDoItem(title: "Foo")
        let second = ToDoItem(title: "Bar")
        XCTAssertNotEqual(first, second)
    }

    func test_HasPlistDictionaryProperty() {
        let item = ToDoItem(title: "First")
        let dictionary = item.plistDict
        XCTAssertNotNil(dictionary)
    }

    func test_CanBeCreatedFromPlistDictionary() {
        let location = Location(name: "Bar")
        let item = ToDoItem(title: "Foo", itemDescription: "Baz", timestamp: 1.0, location: location)

        let dict = item.plistDict
        let recreatedItem = ToDoItem(dict: dict)
        XCTAssertEqual(item, recreatedItem)
    }
}
