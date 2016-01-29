//
//  ViewController.swift
//  Demo
//
//  Created by caowenbo on 16/1/29.
//  Copyright © 2016年 曹文博. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func success(sender: AnyObject) {

        WBStatusBarHUD.showSuccess()
    }
    
    @IBAction func fail(sender: AnyObject) {
        WBStatusBarHUD.showError()
    }

    @IBAction func loading(sender: AnyObject) {
        WBStatusBarHUD.showLoading()
    }
    
    @IBAction func hide(sender: AnyObject) {
        WBStatusBarHUD.hide()
    }


    @IBAction func test(sender: AnyObject) {
        WBStatusBarHUD.show("Hello World")
    }

}

