//
//  TempoTests.swift
//  TempoTests
//
//  Created by Kaio Dantas on 22/03/20.
//  Copyright © 2020 Kaio Dantas. All rights reserved.
//

import XCTest
import Alamofire
@testable import Tempo

class TempoTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        let e = expectation(description: "Alamofire")
        
        AF.request("https://api.darksky.net/forecast/xxxxxxxx/-5.813395,-35.208340?lang=pt&units=auto")
            .responseJSON { response in
                
                XCTAssertNil(response.error, "Error \(response.error!.localizedDescription)")
                
                XCTAssertNotNil(response, "No response")
                XCTAssertEqual(response.response?.statusCode ?? 0, 200, "Status code not 200")
                
                e.fulfill()
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }

    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            let e = expectation(description: "Alamofire")
            // Put the code you want to measure the time of here.
            AF.request("https://api.darksky.net/forecast/badaa032c8f10a4a4fc0e232df733148/-5.813395,-35.208340?lang=pt&units=auto")
                .responseJSON { response in
                    
                    XCTAssertNil(response.error, "Error \(response.error!.localizedDescription)")
                    
                    XCTAssertNotNil(response, "No response")
                    XCTAssertEqual(response.response?.statusCode ?? 0, 200, "Status code not 200")
                    
                    e.fulfill()
            }
            waitForExpectations(timeout: 5.0, handler: nil)
        }
    }
    
    
    
    var viewModel: ForecastViewModel = ForecastViewModel()
    
    func testDateTimeConverter() {
        var result = viewModel.createDateTime(timestamp: 1585019147, dateFormat: "E")
        XCTAssertEqual(result, "ter")
        
        result = viewModel.createDateTime(timestamp: 1585019147, dateFormat: "HH")
        XCTAssertEqual(result, "00")
    }
    
    

}
