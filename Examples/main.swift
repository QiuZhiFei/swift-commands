//
//  main.swift
//  
//
//  Created by zhifei qiu on 2021/8/4.
//

import Commands

fileprivate extension Commands.Result {
  func log() {
    print("---------------")
    print(">>> \(request.absoluteCommand)")
    print("\(self.response.output)")
    print("---------------")
  }
}

// Bash
Commands.Bash.run("ls /bin/ls").log()

// Ruby
Commands.Ruby.run("require 'base64'; puts Base64.encode64('qiuzhifei')").log()

// Python
Commands.Python.run("import base64; print(base64.b64encode('qiuzhifei').decode('ascii'))").log()

// Custom
let node = Commands.Alias("node", dashc: "-e")
node.run("console.log('qiuzhifei')").log()

// Task
Commands.Task.run("bash -c pwd").log()
Commands.Task.run("python main.py").log()
Commands.Task.run("ruby -v").log()
