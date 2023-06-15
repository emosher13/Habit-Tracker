//
//  Habit_TrackerTests.swift
//  Habit TrackerTests
//
//  Created by Ethan Mosher on 6/14/23.
//
//
//import XCTest
//@testable import Habit_Tracker
//
//class QuoteViewControllerViewModelTests: XCTestCase {
//
//    var sut: QuoteView
//
//    override func setUp() {
//        super.setUp()
//        sut = QuoteViewControllerViewModel()
//    }
//
//    override func tearDown() {
//        sut = nil
//        super.tearDown()
//    }
//
//    func testFetchRandomQuote() {
//        let expectation = XCTestExpectation(description: "Fetch random quote")
//
//        sut.fetchRandomQuote { quote in
//            XCTAssertNotNil(quote, "Quote should not be nil")
//            expectation.fulfill()
//        }
//
//        wait(for: [expectation], timeout: 5.0)
//    }
//
//    func testFetchRandomQuoteFailure() {
//        let expectation = XCTestExpectation(description: "Fetch random quote failure")
//
//        // Set an invalid URL to force a failure
//        sut.quotesURL = URL(string: "https://invalid-url")
//
//        sut.fetchRandomQuote { quote in
//            XCTAssertNil(quote, "Quote should be nil on failure")
//            expectation.fulfill()
//        }
//
//        wait(for: [expectation], timeout: 5.0)
//    }
//
//}
