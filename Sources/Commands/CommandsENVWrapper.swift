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
      let ruby = Bash.run("which ruby").output
      return ruby
    }()
    public var dashc: String = "-e"
  }
}

// MARK: - Python

public extension Commands {
  struct PythonENV: CommandsENV {
    public var executableURL: String = {
      let python = Bash.run("which python").output
      return python
    }()
    public var dashc: String = "-c"
  }
}
