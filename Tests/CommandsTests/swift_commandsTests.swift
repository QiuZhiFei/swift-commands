import XCTest
import Commands

final class swift_commandsTests: XCTestCase {
  func testBashCommands() throws {
    XCTAssert(Commands.Bash.executableURL == "/bin/bash")
    XCTAssert(Commands.Bash.dashc == "-c")
    
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
  
  func testRubyCommands() throws {
    let ruby = Commands.Ruby
    
    let base64Result = ruby.run("require 'base64'; puts Base64.encode64('qiuzhifei')")
    XCTAssert(base64Result.isSuccess)
    XCTAssert(base64Result.output == "qiuzhifei".data(using: .utf8)!.base64EncodedString())
    XCTAssert(base64Result.output == "cWl1emhpZmVp")
    
    XCTAssert(ruby.run("import 'qiuzhifei'").isFailure)
  }
  
  func testPythonCommands() throws {
    let python = Commands.Python
    
    let base64Result = python.run("import base64; print(base64.b64encode('qiuzhifei').decode('ascii'))")
    XCTAssert(base64Result.isSuccess)
    XCTAssert(base64Result.output == "qiuzhifei".data(using: .utf8)!.base64EncodedString())
    XCTAssert(base64Result.output == "cWl1emhpZmVp")
    
    XCTAssert(python.run("import qiuzhifei").isFailure)
  }
  
  func testCustomCommands() throws {
    let bash = Commands.Custom("/bin/bash", dashc: "-c")
    
    let bashDebugResult = bash.run("echo $commands_debug")
    XCTAssert(bashDebugResult.isSuccess)
    XCTAssert(bashDebugResult.output == "")
    
    let bashDebugENVResult = bash.run("echo $commands_debug", environment: ["commands_debug": "1"])
    XCTAssert(bashDebugENVResult.isSuccess)
    XCTAssert(bashDebugENVResult.output == "1")
    
    let node = Commands.Custom("/usr/local/bin/node1", dashc: "-e")
    let nodeLogResult = node.run("console.log('qiuzhifei')")
    XCTAssert(nodeLogResult.isFailure)
  }
}
