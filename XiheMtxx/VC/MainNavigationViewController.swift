//
//  MainNavigationViewController.swift
//  EasyCard
//
//  Created by echo on 2017/2/14.
//  Copyright © 2017年 羲和. All rights reserved.
//

import UIKit

class MainNavigationViewController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.barTintColor = UIColor.colorWithHexString(hex: "#2c2e30")
        self.navigationBar.backgroundColor = UIColor.colorWithHexString(hex: "#2c2e30")
        self.navigationBar.barTintColor = UIColor.white
        self.navigationBar.backgroundColor = UIColor.white
        self.navigationBar.tintColor = UIColor.colorWithHexString(hex: "#2c2e30")
        self.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 17), NSForegroundColorAttributeName: UIColor.colorWithHexString(hex: "#333333")]
        self.navigationBar.backIndicatorImage = UIImage(named:"btn_back_arrow_25x25_")
        self.navigationBar.backIndicatorTransitionMaskImage = UIImage(named:"btn_back_arrow_25x25_")
        
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 13), NSForegroundColorAttributeName: UIColor.colorWithHexString(hex: "#333333")], for: .normal)
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: 3, vertical: -3), for: .default)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
