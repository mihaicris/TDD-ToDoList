//
//  ToDoUITests.swift
//  ToDoUITests
//
//  Created by Mihai Cristescu on 06/04/2017.
//  Copyright © 2017 Mihai Cristescu. All rights reserved.
//

import XCTest

class ToDoUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        super.setUp()

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        app = XCUIApplication()
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func test_Test() {

        app.navigationBars["ToDo.ItemListView"].buttons["Add"].tap()

        let titleTextField = app.textFields["Title"]
        titleTextField.tap()
        titleTextField.typeText("123")

        let dateTextField = app.textFields["Date"]
        dateTextField.tap()
        dateTextField.typeText("02/22/2016")

        let locationTextField = app.textFields["Location"]
        locationTextField.tap()
        locationTextField.typeText("456")

        let addressTextField = app.textFields["Address"]
        addressTextField.tap()
        addressTextField.typeText("789")

        let descriptionTextField = app.textFields["Description"]
        descriptionTextField.tap()
        descriptionTextField.typeText("555")
        app.buttons["Save"].tap()

        XCTAssertTrue(app.tables.staticTexts["123"].exists)
        XCTAssertTrue(app.tables.staticTexts["02/22/2016"].exists)
        XCTAssertTrue(app.tables.staticTexts["456"].exists)

    }
}
