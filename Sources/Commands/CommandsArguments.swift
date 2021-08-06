//
//  CommandsArguments.swift
//
//
//  Created by zhifei qiu on 2021/8/6.
//

public extension Commands {
  enum Arguments {
    case value(String)
    case elements([String])
    
    init(_ value: String) {
      self = Arguments.value(value)
    }
    
    init(_ elements: [String]) {
      self = Arguments.elements(elements)
    }
  }
}

extension Commands.Arguments {
  var raw: [String] {
    switch self {
    case .value(let value):
      return [value]
    case .elements(let elements):
      return elements
    }
  }
}

extension Commands.Arguments: Swift.ExpressibleByStringLiteral {
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

extension Commands.Arguments: Swift.ExpressibleByStringInterpolation {
  public init(stringInterpolation: DefaultStringInterpolation) {
    self.init(stringInterpolation.description)
  }
}

extension Commands.Arguments: Swift.ExpressibleByArrayLiteral {
  public init(arrayLiteral elements: String...) {
    self.init(elements)
  }
}

extension Commands.Arguments: Equatable {
  public static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.raw == rhs.raw
  }
}
