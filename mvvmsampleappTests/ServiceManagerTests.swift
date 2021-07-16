//
//  ServiceManagerTests.swift
//  mvvmsampleappTests
//
//  Created by Gizem Gulsen on 7/16/21.
//  Copyright © 2021 Gizem Dayioglu. All rights reserved.
//

import XCTest
@testable import mvvmsampleapp

class ServiceManagerTests: XCTestCase {

    var service: ServiceManager?

    override func setUp() {
        super.setUp()
        service = ServiceManager()
    }

    override func tearDown() {
        service = nil
        super.tearDown()
    }

    func test_fetch_photos() {

        let service = self.service!
        let expect = XCTestExpectation(description: "callback")

        service.fetchPopularPhoto(complete: { (success, photos, error) in
            expect.fulfill()
            XCTAssertEqual( photos.count, 20)

            for photo in photos {
                XCTAssertNotNil(photo.photoId)
            }

        })

        wait(for: [expect], timeout: 3.1)
    }

}
