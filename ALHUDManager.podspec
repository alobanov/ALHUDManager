Pod::Spec.new do |s|

  s.name         = "ALHUDManager"
  s.version      = "1.0.0"
  s.summary      = "Manager for localizable strings"
  s.homepage     = "https://github.com/alobanov/ALHUDManager"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Alexey Lobanov" => "lobanov.aw@gmail.com" }
  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/alobanov/ALHUDManager.git" }
  s.source_files = "ALHUDManager/*.{h,m}"
  s.public_header_files = "ALHUDManager/*.{h}"
  s.framework    = "UIKit"
  s.requires_arc = true
  s.resources    = 'ALHUDManager/ALHUDIconsResourse.bundle'
  
  s.dependency 'MBProgressHUD'

end
