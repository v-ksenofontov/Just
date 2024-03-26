//
//  JustAsyncTests.swift
//  JustTests
//
//  Created by Vyacheslav Ksenofontov on 31.10.2021.
//  Copyright © 2021 JustHTTP. All rights reserved.
//

import XCTest
import Just

class JustAsyncTests: XCTestCase {

    func testSendSimpleQueryStringWithGet() async throws {
     
        let r = try await Just.get("http://httpbin.org/get", params: ["a": 1])
        XCTAssert(r.json != nil)
        if let jsonData = r.json as? [String: Any] {
            XCTAssert(jsonData["args"] != nil)
            if let args = jsonData["args"] as? [String: String] {
                XCTAssertEqual(args, ["a": "1"])
            }
        }
    }
}
