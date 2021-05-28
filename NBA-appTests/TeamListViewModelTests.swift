//
//  NBA_appTests.swift
//  NBA-appTests
//
//  Created by Daniel James Tronca on 27/05/21.
//

import XCTest
@testable import NBA_app

class NBA_appTests: XCTestCase {

    var fakeRepository: TeamRepository?
    var fakeRepository404Error: TeamRepository?
//    var fakeRepository500Error: TeamRepository?

    override func setUpWithError() throws {
        fakeRepository = FakeTeamRepositorySuccess()
        fakeRepository404Error = FakeTeamRepository404CodeFailure()
//        fakeRepository500Error = FakeTeamRepository500CodeFailure()
    }
    
    func testGetDataSuccess_dataIsLoaded() {
        // View model initialization
        let fakeViewModel: TeamListViewModel = TeamListViewModel(teamRepository: fakeRepository!)
        // Create an expectation for a background download task.
        let expectationSuccessfulValidation = self.expectation(description: "Waiting successful validation")
        // Retrieve data
        fakeViewModel.retrieveAllTeams { (success) in
            // Move on
            expectationSuccessfulValidation.fulfill()
        }
        
        wait(for: [expectationSuccessfulValidation], timeout: 10.0)
        
        XCTAssertEqual(fakeViewModel.teamList.count, 4)
        
        XCTAssertFalse(fakeViewModel.teamList.isEmpty)
        
        XCTAssertEqual(fakeViewModel.teamList.first?.teamFullName, "Atlanta Hawks")
        
        XCTAssertEqual(fakeViewModel.teamList.first?.teamAbbreviation, "ATL")

    }
    
    func testGetDataSuccess_dataFailure404Code() {
        // View model initialization
        let fakeViewModel: TeamListViewModel = TeamListViewModel(teamRepository: fakeRepository404Error!)
        // Create an expectation for a background download task.
        let expectationSuccessfulValidation = self.expectation(description: "Waiting successful validation")
        // Error structure
        var errorStructure: ErrorStructure?
        // Retrieve data
        fakeViewModel.retrieveAllTeams { (error) in
            errorStructure = error
            // Move on
            expectationSuccessfulValidation.fulfill()
        }
        
        wait(for: [expectationSuccessfulValidation], timeout: 10.0)

        XCTAssertNotNil(errorStructure)
        
        XCTAssertEqual(errorStructure?.code, 404)
        
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

}
