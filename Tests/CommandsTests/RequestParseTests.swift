//
//  RequestParseTests.swift
//
//
//  Created by zhifei qiu on 2021/9/10.
//

import XCTest
import Commands

final class RequestParseTests: XCTestCase {
  func testRequestParseWhitespace() throws {
    XCTAssertEqual(Commands.Request(""),
                   Commands.Request(Commands.ENV(),
                                    executableURL: "",
                                    dashc: nil,
                                    arguments: nil,
                                    audited: true))
    
    XCTAssertEqual(Commands.Request("   "),
                   Commands.Request(Commands.ENV(),
                                    executableURL: "",
                                    dashc: nil,
                                    arguments: nil,
                                    audited: true))
    
    XCTAssertEqual(Commands.Request(["", " "]),
                   Commands.Request(Commands.ENV(),
                                    executableURL: "",
                                    dashc: nil,
                                    arguments: nil,
                                    audited: true))
  }
  
  func testRequestParse() {
    do {
      let request = Commands.Request("bash -c ls")
      let requestX = Commands.Request(["bash", "-c", "ls"])
      XCTAssert(request == requestX)
      XCTAssertEqual(Commands.Task.run(request), Commands.Task.run(requestX))
    }
    
    do {
      let request = Commands.Request("https_proxy=http://127.0.0.1:7891 http_proxy=http://127.0.0.1:7891 all_proxy=socks5://127.0.0.1:7891 curl https://api64.ipify.org?format=json")
      
      var env = Commands.ENV()
      env["https_proxy"] = "http://127.0.0.1:7891"
      env["http_proxy"] = "http://127.0.0.1:7891"
      env["all_proxy"] = "socks5://127.0.0.1:7891"
      let requestX = Commands.Request(env,
                                      executableURL: "curl",
                                      dashc: nil,
                                      arguments: "https://api64.ipify.org?format=json",
                                      audited: true)
      XCTAssert(request == requestX)
      XCTAssertEqual(Commands.Task.run(request).statusCode, Commands.Task.run(requestX).statusCode)
    }
    
    do {
      let request = Commands.Request(["curl", "-i", "https://api64.ipify.org?format=json"])
      let requestX = Commands.Request(Commands.ENV(),
                                      executableURL: "curl",
                                      dashc: nil,
                                      arguments: ["-i", "https://api64.ipify.org?format=json"],
                                      audited: true)
      XCTAssert(request == requestX)
    }
  }
}
