////
////  Habit_TrackerTests.swift
////  Habit TrackerTests
////
////  Created by Ethan Mosher on 6/14/23.
////
//
//import XCTest
//import Firebase
//@testable import Habit_Tracker
//// Import the necessary Firebase and Firestore modules
//
//// MARK: - Protocols
//
//protocol HabitViewControllerViewModelDelegate: AnyObject {
//    func reloadTableView()
//    func updateProgress()
//}
//
//protocol FirestoreProtocol {
//    func collection(_ collectionPath: String) -> CollectionReferenceProtocol
//    func addDocument(data: [String: Any], completion: ((Error?) -> Void)?) -> DocumentReferenceProtocol
//    // Define other Firestore methods you're using in your view model
//}
//
//protocol CollectionReferenceProtocol {
//    // Define the methods and properties you're using from CollectionReference
//}
//
//protocol DocumentReferenceProtocol {
//    // Define the methods and properties you're using from DocumentReference
//}
//
//protocol DocumentSnapshotProtocol {
//    // Define the methods and properties you're using from DocumentSnapshot
//}
//
//// MARK: - View Model
//
//class HabitViewControllerViewModel {
//    weak var delegate: HabitViewControllerViewModelDelegate?
//    var firestore: FirestoreProtocol?
//    
//    // Other properties and methods of the view model
//    
//    func addHabit(_ habitName: String) {
//        // Implementation of addHabit method
//        // Use firestore?.collection and firestore?.addDocument methods
//    }
//    
//    func removeHabit(at index: Int) {
//        // Implementation of removeHabit method
//        // Use firestore?.collection, firestore?.document, and firestore?.delete methods
//    }
//    
//    func toggleHabit(at index: Int) {
//        // Implementation of toggleHabit method
//        // Use firestore?.collection, firestore?.document, and firestore?.updateData methods
//    }
//    
//    func uncheckHabits() {
//        // Implementation of uncheckHabits method
//        // Use firestore?.collection, firestore?.document, and firestore?.updateData methods
//    }
//}
//
//// MARK: - Unit Tests
//
//class HabitViewControllerViewModelTests: XCTestCase {
//    
//    var sut: HabitViewControllerViewModel!
//    var mockDelegate: MockViewModelDelegate!
//    var mockFirestore: MockFirestore!
//    
//    override func setUp() {
//        super.setUp()
//        mockDelegate = MockViewModelDelegate()
//        sut = HabitViewControllerViewModel()
//        sut.delegate = mockDelegate
//        sut.firestore = mockFirestore
//    }
//    
//    override func tearDown() {
//        sut = nil
//        mockDelegate = nil
//        mockFirestore = nil
//        super.tearDown()
//    }
//    
//    // MARK: - Add Habit Tests
//    
//    func testAddHabit_Successful() {
//        // Define the habit name
//        let habitName = "Exercise"
//        
//        // Call the addHabit function
//        sut.addHabit(habitName)
//        
//        // Verify that the Firestore collection was called with the correct data
//        XCTAssertTrue(mockFirestore.addDocumentCalled)
//        XCTAssertEqual(mockFirestore.addDocumentData?["habitName"] as? String, habitName)
//        XCTAssertEqual(mockFirestore.addDocumentData?["isChecked"] as? Bool, false)
//        
//        // Verify that the loadHabits function was called
//        XCTAssertTrue(mockDelegate.reloadTableViewCalled)
//    }
//    
//    // MARK: - Remove Habit Tests
//    
//    func testRemoveHabit_InvalidIndex() {
//        // Call the removeHabit function with an invalid index
//        sut.removeHabit(at: 5)
//        
//        // Verify that the delegate's reloadTableView function was not called
//        XCTAssertFalse(mockDelegate.reloadTableViewCalled)
//        
//        // Verify that the Firestore collection was not accessed
//        XCTAssertFalse(mockFirestore.documentGetCalled)
//        XCTAssertFalse(mockFirestore.documentDeleteCalled)
//    }
//    
//    func testRemoveHabit_ValidIndex_HabitExists() {
//        // Create a mock habit with a document ID
//        let mockHabit = HabitInfo(habitName: "Exercise", isChecked: false, docID: "abc123")
//        
//        // Set the habits array in the view model
//        sut.habits = [mockHabit]
//        
//        // Call the removeHabit function with a valid index
//        sut.removeHabit(at: 0)
//        
//        // Verify that the Firestore collection was accessed and the habit was deleted
//        XCTAssertTrue(mockFirestore.documentGetCalled)
//        XCTAssertTrue(mockFirestore.documentDeleteCalled)
//        
//        // Verify that the delegate's reloadTableView function was called
//        XCTAssertTrue(mockDelegate.reloadTableViewCalled)
//    }
//    
//    func testRemoveHabit_ValidIndex_HabitDoesNotExist() {
//        // Create a mock habit without a document ID
//        let mockHabit = HabitInfo(habitName: "Exercise", isChecked: false, docID: nil)
//        
//        // Set the habits array in the view model
//        sut.habits = [mockHabit]
//        
//        // Call the removeHabit function with a valid index
//        sut.removeHabit(at: 0)
//        
//        // Verify that the Firestore collection was not accessed
//        XCTAssertFalse(mockFirestore.documentGetCalled)
//        XCTAssertFalse(mockFirestore.documentDeleteCalled)
//        
//        // Verify that the delegate's reloadTableView function was not called
//        XCTAssertFalse(mockDelegate.reloadTableViewCalled)
//    }
//    
//    // MARK: - Toggle Habit Tests
//    
//    func testToggleHabit_ValidIndex_HabitExists() {
//        // Create a mock habit with a document ID
//        let mockHabit = HabitInfo(habitName: "Exercise", isChecked: false, docID: "abc123")
//        
//        // Set the habits array in the view model
//        sut.habits = [mockHabit]
//        
//        // Call the toggleHabit function with a valid index
//        sut.toggleHabit(at: 0)
//        
//        // Verify that the habit's isChecked property was toggled
//        XCTAssertTrue(sut.habits[0].isChecked)
//        
//        // Verify that the Firestore collection was updated
//        XCTAssertTrue(mockFirestore.documentUpdateCalled)
//        
//        // Verify that the delegate's reloadTableView function was called
//        XCTAssertTrue(mockDelegate.reloadTableViewCalled)
//    }
//    
//    func testToggleHabit_ValidIndex_HabitDoesNotExist() {
//        // Create a mock habit without a document ID
//        let mockHabit = HabitInfo(habitName: "Exercise", isChecked: false, docID: nil)
//        
//        // Set the habits array in the view model
//        sut.habits = [mockHabit]
//        
//        // Call the toggleHabit function with a valid index
//        sut.toggleHabit(at: 0)
//        
//        // Verify that the habit's isChecked property was toggled
//        XCTAssertTrue(sut.habits[0].isChecked)
//        
//        // Verify that the Firestore collection was not updated
//        XCTAssertFalse(mockFirestore.documentUpdateCalled)
//        
//        // Verify that the delegate's reloadTableView function was called
//        XCTAssertTrue(mockDelegate.reloadTableViewCalled)
//    }
//    
//    // MARK: - Midnight Reset Tests
//    
//    func testUncheckHabits() {
//        // Call the uncheckHabits function
//        sut.uncheckHabits()
//        
//        // Verify that the updateHabitsCheckedStatus function was called with false
//        XCTAssertTrue(mockFirestore.documentUpdateCalled)
//        XCTAssertFalse(mockFirestore.updateData?["isChecked"] as? Bool ?? true)
//        
//        // Verify that the scheduleUncheckHabitsTask function was called
//        XCTAssertTrue(mockDelegate.updateProgressCalled)
//    }
//    
//    // MARK: - Helper Classes
//    
//    class MockViewModelDelegate: HabitViewControllerViewModelDelegate {
//        var reloadTableViewCalled = false
//        var updateProgressCalled = false
//        
//        func reloadTableView() {
//            reloadTableViewCalled = true
//        }
//        
//        func updateProgress() {
//            updateProgressCalled = true
//        }
//    }
//    
//    class MockFirestore: FirestoreProtocol {
//        var collectionPath: String?
//        var addDocumentData: [String: Any]?
//        var addDocumentCalled = false
//        
//        var documentGetCalled = false
//        var documentDeleteCalled = false
//        
//        var documentUpdateCalled = false
//        var updateData: [String: Any]?
//        
//        func collection(_ collectionPath: String) -> CollectionReferenceProtocol {
//            self.collectionPath = collectionPath
//            return MockCollectionReference()
//        }
//        
//        func addDocument(data: [String: Any], completion: ((Error?) -> Void)?) -> DocumentReferenceProtocol {
//            addDocumentCalled = true
//            addDocumentData = data
//            // Invoke the completion block if needed
//            
//            return MockDocumentReference()
//        }
//        
//        // Implement other Firestore methods you're using in your view model
//    }
//    
//    class MockCollectionReference: CollectionReferenceProtocol {
//        // Implement the necessary methods and properties
//    }
//    
//    class MockDocumentReference: DocumentReferenceProtocol {
//        // Implement the necessary methods and properties
//    }
//    
//    class MockDocumentSnapshot: DocumentSnapshotProtocol {
//        // Implement the necessary methods and properties
//    }
//    
//    struct HabitInfo {
//        let habitName: String
//        var isChecked: Bool
//        let docID: String?
//    }
//}
//
//
