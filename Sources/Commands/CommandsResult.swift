//
//  CommandsResult.swift
//
//
//  Created by zhifei qiu on 2021/8/2.
//

import Foundation

public extension Commands {
  enum Result {
    case Success(_ request: Request, reponse: Response)
    case Failure(_ request: Request, reponse: Response)
  }
}

public extension Commands.Result {
  var request: Commands.Request {
    switch self {
    case .Success(let request, _):
      return request
    case .Failure(let request, _):
      return request
    }
  }
  
  var reponse: Commands.Response {
    switch self {
    case .Success(_, let response):
      return response
    case .Failure(_, let response):
      return response
    }
  }
  
  var statusCode: Int32 {
    return reponse.statusCode
  }
  
  var output: String {
    return reponse.output
  }
  
  var errorOutput: String {
    return reponse.errorOutput
  }
}

public extension Commands.Result {
  var isSuccess: Bool {
    switch self {
    case .Success(_, _):
      return true
    default:
      return false
    }
  }
  
  var isFailure: Bool {
    !isSuccess
  }
}

extension Commands.Result: Equatable {
  public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.request == rhs.request
      && lhs.reponse == rhs.reponse
  }
}
