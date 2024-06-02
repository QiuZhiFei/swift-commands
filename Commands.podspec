Pod::Spec.new do |s|
  s.name        = "Commands"
  s.version     = "0.6.0"
  s.summary     = "Swift utilities for running commands."
  s.homepage    = "https://github.com/qiuzhifei/swift-commands"
  s.license     = { :type => "MIT" }
  s.authors     = { "lingoer" => "qiuzhifei521@gmail.com", "tangplin" => "qiuzhifei521@gmail.com" }

  s.requires_arc = true
  s.swift_versions = ['5.1', '5.2', '5.3']
  s.osx.deployment_target = "11.0"
  s.source   = { :git => "https://github.com/qiuzhifei/swift-commands.git", :tag => s.version }
  s.source_files = "Sources/*/*.swift"
end
