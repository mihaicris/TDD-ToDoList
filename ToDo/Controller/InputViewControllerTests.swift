//
//  InputViewControllerTests.swift
//  ToDo
//
//  Created by Mihai Cristescu on 02/04/2017.
//  Copyright © 2017 Mihai Cristescu. All rights reserved.
//

@testable import ToDo
import XCTest
import CoreLocation

class InputViewControllerTests: XCTestCase {

    var sut: InputViewController!
    var placemark: MockPlacemark!

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: "InputViewController") as! InputViewController
        _ = sut.view
    }

    override func tearDown() {
        sut.itemManager?.removeAll()
        super.tearDown()
    }

    func test_HasTextFieldAndButtons() {
        XCTAssertNotNil(sut.titleTextField)
        XCTAssertNotNil(sut.dateTextField)
        XCTAssertNotNil(sut.locationTextField)
        XCTAssertNotNil(sut.addressTextField)
        XCTAssertNotNil(sut.descriptionTextField)
        XCTAssertNotNil(sut.saveButton)
        XCTAssertNotNil(sut.cancellButton)
    }

    func test_Save_UsesGeocoderToGetCoordinateFromAddress() {

        let mockSut = MockInputViewController()

        mockSut.titleTextField = UITextField()
        mockSut.dateTextField = UITextField()
        mockSut.locationTextField = UITextField()
        mockSut.addressTextField = UITextField()
        mockSut.descriptionTextField = UITextField()
        mockSut.titleTextField.text = "Test Title"

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"

        let timestamp = 1456092000.0
        let date = Date(timeIntervalSince1970: timestamp)

        mockSut.titleTextField.text = "Foo"
        mockSut.dateTextField.text = dateFormatter.string(from: date)
        mockSut.locationTextField.text = "Bar"
        mockSut.addressTextField.text = "Infinite Loop 1, Cupertino"
        mockSut.descriptionTextField.text = "Baz"

        let mockGeocoder = MockGeocoder()
        mockSut.geocoder = mockGeocoder
        mockSut.itemManager = ItemManager()
        mockSut.itemManager?.removeAll()

        let disimissExpectation = expectation(description: "Dismiss")

        mockSut.completionHandler = {
            disimissExpectation.fulfill()
        }

        mockSut.save()

        placemark = MockPlacemark()
        let coordinate = CLLocationCoordinate2D(latitude: 37.3316851, longitude: -122.0300674)

        placemark.mockCoordinate = coordinate
        mockGeocoder.completionHandler?([placemark], nil)

        waitForExpectations(timeout: 1, handler: nil)

        let item = mockSut.itemManager?.item(at: 0)

        let testItem = ToDoItem(title: "Foo", itemDescription: "Baz", timestamp: timestamp,
                                location: Location(name: "Bar", coordinate: coordinate))

        XCTAssertEqual(item, testItem)
    }

    func test_SaveButtonHasSaveAction() {
        let saveButton: UIButton = sut.saveButton

        guard let actions = saveButton.actions(forTarget: sut, forControlEvent: .touchUpInside) else {
            XCTFail()
            return
        }

        XCTAssertTrue(actions.contains("save"))
    }

    func test_Geodecoder_FetchesCoordinates() {

        let geodecoderAnswered = expectation(description: "Geodecoder")

        CLGeocoder().geocodeAddressString("Infinite Loop 1, Cupertino") {
            (placemarks, _) -> Void in

            let coordinate = placemarks?.first?.location?.coordinate

            guard let latitude = coordinate?.latitude,

                let longitude = coordinate?.longitude else {
                XCTFail()
                return
            }

            XCTAssertEqualWithAccuracy(latitude, 37.3316, accuracy: 0.0001)
            XCTAssertEqualWithAccuracy(longitude, -122.0300, accuracy: 0.001)

            geodecoderAnswered.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }

    func test_Save_DismissesInputViewController() {
        let mockInputViewController = MockInputViewController()

        mockInputViewController.titleTextField = UITextField()
        mockInputViewController.dateTextField = UITextField()
        mockInputViewController.locationTextField = UITextField()
        mockInputViewController.addressTextField = UITextField()
        mockInputViewController.descriptionTextField = UITextField()
        mockInputViewController.titleTextField.text = "Test Title"

        mockInputViewController.save()

        XCTAssertTrue(mockInputViewController.dismissGotCalled)
    }

}

extension InputViewControllerTests {

    class MockGeocoder: CLGeocoder {

        var completionHandler: CLGeocodeCompletionHandler?

        override func geocodeAddressString(_ addressString: String, completionHandler: @escaping CLGeocodeCompletionHandler) {
            self.completionHandler = completionHandler
        }
    }

    class MockPlacemark: CLPlacemark {

        var mockCoordinate: CLLocationCoordinate2D?

        override var location: CLLocation? {
            guard let coordinate = mockCoordinate else {
                return CLLocation()
            }

            return CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        }
    }

    class MockInputViewController: InputViewController {
        var dismissGotCalled = false
        var completionHandler: (() -> Void)?

        override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
            dismissGotCalled = true
            completionHandler?()
        }
    }

}
