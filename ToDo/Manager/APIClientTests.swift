//
//  APIClientTests.swift
//  ToDo
//
//  Created by Mihai Cristescu on 02/04/2017.
//  Copyright © 2017 Mihai Cristescu. All rights reserved.
//

@testable import ToDo
import XCTest

class APIClientTests: XCTestCase {

    let sut = APIClient()

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func test_Login_UsesExpectedURL() {

        let mockURLSession = MockURLSession(data: nil, urlResponse: nil, error: nil)

        sut.session = mockURLSession

        let completion = { (token: Token?, error: Error?) in }
        sut.loginUser(withName: "dasdom", password: "1234", completion: completion)

        guard let url = mockURLSession.url else {
            XCTFail()
            return
        }

        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)

        XCTAssertEqual(urlComponents?.host, "awesometodos.com")
        XCTAssertEqual(urlComponents?.path, "/login")
        XCTAssertEqual(urlComponents?.query, "username=dasdom&password=1234")
    }

    func test_Login_WhenSuccessful_CreatesToken() {

        let jsonData = "{\"token\": \"1234567890\" }".data(using: .utf8)
        let mockURLSession = MockURLSession(data: jsonData, urlResponse: nil, error: nil)
        sut.session = mockURLSession

        let tokenExpectation = expectation(description: "Token")

        var catchedToken: Token? = nil

        sut.loginUser(withName: "Foo", password: "bar") {
            (token, _) -> Void in
            catchedToken = token
            tokenExpectation.fulfill()
        }

        waitForExpectations(timeout: 1) { (_) in
            XCTAssertEqual(catchedToken?.id, "1234567890")
        }
    }

    func test_Login_WhenJSONIsInvalid_ReturnsError() {

        let mockURLSession = MockURLSession(data: Data(), urlResponse: nil, error: nil)

        sut.session = mockURLSession

        let errorExpectation = expectation(description: "Error")

        var catchedError: Error? = nil

        sut.loginUser(withName: "Foo", password: "Bar") {
            (_, error) -> Void in

            catchedError = error

            errorExpectation.fulfill()
        }

        waitForExpectations(timeout: 1) { (_) in
            XCTAssertNotNil(catchedError)
        }
    }

    func test_Login_WhenDataIsNil_ReturnsError() {

        let mockURLSession = MockURLSession(data: nil, urlResponse: nil, error: nil)

        sut.session = mockURLSession

        let errorExpectation = expectation(description: "Error")

        var catchedError: Error? = nil

        sut.loginUser(withName: "Foo", password: "Bar") {
            (_, error) -> Void in

            catchedError = error

            errorExpectation.fulfill()
        }

        waitForExpectations(timeout: 1) { (_) in
            XCTAssertNotNil(catchedError)
        }
    }

    func test_Login_WhenResponseHasError_ReturnsError() {

        let error = NSError(domain: "SomeError", code: 1234, userInfo: nil)
        let jsonData = "{\"token\": \"1234567890\" }".data(using: .utf8)

        let mockURLSession = MockURLSession(data: jsonData, urlResponse: nil, error: error)

        sut.session = mockURLSession

        let errorExpectation = expectation(description: "Error")

        var catchedError: Error? = nil

        sut.loginUser(withName: "Foo", password: "Bar") {
            (_, error) -> Void in

            catchedError = error

            errorExpectation.fulfill()
        }

        waitForExpectations(timeout: 1) { (_) in
            XCTAssertNotNil(catchedError)
        }
    }

}

extension APIClientTests {

    class MockURLSession: SessionProtocol {

        var url: URL?
        private let dataTask: MockTask

        init(data: Data?, urlResponse: URLResponse?, error: Error?) {
            dataTask = MockTask(data: data, urlResponse: urlResponse, error: error)
        }

        func dataTask(with url: URL,
                      completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            self.url = url
            dataTask.completionHandler = completionHandler

            return dataTask
        }

    }

    class MockTask: URLSessionDataTask {

        private let data: Data?
        private let urlResponse: URLResponse?
        private let responseError: Error?

        typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void

        var completionHandler: CompletionHandler?

        init(data: Data?, urlResponse: URLResponse?, error: Error?) {
            self.data = data
            self.urlResponse = urlResponse
            self.responseError = error
        }

        override func resume() {
            DispatchQueue.main.async {
                self.completionHandler?(self.data, self.urlResponse, self.responseError)
            }
        }
    }

}
