//
//  CommandsENV.swift
//  
//
//  Created by zhifei qiu on 2021/8/2.
//

import Foundation

public protocol CommandsENV {
  var executableURL: String { get }
  var dashc: String? { get }
  
  func run(_ command: String, environment: [String: String]?) -> Commands.Result
  func system(_ command: String, environment: [String: String]?)
  func system(_ command: String, environment: [String: String]?, output: ((String) -> Void)?, errorOutput: ((String) -> Void)?)
}

public extension CommandsENV {
  @discardableResult
  func run(_ command: String, environment: [String: String]? = nil) -> Commands.Result {
    let request = prepare(command, environment: environment)
    return Commands.Task.run(request)
  }
  
  func system(_ command: String, environment: [String: String]? = nil) {
    let request = prepare(command, environment: environment)
    Commands.Task.system(request)
  }
  
  func system(_ command: String, environment: [String: String]? = nil, output: ((String) -> Void)?, errorOutput: ((String) -> Void)?) {
    let request = prepare(command, environment: environment)
    Commands.Task.system(request, output: output, errorOutput: errorOutput)
  }
}

private extension CommandsENV {
  func prepare(_ command: String, environment: [String: String]? = nil) -> Commands.Request {
    return Commands.Request(executableURL, dashc: dashc, command: command, environment: environment)
  }
}
