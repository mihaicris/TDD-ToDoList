//
//  ItemViewControllerTests.swift
//  ToDo
//
//  Created by Mihai Cristescu on 28/03/2017.
//  Copyright © 2017 Mihai Cristescu. All rights reserved.
//

import XCTest
@testable import ToDo

class ItemListViewControllerTests: XCTestCase {
    
    var sut: ItemListViewController!
    
    override func setUp() {
        super.setUp()

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ItemListViewController")
        sut = viewController as! ItemListViewController
        _ = sut.view
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_TableViewIsNotNillAfterViewDidLoad() {
        XCTAssertNotNil(sut.tableView)
    }
    
    func test_LoadingView_SetsTableViewDataSource() {
        XCTAssertTrue(sut.tableView.dataSource is ItemListDataProvider)
    }
    
    func test_LoadingView_SetsTableViewDelegate() {
        XCTAssertTrue(sut.tableView.delegate is ItemListDataProvider)
    }
    
    func test_LoadingView_SetsDataSourceAndDelegateToTheSameObject() {
        XCTAssertEqual(sut.tableView.dataSource as! ItemListDataProvider,
                       sut.tableView.delegate as! ItemListDataProvider)
    }
}
