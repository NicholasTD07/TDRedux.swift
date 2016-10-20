Pod::Spec.new do |s|
  s.name         = "TDRedux.swift"
  s.version      = "1.6.0"
  s.summary      = "Yet another Redux written in Swift"

  s.description  = <<-DESC
    TDRedux.swift is a micro framework which helps you build
    apps with the Redux architecture.
    I wrote it because it is fun and easy to write your own Redux.
                   DESC

  s.homepage     = "https://github.com/NicholasTD07/TDRedux.swift"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "NicholasTD07" => "Nicholas.TD07@gmail.com" }
  s.social_media_url   = "https://twitter.com/NicholasTD07"

  s.module_name = "TDRedux"
  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.9"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target = "9.0"

  s.source       = {
      :git => "https://github.com/NicholasTD07/TDRedux.swift.git",
      :tag => "#{s.version}"
  }

  s.source_files  = "Sources", "Sources/**/*.{h,m}"
  s.requires_arc = true
end
