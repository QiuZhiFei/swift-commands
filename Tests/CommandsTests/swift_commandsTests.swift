import XCTest
import Commands

final class swift_commandsTests: XCTestCase {
  func testCommandsBash() throws {
    XCTAssert(Commands.Bash.run("pwd").output == FileManager.default.currentDirectoryPath)
    
    let mktempResult = Commands.Bash.run("mktemp -d -t swift-commands")
    XCTAssert(mktempResult.isSuccess)
    let dir = mktempResult.output
    XCTAssert(dir.contains("swift-commands"))
    
    let rmDirResult = Commands.Bash.run("rm -rf \(dir)")
    XCTAssert(rmDirResult.isSuccess)
    
    let lsResult = Commands.Bash.run("ls \(dir)")
    XCTAssert(lsResult.isFailure)
    XCTAssert(lsResult.output.contains("No such file or directory"))
  }
  
  func testCommandsRuby() throws {
    let ruby = Commands.Ruby
    
    let base64Result = ruby.run("require 'base64'; puts Base64.encode64('qiuzhifei')")
    XCTAssert(base64Result.isSuccess)
    XCTAssert(base64Result.output == "qiuzhifei".data(using: .utf8)!.base64EncodedString())
    XCTAssert(base64Result.output == "cWl1emhpZmVp")
    
    XCTAssert(ruby.run("import 'qiuzhifei'").isFailure)
  }
  
  func testCommandsPython() throws {
    let python = Commands.Python
    
    let base64Result = python.run("import base64; print(base64.b64encode('qiuzhifei').decode('ascii'))")
    XCTAssert(base64Result.isSuccess)
    XCTAssert(base64Result.output == "qiuzhifei".data(using: .utf8)!.base64EncodedString())
    XCTAssert(base64Result.output == "cWl1emhpZmVp")
    
    XCTAssert(python.run("import qiuzhifei").isFailure)
  }
  
  func testCommandsNode() throws {
    let node = Commands.Node
    
    let base64Result = node.run("console.log(Buffer.from('qiuzhifei').toString('base64'))")
    debugPrint(base64Result)
    XCTAssert(base64Result.isSuccess)
    XCTAssert(base64Result.output == "qiuzhifei".data(using: .utf8)!.base64EncodedString())
    XCTAssert(base64Result.output == "cWl1emhpZmVp")
    
    XCTAssert(node.run("import qiuzhifei").isFailure)
  }
  
  func testCommandsCustom() throws {
    let python = Commands.Alias("python", dashc: "-c")
    let pythonLogResult = python.run("print('qiuzhifei')")
    XCTAssert(pythonLogResult.isSuccess)
    XCTAssert(pythonLogResult.output == "qiuzhifei")
    
    let node = Commands.Alias("node1", dashc: "-e")
    let nodeLogResult = node.run("console.log('qiuzhifei')")
    XCTAssert(nodeLogResult.isFailure)
  }
  
  func testCommandsENV() throws {
    let bashDebugResult = Commands.Bash.run("echo $commands_debug")
    XCTAssert(bashDebugResult.isSuccess)
    XCTAssert(bashDebugResult.output == "")
    
    var env = Commands.ENV()
    env["commands_debug"] = "1"
    let bashDebugENVResult = Commands.Bash.run("echo $commands_debug", environment: env)
    XCTAssert(bashDebugENVResult.isSuccess)
    XCTAssert(bashDebugENVResult.output == "1")
  }
  
  func testCommansAlias() throws {
    // bash
    XCTAssertEqual(
      Commands.Bash.run("ls"),
      Commands.Task.run("bash -c ls")
    )
    
    // ruby
    XCTAssertEqual(
      Commands.Ruby.run("require 'base64'; puts Base64.encode64('qiuzhifei')"),
      Commands.Task.run("ruby -e require 'base64'; puts Base64.encode64('qiuzhifei')")
    )
    
    // python
    XCTAssertEqual(
      Commands.Python.run("import base64; print(base64.b64encode('qiuzhifei').decode('ascii'))"),
      Commands.Task.run("python -c import base64; print(base64.b64encode('qiuzhifei').decode('ascii'))")
    )
    
    // node
    XCTAssertEqual(
      Commands.Node.run("console.log(Buffer.from('qiuzhifei').toString('base64'))"),
      Commands.Task.run("node -e console.log(Buffer.from('qiuzhifei').toString('base64'))")
    )
  }
  
  func testCommansTask() throws {
    XCTAssert(Commands.Task.run([]).isFailure)
    
    XCTAssert(Commands.Task.run("bash -c pwd").output == FileManager.default.currentDirectoryPath)
    
    let path = Bundle.module.path(forResource: "main", ofType: "py")!
    let pythonResult = Commands.Task.run("python \(path)")
    XCTAssert(pythonResult.isSuccess)
    XCTAssert(pythonResult.output == "cWl1emhpZmVp")
  }
}
