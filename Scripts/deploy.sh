#!/bin/bash

set -euxo pipefail

# test
## 1. Build and run tests, Run `swift test -v`
## 2. Validates a Pod, Run `pod lib lint --verbose`
swift test -v
pod lib lint --verbose

# deploy
## 1. Bump the version in https://github.com/QiuZhiFei/swift-commands/blob/dev/Commands.podspec#L3.
## 2. Bump the git tag and push tag to github, create a release in https://github.com/QiuZhiFei/swift-commands/tags.
## 3. Publish a cocoapods podspec, Run `pod trunk push Commands.podspec --allow-warnings --verbose`.
