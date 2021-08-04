# Swift Commands
![SPM](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)
![CocoaPods](https://img.shields.io/cocoapods/v/Commands.svg)
[![CI Status](https://img.shields.io/github/workflow/status/qiuzhifei/swift-commands/Swift)](https://github.com/qiuzhifei/swift-commands/actions)
[![License](https://img.shields.io/github/license/qiuzhifei/swift-commands)](https://github.com/qiuzhifei/swift-commands/blob/main/LICENSE)
![Platform](https://img.shields.io/badge/platforms-macOS%2010.9-orange)

Swift utilities for running commands.

The `Commands` module allows you to take a system command as a string and return the standard output.

## Usage
```
import Commands
```

### Bash
Executes command in a subprocess.
```
Commands.Bash.system("ls")
```

Returns the `Commands.Result` of running cmd in a subprocess.
```
let lsResult = Commands.Bash.run("ls")
switch lsResult {
case .Success(let output):
  debugPrint("success output: \(output)")
case .Failure(let code, let output):
  debugPrint("failure code: \(code), output: \(output)")
}
```
### Python
Executes command in a subprocess.
```swift
Commands.Python.system("import base64; print(base64.b64encode('qiuzhifei').decode('ascii'))")
```
### Ruby
Executes command in a subprocess.
```swift
Commands.Ruby.system("require 'base64'; puts Base64.encode64('qiuzhifei')")
```

### Custom
Executes command in a subprocess.
```swift
let node = Commands.Custom("/usr/local/bin/node", dashc: "-e")
node.system("console.log('qiuzhifei')")
```

## Adding Commands as a Dependency
To use the `Commands` library in a SwiftPM project, 
add the following line to the dependencies in your `Package.swift` file:

```swift
let package = Package(
    // name, platforms, products, etc.
    dependencies: [
        .package(url: "https://github.com/qiuzhifei/swift-commands", from: "0.2.0"),
        // other dependencies
    ],
    targets: [
        .target(name: "<command-line-tool>", dependencies: [
            .product(name: "Commands", package: "swift-commands"),
        ]),
        // other targets
    ]
)
```

## CocoaPods (OS X 10.9+)
You can use [CocoaPods](http://cocoapods.org/) to install `Commands` by adding it to your `Podfile`:
```ruby
pod 'Commands',        '~> 0.2.0'
```

## References
- [https://github.com/apple/swift-argument-parser](https://github.com/apple/swift-argument-parser)
