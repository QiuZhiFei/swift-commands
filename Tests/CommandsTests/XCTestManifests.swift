#if !canImport(ObjectiveC)
import XCTest

extension swift_commandsTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__swift_commandsTests = [
        ("testCommandsBash", testCommandsBash),
        ("testCommandsCustom", testCommandsCustom),
        ("testCommandsENV", testCommandsENV),
        ("testCommandsNode", testCommandsNode),
        ("testCommandsPython", testCommandsPython),
        ("testCommandsRuby", testCommandsRuby),
        ("testCommansAlias", testCommansAlias),
        ("testCommansTask", testCommansTask),
    ]
}

public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(swift_commandsTests.__allTests__swift_commandsTests),
    ]
}
#endif