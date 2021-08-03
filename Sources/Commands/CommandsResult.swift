//
//  CommandsResult.swift
//  
//
//  Created by zhifei qiu on 2021/8/2.
//

public extension Commands {
  enum Result {
    case Success(output: String)
    case Failure(code: Int32, output: String)
  }
}

public extension Commands.Result {
  var output: String {
    switch self {
    case .Success(let output):
      return output
    case .Failure(_, let output):
      return output
    }
  }
}

public extension Commands.Result {
  var isSuccess: Bool {
    switch self {
    case .Success(_):
      return true
    default:
      return false
    }
  }
  
  var isFailure: Bool {
    !isSuccess
  }
}
