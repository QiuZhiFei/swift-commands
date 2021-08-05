//
//  CommandsTask.swift
//
//
//  Created by zhifei qiu on 2021/8/4.
//

import Foundation

public extension Commands {
  struct Request {
    public let executableURL: String
    public let dashc: String?
    public let command: String
    public var environment: [String: String]?
    
    public init(_ executableURL: String,
                dashc: String? = nil,
                command: String,
                environment: [String: String]? = nil) {
      self.executableURL = executableURL
      self.dashc = dashc
      self.command = command
      self.environment = environment
    }
  }
  
  struct Response {
    public let statusCode: Int32
    public let output: String
  }
}

public extension Commands {
  enum Task { }
}

public extension Commands.Task {
  @discardableResult
  static func run(_ request: Commands.Request) -> Commands.Result {
    let process = prepare(request)
    
    let outputPipe = Pipe()
    process.standardOutput = outputPipe
    
    let errorPipe = Pipe()
    process.standardError = errorPipe
    
    do {
      try run(process)
      
      let outputActual = try fileHandleData(fileHandle: outputPipe.fileHandleForReading) ?? ""
      let errorActual = try fileHandleData(fileHandle: errorPipe.fileHandleForReading) ?? ""
      
      if process.terminationStatus == EXIT_SUCCESS {
        let response = Commands.Response(statusCode: process.terminationStatus, output: outputActual)
        return Commands.Result.Success(request, reponse: response)
      }
      
      let response = Commands.Response(statusCode: process.terminationStatus, output: errorActual)
      return Commands.Result.Failure(request, reponse: response)
    } catch let error {
      let response = Commands.Response(statusCode: EXIT_FAILURE, output: error.localizedDescription)
      return Commands.Result.Failure(request, reponse: response)
    }
  }
  
  static func system(_ request: Commands.Request,
                     output: ((String) -> Void)?,
                     errorOutput: ((String) -> Void)?) {
    let process = prepare(request)
    do {
      if let output = output {
        let outputPipe = Pipe()
        process.standardOutput = outputPipe
        outputPipe.fileHandleForReading.readabilityHandler = { (handler) in
          let data = handler.availableData
          if data.count > 0,
             let result = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) {
            output(result)
          }
        }
      }
      if let errorOutput = errorOutput {
        let errorPipe = Pipe()
        process.standardError = errorPipe
        errorPipe.fileHandleForReading.readabilityHandler = { (handler) in
          let data = handler.availableData
          if data.count > 0,
             let result = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) {
            errorOutput(result)
          }
        }
      }
      
      try run(process)
      
      if let _ = output, let outputPipe = process.standardOutput as? Pipe {
        outputPipe.fileHandleForReading.readabilityHandler = nil
      }
      if let _ = errorOutput, let errorPipe = process.standardError as? Pipe {
        errorPipe.fileHandleForReading.readabilityHandler = nil
      }
    } catch let error {
      print(error.localizedDescription)
    }
  }
  
  static func system(_ request: Commands.Request) {
    let process = prepare(request)
    do {
      try run(process)
    } catch let error {
      print(error.localizedDescription)
    }
  }
}

private extension Commands.Task {
  static func prepare(_ request: Commands.Request) -> Process {
    let process = Process()
    if #available(macOS 10.13, *) {
      process.executableURL = URL(fileURLWithPath: request.executableURL)
    } else {
      process.launchPath = request.executableURL
    }
    if let environment = request.environment {
      process.environment = environment
    }
    if let dashc = request.dashc {
      process.arguments = [dashc, request.command]
    } else {
      process.arguments = [request.command]
    }
    return process
  }
  
  static func run(_ process: Process) throws {
    if #available(macOS 10.13, *) {
      try process.run()
    } else {
      process.launch()
    }
    process.waitUntilExit()
  }
  
  static func fileHandleData(fileHandle: FileHandle) throws -> String? {
    var outputData: Data?
    if #available(macOS 10.15.4, *) {
      outputData = try fileHandle.readToEnd()
    } else {
      outputData = fileHandle.readDataToEndOfFile()
    }
    if let outputData = outputData {
      return String(data: outputData, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    return nil
  }
}

