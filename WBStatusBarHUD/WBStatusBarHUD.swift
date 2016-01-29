//
//  WBStatusBarHUD.swift
//  WBStatusBarHUD
//
//  Created by caowenbo on 16/1/28.
//  Copyright © 2016年 曹文博. All rights reserved.
//

import UIKit

/// window背景
private var window:UIWindow?
/// 渐变色layer
private var gradientLayer = CAGradientLayer.init()
/// 字迹动画的时间
private let textAnimationTime:NSTimeInterval = 2
/// 字迹图层
private let pathLayer = CAShapeLayer.init()
/// 背景颜色
private var windowBgColor = UIColor.blackColor()
/// window弹出时间
private let windowTime:NSTimeInterval = 0.25
// 定时器
private var timer:NSTimer?

public class WBStatusBarHUD {
    
    
    /**
     在statusBar显示一段提示
     
     - parameter message: 提示的文字
     - parameter image:   文字前边的小图
     */
    public class func show(message:String,image:UIImage?=nil) {
        
        // 显示window
        showWindow()
        // 添加渐变色layer以及动画
        addGradientLayer()
        // 添加文字动画
        addPathLayer(message)
        //添加gradientLayer的遮罩
        gradientLayer.mask = pathLayer
        
        if let image = image {
            let imageView = UIImageView.init(image: image)
            imageView.frame = CGRect(x: CGRectGetMinX(pathLayer.frame) - 5 - imageView.image!.size.width, y: 0, width: imageView.image!.size.width, height: imageView.image!.size.height)
            imageView.center.y = window!.center.y
            window?.addSubview(imageView)
        }
        
    }
    
    /**
     隐藏
     */
    public class func hide() {
        
        timer?.invalidate()
        timer = nil
        
        if window != nil {
            
            UIView.animateWithDuration(windowTime, animations: { () -> Void in
                window?.center.y -= 20
                }, completion: { (bool:Bool) -> Void in
                    window = nil
                    pathLayer.removeAllAnimations()
                    gradientLayer.removeAllAnimations()
            })
        }
    }
    
    
    /**
     showErrorWithText
     
     - parameter msg: default is download fail
     */
    public class func showError(msg:String?=nil) {
        
        let image = UIImage.init(named:"WBStatusBarHUD.bundle/error")
        
        show((msg ?? "download fail"),image: image)
        
    }
    
    /**
     showLoadingWithText
     
     - parameter msg: default is loading……
     */
    public class func showLoading(msg:String?=nil) {
        show(msg ?? "loading……", image: nil)
        timer?.invalidate()
        
        let activityIndicatorView = UIActivityIndicatorView.init(activityIndicatorStyle: .White)
        activityIndicatorView.startAnimating()
        activityIndicatorView.frame = CGRect(x: CGRectGetMinX(pathLayer.frame) - 5 - activityIndicatorView.frame.size.width, y: 0, width: activityIndicatorView.frame.size.width, height: activityIndicatorView.frame.size.height)
        window?.addSubview(activityIndicatorView)
        
    }
    /**
     showSuccessWithText
     
     - parameter msg: default is download complete
     */
    public class func showSuccess(msg:String?=nil) {
        let image = UIImage.init(named:"WBStatusBarHUD.bundle/success")
        show(msg ?? "download successful", image: image)
    }
    
    /**
     setWindowBackGroundColor
     
     - parameter color: default is black color
     */
    public class func setWindow(color:UIColor) {
        windowBgColor = color
        window?.backgroundColor = color
    }
    
    // MARK: - private method
    /**
    显示窗口
    */
    private class func showWindow() {
        
        timer?.invalidate()
        timer = nil
        
        window = UIWindow.init()
        pathLayer.removeAllAnimations()
        window!.windowLevel = UIWindowLevelAlert
        window!.backgroundColor = windowBgColor
        window!.frame = CGRectMake(0, -20,UIScreen.mainScreen().bounds.size.width, 20)
        window!.hidden = false
        
        UIView.animateWithDuration(windowTime) { () -> Void in
            window!.center.y += 20
        }
        
        //这样写是不对的  不知为何 OC中没事
        //        timer = NSTimer.scheduledTimerWithTimeInterval(textAnimationTime, target:self, selector: "hide", userInfo: nil, repeats: false)
        
        timer = NSTimer.scheduledTimerWithTimeInterval(textAnimationTime + 1, target:window!, selector: "hide", userInfo: nil, repeats: false)
        
    }
    
    /**
     添加渐变色的layer 和动画
     */
    private class func addGradientLayer() {
        
        // 渐变色的颜色数
        let count = 10
        var colors:[CGColorRef] = []
        
        for var i = 0; i < count; i++ {
            let color = UIColor.init(red: CGFloat(arc4random() % 256) / 255, green: CGFloat(arc4random() % 256) / 255, blue: CGFloat(arc4random() % 256) / 255, alpha: 1.0)
            
            colors.append(color.CGColor)
        }
        
        // 渐变色的方向
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        gradientLayer.colors = colors
        gradientLayer.frame = window!.bounds
        gradientLayer.type = kCAGradientLayerAxial
        
        window!.layer.addSublayer(gradientLayer)
        
        // 渐变色的动画
        let animation = CABasicAnimation.init(keyPath: "colors")
        animation.duration = 0.5
        animation.repeatCount = MAXFLOAT
        
        var toColors:[CGColorRef] = []
        
        for var i = 0; i < count; i++ {
            let color = UIColor.init(red: CGFloat(arc4random() % 256) / 255, green: CGFloat(arc4random() % 256) / 255, blue: CGFloat(arc4random() % 256) / 255, alpha: 1.0)
            
            toColors.append(color.CGColor)
        }
        animation.autoreverses = true
        animation.toValue = toColors
        gradientLayer.addAnimation(animation, forKey: "gradientLayer")
    }
    
    
    /**
     添加笔迹的动画
     
     - parameter message: 显示的文字
     */
    private class func addPathLayer(message:String) {
        
        
        let textPath = bezierPathFrom(message)
        
        pathLayer.bounds = CGPathGetBoundingBox(textPath.CGPath)
        pathLayer.position = window!.center
        pathLayer.geometryFlipped = true
        pathLayer.path = textPath.CGPath
        pathLayer.fillColor = nil
        pathLayer.lineWidth = 1
        pathLayer.strokeColor = UIColor.whiteColor().CGColor
        
        // 笔迹的动画
        let textAnimation = CABasicAnimation.init(keyPath: "strokeEnd")
        textAnimation.duration = textAnimationTime
        textAnimation.fromValue = 0
        textAnimation.toValue = 1
        textAnimation.delegate = window
        pathLayer.addAnimation(textAnimation, forKey: "strokeEnd")
        
    }
    
    /**
     将字符串转变成贝塞尔曲线
     */
    class func bezierPathFrom(string:String) -> UIBezierPath{
        
        let paths = CGPathCreateMutable()
        let fontName = __CFStringMakeConstantString("SnellRoundhand")
        let fontRef:AnyObject = CTFontCreateWithName(fontName, 18, nil)
        
        let attrString = NSAttributedString(string: string, attributes: [kCTFontAttributeName as String : fontRef])
        let line = CTLineCreateWithAttributedString(attrString as CFAttributedString)
        let runA = CTLineGetGlyphRuns(line)
        
        
        for (var runIndex = 0; runIndex < CFArrayGetCount(runA); runIndex++){
            let run = CFArrayGetValueAtIndex(runA, runIndex);
            let runb = unsafeBitCast(run, CTRun.self)
            
            let  CTFontName = unsafeBitCast(kCTFontAttributeName, UnsafePointer<Void>.self)
            
            let runFontC = CFDictionaryGetValue(CTRunGetAttributes(runb),CTFontName)
            let runFontS = unsafeBitCast(runFontC, CTFont.self)
            
            let width = UIScreen.mainScreen().bounds.width
            
            var temp = 0
            var offset:CGFloat = 0.0
            
            for(var i = 0; i < CTRunGetGlyphCount(runb); i++){
                let range = CFRangeMake(i, 1)
                let glyph:UnsafeMutablePointer<CGGlyph> = UnsafeMutablePointer<CGGlyph>.alloc(1)
                glyph.initialize(0)
                let position:UnsafeMutablePointer<CGPoint> = UnsafeMutablePointer<CGPoint>.alloc(1)
                position.initialize(CGPointZero)
                CTRunGetGlyphs(runb, range, glyph)
                CTRunGetPositions(runb, range, position);
                
                let temp3 = CGFloat(position.memory.x)
                let temp2 = (Int) (temp3 / width)
                let temp1 = 0
                if(temp2 > temp1){
                    
                    temp = temp2
                    offset = position.memory.x - (CGFloat(temp) * width)
                }
                let path = CTFontCreatePathForGlyph(runFontS,glyph.memory,nil)
                let x = position.memory.x - (CGFloat(temp) * width) - offset
                let y = position.memory.y - (CGFloat(temp) * 80)
                var transform = CGAffineTransformMakeTranslation(x, y)
                CGPathAddPath(paths, &transform, path)
                glyph.destroy()
                glyph.dealloc(1)
                position.destroy()
                position.dealloc(1)
            }
            
        }
        
        let bezierPath = UIBezierPath()
        bezierPath.moveToPoint(CGPointZero)
        bezierPath.appendPath(UIBezierPath(CGPath: paths))
        
        return bezierPath
    }
    
}

extension UIWindow{
    
    func hide() {
        WBStatusBarHUD.hide()
    }
}