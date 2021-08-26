//
//  CommandsENV.swift
//  
//
//  Created by zhifei qiu on 2021/8/25.
//

import Foundation

extension Commands {
  public struct ENV {
    public private(set) var data: [String: String] = [:]
    
    public init(_ data: [String: String]? = ProcessInfo.processInfo.environment) {
      self.data = data ?? [:]
    }
  }
}

extension Commands.ENV {
  public static var global = Commands.ENV()
}

public extension Commands.ENV {
  mutating func add(PATH: String) {
    data["PATH"] = data["PATH"] == nil ? PATH : "\(PATH):\(data["PATH"]!)"
  }
}

public extension Commands.ENV {
  subscript(_ key: String) -> String? {
    set(newValue) {
      data[key] = newValue
    }
    get {
      return data[key]
    }
  }
}

extension Commands.ENV: Swift.ExpressibleByDictionaryLiteral {
  public init(dictionaryLiteral elements: (String, String)...) {
    let dictionary = elements.reduce(into: [String: String](), { $0[$1.0] = $1.1})
    self.init(dictionary)
  }
}

extension Commands.ENV: Equatable {
  public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.data == rhs.data
  }
}
