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
    
    public init(_ string: String) {
      self = Self.create([string])
    }
    
    public init(_ elements: [String]) {
      self = Self.create(elements)
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

extension Commands.Request: Swift.ExpressibleByArrayLiteral {
  public init(arrayLiteral elements: String...) {
    self = Self.create(elements)
  }
}

private extension Commands.Request {
  func getAbsoluteExecutableURL() -> String {
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
  
  static func create(_ data: [String],
                     prepareArguments: (([String]) -> ([String]))? = nil) -> Self {
    if data.count == 0 {
      return Commands.Request(executableURL: "")
    }
    
    let result = parse(data)
    
    let env = result.0.env
    let executableURL = result.1.executableURL
    let dashc = result.2.dashc
    let arguments = result.3.arguments
    
    var environment = Commands.ENV.global
    for arg in env {
      let key = String(arg[arg.startIndex..<arg.firstIndex(of: "=")!])
      let value = String(arg[arg.firstIndex(of: "=")!..<arg.endIndex].dropFirst())
      environment[key] = value
    }
    
    return Commands.Request(environment,
                            executableURL: executableURL,
                            dashc: dashc,
                            arguments: arguments)
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

extension Commands.Request {
  private struct ENVResult {
    var env: [String] = []
    var finished: Bool = false
  }
  
  private struct ExecutableURLResult {
    var executableURL: String = ""
    var finished: Bool = false
  }
  
  private struct DashcResult {
    var dashc: Commands.Arguments? = nil
    var finished: Bool = false
  }
  
  private struct ArgumentsResult {
    var arguments: Commands.Arguments? = nil
    var finished: Bool = false
  }
  
  private static func parse(_ data: [String]) -> (
    ENVResult, ExecutableURLResult, DashcResult, ArgumentsResult) {
    var data = data.filter{ $0.split(separator: " ").map{ String($0) }.count > 0 }
    
    var envResult = ENVResult()
    var executableURLResult = ExecutableURLResult()
    var dashcResult = DashcResult()
    var argumentsResult = ArgumentsResult()
    
    while data.count > 0 {
      // env
      if !envResult.finished {
        let parameters = data.first!.split(separator: " ").map{ String($0) }
        if !parameters.first!.contains("=") {
          envResult.finished = true
        } else {
          envResult.env.append(parameters.first!)
          data = shift(parameters, data)
        }
        continue
      }
      
      // executableURL
      if !executableURLResult.finished {
        let parameters = data.first!.split(separator: " ").map{ String($0) }
        executableURLResult.executableURL = parameters.first!
        data = shift(parameters, data)
        executableURLResult.finished = true
        continue
      }
      
      // dashc
      if !dashcResult.finished {
        let parameters = data.first!.split(separator: " ").map{ String($0) }
        if parameters.first!.starts(with: "-"),
           let dashc = Commands.DashcTransformerHandlerManager.transformer(executableURL: executableURLResult.executableURL, dashc: Commands.Arguments(parameters.first!)) {
          dashcResult.dashc = dashc
          data = shift(parameters, data)
        }
        dashcResult.finished = true
        continue
      }
      
      // arguments
      if !argumentsResult.finished {
        if data.count > 0 {
          argumentsResult.arguments = Commands.Arguments(data)
        }
        data.removeAll()
        argumentsResult.finished = true
        continue
      }
    }
    
    return (envResult, executableURLResult, dashcResult, argumentsResult)
  }
  
  private static func shift(_ parameters: [String],
                            _ data: [String]) -> [String] {
    var data = data
    let command = parameters.dropFirst().joined(separator: " ")
    if command.count == 0 {
      data.removeFirst()
    } else {
      data.replaceSubrange(0...0, with: [command])
    }
    data = data.filter{ $0.split(separator: " ").map{ String($0) }.count > 0 }
    return data
  }
}
