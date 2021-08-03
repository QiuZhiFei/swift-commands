//
//  Commands.swift
//  
//
//  Created by zhifei qiu on 2021/8/2.
//

public enum Commands { }

public extension Commands {
  static let Bash = BashENV()
  
  static let Ruby = RubyENV()
  
  static let Python = PythonENV()
  
  static func Custom(_ executableURL: String, dashc: String) -> CustomENV {
    return CustomENV(executableURL, dashc: dashc)
  }
}
