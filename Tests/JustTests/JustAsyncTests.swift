//
//  JustAsyncTests.swift
//  JustTests
//
//  Created by Vyacheslav Ksenofontov on 31.10.2021.
//  Copyright © 2021 JustHTTP. All rights reserved.
//

import XCTest
import Just
import _Concurrency

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
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
    
    /**
     result GET https://fakeresponder.com/?sleep=2500 200
     Took 3 seconds
     */
    @available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
    func testGetWithFakeresponder() async throws {
        // sleep time in milliseconds
        // https://fakeresponder.com/?sleep=500
        let url = URL(string: "https://fakeresponder.com/?sleep=2500")!

        let task: Task<HTTPResult, Error> = Task {
            try await Just.get(url)
        }
     
        Task {
            let clock = ContinuousClock()
            let time = try await clock.measure {
                let result = try await task.value
                print("result \(result)")
                XCTAssertEqual("\(result)", "GET https://fakeresponder.com/?sleep=2500 200")
            }
            print("Took \(time.components.seconds) seconds")
            XCTAssertEqual(time.components.seconds, 3)
        }
    }
    
    /**
     Cancel call
     result <Empty>
     Took 0 seconds
     */
    @available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
    func testCancelBeforeGetWithFakeresponder() async throws {
        // sleep time in milliseconds
        // https://fakeresponder.com/?sleep=500
        let url = URL(string: "https://fakeresponder.com/?sleep=2500")!

        let task: Task<HTTPResult, Error> = Task {
            try await Just.get(url)
        }
        
        Task {
            task.cancel()
            print("Cancel call")
        }
     
        Task {
            let clock = ContinuousClock()
            let time = try await clock.measure {
                let result = try await task.value
                print("result \(result)")
                XCTAssertEqual("\(result)", "<Empty>")
            }
            print("Took \(time.components.seconds) seconds")
            XCTAssertEqual(time.components.seconds, 0)
        }
    }
    
    /**
     Cancel in a second
     result <Empty>
     Took 1 seconds
     */
    @available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
    func testCancelAfterGetWithFakeresponder() async throws {
        // sleep time in milliseconds
        // https://fakeresponder.com/?sleep=500
        let url = URL(string: "https://fakeresponder.com/?sleep=2500")!

        let task: Task<HTTPResult, Error> = Task {
            try await Just.get(url)
        }
     
        Task {
            let clock = ContinuousClock()
            let time = try await clock.measure {
                let result = try await task.value
                print("result \(result)")
                XCTAssertEqual("\(result)", "<Empty>")
            }
            print("Took \(time.components.seconds) seconds")
            XCTAssertEqual(time.components.seconds, 1)
        }
        
        Task {
            try? await Task.sleep(nanoseconds: 1 * 1_000_000_000)
            task.cancel()
            print("Cancel in a second")
        }
    }
}
