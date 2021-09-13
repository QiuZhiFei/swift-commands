//
//  CommandsDashcTransformer.swift
//  
//
//  Created by zhifei qiu on 2021/9/11.
//

import Foundation

public protocol CommandsDashcTransformerHandler {
  static func canHandle(executableURL: String, dashc: Commands.Arguments?) -> Bool
  static func handle(executableURL: String, dashc: Commands.Arguments?) -> Commands.Arguments?
}

extension Commands {
  public enum DashcTransformer { }
}

extension Commands.DashcTransformer {
  private static var handlers: [CommandsDashcTransformerHandler.Type] = [
    Bash.self,
    Ruby.self,
    Python.self,
    Node.self,
  ]
}

extension Commands.DashcTransformer {
  public static func register(_ handler: CommandsDashcTransformerHandler.Type) {
    if handlers.contains(where: { it in return type(of: it) == type(of: handler) }) {
      return
    }
    handlers.append(handler)
  }
  
  public static func unregister(_ handler: CommandsDashcTransformerHandler.Type) {
    while let index = handlers.firstIndex(where: { it in return type(of: it) == type(of: handler) }) {
      handlers.remove(at: index)
    }
  }
}

extension Commands.DashcTransformer {
  static func transformer(executableURL: String, dashc: Commands.Arguments?) -> Commands.Arguments? {
    for handler in handlers {
      if handler.canHandle(executableURL: executableURL, dashc: dashc) {
        return handler.handle(executableURL: executableURL, dashc: dashc)
      }
    }
    return nil
  }
}

extension Commands.DashcTransformer {
  public struct Bash: CommandsDashcTransformerHandler {
    public static func canHandle(executableURL: String,
                                 dashc: Commands.Arguments?) -> Bool {
      if executableURL.hasSuffix("bash"), dashc?.raw == ["-c"] {
        return true
      }
      return false
    }
    
    public static func handle(executableURL: String,
                              dashc: Commands.Arguments?) -> Commands.Arguments? {
      return dashc?.raw == ["-c"] ? dashc : nil
    }
  }
}

extension Commands.DashcTransformer {
  public struct Ruby: CommandsDashcTransformerHandler {
    public static func canHandle(executableURL: String,
                                 dashc: Commands.Arguments?) -> Bool {
      if executableURL.hasSuffix("ruby"), dashc?.raw == ["-e"] {
        return true
      }
      return false
    }
    
    public static func handle(executableURL: String,
                              dashc: Commands.Arguments?) -> Commands.Arguments? {
      return dashc?.raw == ["-e"] ? dashc : nil
    }
  }
}


extension Commands.DashcTransformer {
  public struct Python: CommandsDashcTransformerHandler {
    public static func canHandle(executableURL: String,
                                 dashc: Commands.Arguments?) -> Bool {
      if executableURL.hasSuffix("python"), dashc?.raw == ["-c"] {
        return true
      }
      return false
    }
    
    public static func handle(executableURL: String,
                              dashc: Commands.Arguments?) -> Commands.Arguments? {
      return dashc?.raw == ["-c"] ? dashc : nil
    }
  }
}

extension Commands.DashcTransformer {
  public struct Node: CommandsDashcTransformerHandler {
    public static func canHandle(executableURL: String,
                                 dashc: Commands.Arguments?) -> Bool {
      if executableURL.hasSuffix("node"), dashc?.raw == ["-e"] {
        return true
      }
      return false
    }
    
    public static func handle(executableURL: String,
                              dashc: Commands.Arguments?) -> Commands.Arguments? {
      return dashc?.raw == ["-e"] ? dashc : nil
    }
  }
}
