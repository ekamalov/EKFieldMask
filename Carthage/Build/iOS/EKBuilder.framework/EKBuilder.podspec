Pod::Spec.new do |s|
    s.name          = "EKBuilder"
    s.version       = "1.0.2"
    s.summary       = "The super easy and generic builder pattern"
    s.homepage      = "https://github.com/erikkamalov/EKBuilder"
    s.source        = { :git => "https://github.com/erikkamalov/EKBuilder.git", :tag => s.version }
    s.license       = { :type => "MIT", :file => "LICENSE" }

    s.author        = { "Erik Kamalov" => "ekamalov967@gmail.com" }

    s.swift_version = "5.0"
    s.platform      = :ios
    s.ios.deployment_target = "12.0"

    s.source_files  = "Source/EKBuilder/*.swift"
end

