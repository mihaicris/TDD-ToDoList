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
    
    func test_ItemListViewController_HasAddBarButtonWithSelfAsTarget() {
        let target = sut.navigationItem.rightBarButtonItem?.target
        XCTAssertEqual(target as? UIViewController, sut)
    }
    
    func test_AddItem_PresentsAddItemViewController() {
        
        XCTAssertNil(sut.presentedViewController)
        
        guard let addButton = sut.navigationItem.rightBarButtonItem else {
            XCTFail()
            return
        }
        
        guard let action = addButton.action else {
            XCTFail()
            return
        }
        
        UIApplication.shared.keyWindow?.rootViewController = sut
        
        sut.performSelector(onMainThread: action, with: addButton, waitUntilDone: true)
        
        XCTAssertNotNil(sut.presentedViewController)
        XCTAssertTrue(sut.presentedViewController is InputViewController)
        
        let inputViewController = sut.presentedViewController as! InputViewController
        XCTAssertNotNil(inputViewController.titleTextField)
        
    }
    
    func test_ItemListVC_SharesItemManagerWithInputVC() {
        
        guard let addButton = sut.navigationItem.rightBarButtonItem else {
            XCTFail()
            return
        }
        
        guard let action = addButton.action else {
            XCTFail()
            return
        }

        UIApplication.shared.keyWindow?.rootViewController = sut
        sut.performSelector(onMainThread: action, with: addButton, waitUntilDone: true)
      
        guard let inputViewController = sut.presentedViewController as? InputViewController else {
            XCTFail()
            return
        }
        
        guard let inputItemManager = inputViewController.itemManager else {
            XCTFail()
            return
        }
        
        XCTAssertTrue(sut.itemManager === inputItemManager)
    }
    
    func test_Save_DismissesViewController() {
        
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
    
    
    func test_ViewDidLoad_SetsItemManagerToDataProvider() {
        XCTAssertTrue(sut.itemManager === sut.dataProvider.itemManager)
    }
    
    func test_ViewWillAppear_ReloadTheTableView() {
        
        let mockTableView = MockTableView()
        mockTableView.dataSource = sut.dataProvider
        mockTableView.delegate = sut.dataProvider
        
        sut.tableView = mockTableView
        
        sut.beginAppearanceTransition(true, animated: true)
        sut.endAppearanceTransition()
        
        XCTAssertTrue(mockTableView.tableViewHasReloaded)
    }
}

extension ItemListViewControllerTests {
    
    class MockTableView: UITableView {
     
        var tableViewHasReloaded = false

        override func reloadData() {
            tableViewHasReloaded = true
        }
    }
    
    class MockInputViewController: InputViewController {
        
        var dismissGotCalled = false
        
        override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
            dismissGotCalled = true
        }
    }
    
}

