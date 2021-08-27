//
//  CommandsArguments.swift
//
//
//  Created by zhifei qiu on 2021/8/6.
//

public extension Commands {
  struct Arguments {
    public let raw: [String]
    
    public init(_ value: String) {
      self.init([value])
    }
    
    public init(_ elements: [String]) {
      raw = elements
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
