//
//  CommandsAlias.swift
//
//
//  Created by zhifei qiu on 2021/8/24.
//

import Foundation

extension Commands {
  public struct Alias {
    public let executableURL: String
    public let dashc: Commands.Arguments?
    
    public init(_ executableURL: String, dashc: Commands.Arguments? = nil) {
      self.executableURL = executableURL
      self.dashc = dashc
    }
  }
}

public extension Commands.Alias {
  @discardableResult
  func run(_ arguments: Commands.Arguments? = nil,
           environment: Commands.ENV? = Commands.ENV.global) -> Commands.Result {
    let request = prepare(arguments, environment: environment)
    return Commands.Task.run(request)
  }
  
  func system(_ arguments: Commands.Arguments? = nil,
              environment: Commands.ENV? = Commands.ENV.global) {
    let request = prepare(arguments, environment: environment)
    Commands.Task.system(request)
  }
  
  func system(_ arguments: Commands.Arguments? = nil,
              environment: Commands.ENV? = Commands.ENV.global,
              output: ((String) -> Void)?,
              errorOutput: ((String) -> Void)?) {
    let request = prepare(arguments, environment: environment)
    Commands.Task.system(request, output: output, errorOutput: errorOutput)
  }
}

private extension Commands.Alias {
  func prepare(_ arguments: Commands.Arguments?,
               environment: Commands.ENV?) -> Commands.Request {
    return Commands.Request(environment,
                            executableURL: executableURL,
                            dashc: dashc,
                            arguments: arguments)
  }
}

public extension Commands {
  static let Bash = Commands.Alias("bash", dashc: "-c")
  static let Ruby = Commands.Alias("ruby", dashc: "-e")
  static let Python = Commands.Alias("python", dashc: "-c")
  static let Node = Commands.Alias("node", dashc: "-e")
}
