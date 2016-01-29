Pod::Spec.new do |s|
    s.name         = 'WBStatusBarHUD'
    s.version      = '0.0.1'
    s.summary      = 'An easy statusBar indicator'
    s.homepage     = 'https://github.com/chatwyn/WBStatusBarHUD'
    s.license      = 'MIT'
    s.authors      = {'chatwyn' => 'chatwyn0217@gmail.com'}
    s.platform     = :ios, '8.0'
    s.source       = {:git => 'https://github.com/chatwyn/WBStatusBarHUD.git', :tag => s.version}
    s.source_files = 'WBStatusBarHUD/*.swift'
    s.resource     = 'WBStatusBarHUD/WBStatusBarHUD.bundle'
    s.frameworks   = 'UIKit'
    s.module_name  = 'WBStatusBarHUD'
    s.requires_arc = true
end
