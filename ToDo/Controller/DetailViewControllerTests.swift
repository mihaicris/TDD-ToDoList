//
//  DetailViewControllerTests.swift
//  ToDo
//
//  Created by Mihai Cristescu on 02/04/2017.
//  Copyright © 2017 Mihai Cristescu. All rights reserved.
//

import XCTest
import CoreLocation

@testable import ToDo

class DetailViewControllerTests: XCTestCase {

    var sut: DetailViewController!

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        _ = sut.view
    }

    override func tearDown() {
        sut.itemInfo?.0.removeAll()
        super.tearDown()
    }

    func test_HasTitleLabel() {
        XCTAssertNotNil(sut.titleLabel)
    }

    func test_HasDueDateLabel() {
        XCTAssertNotNil(sut.dateLabel)
    }

    func test_HasLocationLabel() {
        XCTAssertNotNil(sut.locationLabel)
    }

    func test_HasDescriptionLabel() {
        XCTAssertNotNil(sut.descriptionLabel)
    }

    func test_HasMapView() {
        XCTAssertNotNil(sut.mapView)
    }

    func test_SettingItemInfo_SetsTextsToLabels() {
        let coordinate = CLLocationCoordinate2D(latitude: 51.2277, longitude: 6.7735)

        let location = Location(name: "Foo", coordinate: coordinate)

        let item = ToDoItem(title: "Bar", itemDescription: "Baz", timestamp: 1456150025, location: location)

        let itemManager = ItemManager()
        itemManager.removeAll()

        itemManager.add(item)

        sut.itemInfo = (itemManager, 0)

        sut.beginAppearanceTransition(true, animated: true)
        sut.endAppearanceTransition()

        XCTAssertEqual(sut.titleLabel.text, "Bar")
        XCTAssertEqual(sut.dateLabel.text, "02/22/2016")
        XCTAssertEqual(sut.descriptionLabel.text, "Baz")
        XCTAssertEqualWithAccuracy(sut.mapView.centerCoordinate.latitude, coordinate.latitude, accuracy: 0.001)
        XCTAssertEqualWithAccuracy(sut.mapView.centerCoordinate.longitude, coordinate.longitude, accuracy: 0.001)
    }

    func test_CheckItem_ChecksItemInItemManager() {
        let itemManager = ItemManager()
        itemManager.removeAll()
        itemManager.add(ToDoItem(title: "Foo"))
        sut.itemInfo = (itemManager, 0)
        sut.checkItem()

        XCTAssertEqual(itemManager.toDoCount, 0)
        XCTAssertEqual(itemManager.doneCount, 1)
    }

}
