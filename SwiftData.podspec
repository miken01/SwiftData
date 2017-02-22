#
#  Be sure to run `pod spec lint SwiftData.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name                    = "SwiftData"
  s.version                 = "1.0.6"
  s.summary                 = "SwiftData is a collection of useful classes, categories and wrappers that make iOS development easier and more efficient."
  s.description             = <<-DESC
'SwiftData' is a lightweight wrapper for CoreData. This framework simplifies the CoreData bootstraping process and provides useful utilities to help make working with CoreData more enjoyable.
                   DESC
  s.homepage                = "https://github.com/miken01/SwiftData"
  s.license                 = "MIT"
  s.author                  = { "Mike Neill" => "michael_neill@me.com" }
  s.platform                = :ios, "9.3"
  s.source                  = { :git => "https://github.com/miken01/SwiftData.git", :tag => "1.0.6" }
  s.public_header_files     = "SwiftData/**/*.h"
  s.source_files            = "SwiftData/**/*.{h,m,swift}"
  s.requires_arc            = true
  s.ios.deployment_target   = '9.3'
  s.ios.frameworks          = 'CoreData', 'Foundation'
end