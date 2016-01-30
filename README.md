# WBStatusBarHUD
An easy colorful gradient statusBar indicator

![demo](http://7xpk2w.com1.z0.glb.clouddn.com/11.gif)

# Integration
You can use Cocoapods to install WBRefresh adding it to your Podfile:

```
platform :ios, '8.0'  
use_frameworks!  

pod 'WBRefresh'

end
```

# Usage

``` swift
 WBStatusBarHUD.setWindow(UIColor.cyanColor())
 
 WBStatusBarHUD.showSuccess()
 
 WBStatusBarHUD.showError()
 
 WBStatusBarHUD.showLoading()
 
 WBStatusBarHUD.hide()
 
 WBStatusBarHUD.show(<#T##message: String##String#>, image: <#T##UIImage?#>)
 
```
