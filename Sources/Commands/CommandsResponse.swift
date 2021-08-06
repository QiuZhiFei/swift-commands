//
//  CommandsResponse.swift
//  
//
//  Created by zhifei qiu on 2021/8/25.
//

import Foundation

extension Commands {
  public struct Response {
    public let statusCode: Int32
    public let output: String
    public let errorOutput: String
  }
}

extension Commands.Response: Equatable {
  public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.statusCode == rhs.statusCode
      && lhs.output == rhs.output
      && lhs.errorOutput == rhs.errorOutput
  }
}
