//
//  CommandsENV.swift
//  
//
//  Created by zhifei qiu on 2021/8/2.
//

import Foundation

public protocol CommandsENV {
  var executableURL: String { get }
  var dashc: String { get }
  
  func env()
  
  func run(_ command: String, environment: [String: String]?) -> Commands.Result
  func system(_ command: String, environment: [String: String]?)
}

public extension CommandsENV {
  func env() {
    let desc = """
      ExecutableURL: \(executableURL)
      Dashc: \(dashc)
      """
    print(desc)
  }
  
  @discardableResult
  func run(_ command: String, environment: [String: String]? = nil) -> Commands.Result {
    let request = prepare(command, environment: environment)
    return Commands.Task.run(request)
  }
  
  func system(_ command: String, environment: [String: String]? = nil) {
    let request = prepare(command, environment: environment)
    Commands.Task.system(request)
  }
}

private extension CommandsENV {
  func prepare(_ command: String, environment: [String: String]? = nil) -> Commands.Request {
    return Commands.Request(executableURL, dashc: dashc, command: command, environment: environment)
  }
}
