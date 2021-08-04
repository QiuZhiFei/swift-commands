//
//  main.swift
//  
//
//  Created by zhifei qiu on 2021/8/4.
//

import Commands

extension Commands.Result {
  func log() {
    let request = self.reponse.request
    print(">>> \(request.executableURL) \(request.dashc) \(request.command)")
    print("\(self.reponse.output)")
  }
}

// MARK: - Bash
Commands.Bash.run("ls /bin/ls").log()

// MARK: - Ruby
Commands.Ruby.run("require 'base64'; puts Base64.encode64('qiuzhifei')").log()

// MARK: - Python
Commands.Python.run("import base64; print(base64.b64encode('qiuzhifei').decode('ascii'))").log()

// MARK: - Custom
let nodeResult = Commands.Bash.run("which node")
if nodeResult.isSuccess {
  let node = Commands.Custom(nodeResult.output, dashc: "-e")
  node.run("console.log('qiuzhifei')").log()
}