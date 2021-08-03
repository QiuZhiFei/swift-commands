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
  
  func run(_ command: String) -> Commands.Result
  func system(_ command: String)
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
  func run(_ command: String) -> Commands.Result {
    let process = prepare(command)
    
    let output = Pipe()
    process.standardOutput = output
    
    let error = Pipe()
    process.standardError = error
    
    run(process)
    
    let outputData = output.fileHandleForReading.readDataToEndOfFile()
    let outputActual = String(data: outputData, encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines)
    
    let errorData = error.fileHandleForReading.readDataToEndOfFile()
    let errorActual = String(data: errorData, encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines)
    
    if process.terminationStatus == EXIT_SUCCESS {
      return Commands.Result.Success(output: outputActual)
    }
    
    return Commands.Result.Failure(code: process.terminationStatus, output: errorActual)
  }
  
  func system(_ command: String) {
    let process = prepare(command)
    run(process)
  }
}

private extension CommandsENV {
  func prepare(_ command: String) -> Process {
    let process = Process()
    if #available(macOS 10.13, *) {
      process.executableURL = URL(fileURLWithPath: executableURL)
    } else {
      process.launchPath = executableURL
    }
    process.arguments = [dashc, command]
    return process
  }
  
  func run(_ process: Process) {
    if #available(macOS 10.13, *) {
      try? process.run()
    } else {
      process.launch()
    }
    process.waitUntilExit()
  }
}
