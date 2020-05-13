#
# Be sure to run `pod lib lint YYYNavigationController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name         = 'YYYNavigationController'
  s.version      = '1.1.1'
  s.summary      = 'YYYNavigationController'

  s.description  = <<-DESC
                    YYYNavigationController 类似淘宝、京东的“整体返回”效果，可以自定义各个界面导航栏的颜色，背景图等，互不影响。
                   DESC

  s.homepage         = 'https://github.com/276523923/YYYNavigationController.git'
  s.license          = { :type => "GNU GENERAL PUBLIC LICENSE", :file => "LICENSE" }
  s.author           = { '276523923@qq.com' => '276523923@qq.com' }

  s.source       = { :git => 'https://github.com/276523923/YYYNavigationController.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.requires_arc = true

  # s.static_framework = true

  s.source_files  = "YYYNavigationController/Classes/**/*.{h,m}"
  s.public_header_files = "YYYNavigationController/Classes/**/*.h"

  # s.resources = "YYYNavigationController/Assets/**/*"
  # ss.resource_bundles = {
  #   YYYNavigationController => ["YYYNavigationController/Assets/**/*"]
  # }

  # s.dependency ""
end
