# Swift Commands
![SPM](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)
![CocoaPods](https://img.shields.io/cocoapods/v/Commands.svg)
[![CI Status](https://img.shields.io/github/workflow/status/qiuzhifei/swift-commands/Swift)](https://github.com/qiuzhifei/swift-commands/actions)
[![License](https://img.shields.io/github/license/qiuzhifei/swift-commands)](https://github.com/qiuzhifei/swift-commands/blob/main/LICENSE)
![Platform](https://img.shields.io/badge/platforms-macOS%2010.9-orange)

Swift utilities for running commands.

The `Commands` module allows you to take a system command as a string and return the standard output.

[API documentation can be found here](https://qiuzhifei.github.io/swift-commands/).

## Usage
```
import Commands
```

### Bash
Execute shell commands.
```swift
let result = Commands.Task.run("bash -c ls")
```
Or
```swift
let result = Commands.Task.run(["bash", "-c", "ls"])
```
Or
```swift
let result = Commands.Bash.run("ls")
```

### Python
Execute python scripts.
```swift
let result = Commands.Task.run("python main.py")
```
Execute python commands.
```swift
let result = Commands.Task.run("python -c import base64; print(base64.b64encode('qiuzhifei').decode('ascii'))")
```
Or
```swift
let result = Commands.Python.run("import base64; print(base64.b64encode('qiuzhifei').decode('ascii'))")
```

### Ruby
Execute ruby scripts.
```swift
let result = Commands.Task.run("ruby main.rb")
```
Execute ruby commands.
```swift
let result = Commands.Task.run("ruby -e require 'base64'; puts Base64.encode64('qiuzhifei')")
```
Or
```swift
let result = Commands.Ruby.run("require 'base64'; puts Base64.encode64('qiuzhifei')")
```

### Alias
Create a shortcut name for a command.
```swift
let node = Commands.Alias("/usr/local/bin/node", dashc: "-e")
let result = node.run("console.log('qiuzhifei')")
```

### Setting global environment variables
```swift
Commands.ENV.global["http_proxy"] = "http://127.0.0.1:7890"
```
```swift
Commands.ENV.global.add(PATH: "/Users/zhifeiqiu/.rvm/bin")
```

### Making Commands
```swift
let request: Commands.Request = "ruby -v"
```
Or
```swift
let request: Commands.Request = ["ruby", "-v"]
```
Or
```swift
let request = Commands.Request(executableURL: "ruby", arguments: "-v")
```
Change environment variables
```swift
var request: Commands.Request = "ruby -v"
request.environment?.add(PATH: "/usr/local/bin")
request.environment?["http_proxy"] = "http://127.0.0.1:7890"
request.environment?["https_proxy"] = "http://127.0.0.1:7890"
request.environment?["all_proxy"] = "socks5://127.0.0.1:7890"

let result = Commands.Task.run(request)
```

### Result Handler
Returns the `Commands.Result` of running cmd in a subprocess.
```swift
let result = Commands.Task.run("ruby -v")
switch result {
case .Success(let request, let response):
  debugPrint("command: \(request.absoluteCommand), success output: \(response.output)")
case .Failure(let request, let response):
  debugPrint("command: \(request.absoluteCommand), failure output: \(response.errorOutput)")
}
```

## Adding Commands as a Dependency
To use the `Commands` library in a SwiftPM project, 
add the following line to the dependencies in your `Package.swift` file:

```swift
let package = Package(
    // name, platforms, products, etc.
    dependencies: [
        .package(url: "https://github.com/qiuzhifei/swift-commands", from: "0.6.0"),
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
pod 'Commands',        '~> 0.6.0'
```

## QuickStart
```shell
git clone https://github.com/QiuZhiFei/swift-commands
cd swift-commands && open Package.swift
```

## References
- [https://github.com/apple/swift-argument-parser](https://github.com/apple/swift-argument-parser)
