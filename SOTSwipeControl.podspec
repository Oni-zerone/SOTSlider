Pod::Spec.new do |s|
  s.name             = 'SOTSwipeControl'
  s.version          = '1.2.0'
  s.summary          = 'A simple control to swipe.'
  s.description      = <<-DESC
  A simple and customizable control who permits you to enable two swipe actions one from the left and one from the right. 
                       DESC

  s.homepage         = 'https://github.com/Oni-zerone/SwipeControl'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Oni_01' => 'oni.zerone@gmail.com' }
  s.source           = { :git => 'https://github.com/Oni-zerone/SwipeControl.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/oni_zerone'
  s.platform = :ios, "10.0"
  s.ios.deployment_target = '8.0'

  s.source_files = 'SOTSwipeControl/Classes/**/*'
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3' }
end
