//
//  CommandsRequest.swift
//  
//
//  Created by zhifei qiu on 2021/8/25.
//

import Foundation

public extension Commands {
  struct Request {
    public var environment: ENV? {
      didSet {
        if audited {
          self.executableURL = getAbsoluteExecutableURL()
        }
      }
    }
    public var executableURL: String {
      didSet {
        if audited {
          self.executableURL = getAbsoluteExecutableURL()
        }
      }
    }
    public var dashc: Arguments?
    public var arguments: Arguments?
    public let audited: Bool
    public var absoluteCommand: String {
      return getAbsoluteCommand()
    }
    
    public init(_ environment: ENV? = ENV.global,
                executableURL: String,
                dashc: Arguments? = nil,
                arguments: Arguments? = nil,
                audited: Bool = true) {
      self.executableURL = executableURL
      self.environment = environment
      self.dashc = dashc
      self.arguments = arguments
      self.audited = audited
      if audited {
        self.executableURL = getAbsoluteExecutableURL()
      }
    }
    
    init(_ string: String) {
      var data = string.split(separator: " ").map{ String($0) }
      if data.count == 0 {
        data = [string]
      }
      let env = data.filter{ $0.split(separator: "=").count == 2 }
      var command = data.filter{ !env.contains($0) }
      
      let executableURL = command.first!
      command.removeFirst()
      
      var dashc: Commands.Arguments? = nil
      if (command.first ?? "").starts(with: "-") {
        dashc = Commands.Arguments(command.first!)
        command.removeFirst()
      }
      
      var arguments = command
      if arguments.count > 0 {
        arguments = [arguments.joined(separator: " ")]
      }
      
      var environment = ENV.global
      for arg in env {
        let key = String(arg.split(separator: "=")[0])
        let value = String(arg.split(separator: "=")[1])
        environment[key] = value
      }
      self.init(environment,
                executableURL: executableURL,
                dashc: dashc,
                arguments: Commands.Arguments(arguments))
    }
  }
}

extension Commands.Request: Swift.ExpressibleByStringLiteral {
  public init(stringLiteral value: StringLiteralType) {
    self.init(value)
  }
  
  public init(extendedGraphemeClusterLiteral value: String) {
    self.init(value)
  }
  
  public init(unicodeScalarLiteral value: String) {
    self.init(value)
  }
}

extension Commands.Request: Swift.ExpressibleByStringInterpolation {
  public init(stringInterpolation: DefaultStringInterpolation) {
    self.init(stringInterpolation.description)
  }
}

private extension Commands.Request {
  private func getAbsoluteExecutableURL() -> String {
    if FileManager.default.fileExists(atPath: executableURL) {
      return executableURL
    }
    guard let environment = environment else { return executableURL }
    let paths = environment["PATH"]?.split(separator: ":").map{ String($0) } ?? []
    guard paths.count > 0 else { return executableURL }
    for path in paths {
      let absoluteExecutableURL = "\(path)/\(executableURL)"
      if FileManager.default.fileExists(atPath: absoluteExecutableURL) {
        return absoluteExecutableURL
      }
    }
    return executableURL
  }
  
  func getAbsoluteCommand() -> String {
    var result: [String] = []
    if let environment = environment {
      let defaultENV = ProcessInfo.processInfo.environment
      result += environment.data
        .filter{ defaultENV[$0.0] != $0.1 }
        .map{ "\($0)=\($1)" }
    }
    result += [executableURL]
    result += dashc?.raw ?? []
    result += arguments?.raw ?? []
    return result.joined(separator: " ")
  }
}

extension Commands.Request: Equatable {
  public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.environment == rhs.environment
      && lhs.executableURL == rhs.executableURL
      && lhs.dashc == rhs.dashc
      && lhs.arguments == rhs.arguments
      && lhs.audited == rhs.audited
  }
}
