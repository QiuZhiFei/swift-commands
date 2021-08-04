//
//  CommandsResult.swift
//  
//
//  Created by zhifei qiu on 2021/8/2.
//

public extension Commands {
  enum Result {
    case Success(_ reponse: Commands.Response)
    case Failure(_ reponse: Commands.Response)
  }
}

public extension Commands.Result {
  var reponse: Commands.Response {
    switch self {
    case .Success(let response):
      return response
    case .Failure(let response):
      return response
    }
  }
  
  var statusCode: Int32 {
    return reponse.statusCode
  }
  
  var output: String {
    return reponse.output
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
