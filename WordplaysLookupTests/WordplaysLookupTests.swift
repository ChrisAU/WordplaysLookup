//
//  WordplaysLookupTests.swift
//  WordplaysLookupTests
//
//  Created by Chris Nevin on 5/07/2016.
//  Copyright © 2016 CJNevin. All rights reserved.
//

import XCTest
@testable import WordplaysLookup

class WordplaysLookupTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let expect = expectation(withDescription: "Wait")
        WordplaysLookup.find(word: "example") { (definition) in
            print(definition)
            XCTAssertNotNil(definition)
            expect.fulfill()
        }
        waitForExpectations(withTimeout: 10) { (error) in
            XCTAssertNil(error)
        }
    }
    
    
}
