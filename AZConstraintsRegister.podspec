Pod::Spec.new do |s|
  s.name             = "AZConstraintsRegister"
  s.version          = "0.1.0"
  s.summary          = "A short description of AZConstraintsRegister."
  s.description      = <<-DESC
                       An optional longer description of AZConstraintsRegister

                       * Markdown format.
                       * Don't worry about the indent, we strip it!
                       DESC
  s.homepage         = "http://EXAMPLE/NAME"
  s.screenshots      = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Aleksander Zubala" => "az@taptera.com" }
  s.source           = { :git => "http://EXAMPLE/NAME.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/NAME'

  s.platform     = :ios, '6.0'
  # s.ios.deployment_target = '5.0'  
  s.requires_arc = true
  s.source_files = 'Classes/ios/*.{h,m}'  
end
