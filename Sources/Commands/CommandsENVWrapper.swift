//
//  CommandsENVWrapper.swift
//  
//
//  Created by zhifei qiu on 2021/8/3.
//

import Foundation

// MARK: - Custom

public extension Commands {
  struct CustomENV: CommandsENV {
    public var executableURL: String
    public var dashc: String
    
    init(_ executableURL: String, dashc: String) {
      self.executableURL = executableURL
      self.dashc = dashc
    }
  }
}

// MARK: - Bash

public extension Commands {
  struct BashENV: CommandsENV {
    public var executableURL: String = "/bin/bash"
    public var dashc: String = "-c"
  }
}

// MARK: - Ruby

public extension Commands {
  struct RubyENV: CommandsENV {
    public var executableURL: String = {
      return Bash.run("which ruby").output
    }()
    public var dashc: String = "-e"
  }
}

// MARK: - Python

public extension Commands {
  struct PythonENV: CommandsENV {
    public var executableURL: String = {
      return Bash.run("which python").output
    }()
    public var dashc: String = "-c"
  }
}
