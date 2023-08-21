Pod::Spec.new do |s|
  s.name             = 'ContextMenuSDK'
  s.version          = '0.1.6'
  s.summary          = 'Contextmenu for UI elements'
  s.homepage         = 'https://github.com/dev-lis/ContextMenuSDK'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Aleksandr Lis' => 'mr.aleksandr.lis@gmail.com' }
  s.source           = { :git => 'https://github.com/dev-lis/ContextMenuSDK.git', :tag => s.version }
  s.ios.deployment_target = '13.0'
  s.swift_version = '5.0'
  s.source_files = 'ContextMenuSDK/Source/**/*'
  s.frameworks = 'UIKit'
end
