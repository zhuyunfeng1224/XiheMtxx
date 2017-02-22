//
//  ViewController.swift
//  EasyCard
//
//  Created by echo on 2017/2/14.
//  Copyright © 2017年 羲和. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let button: UIButton = {
        let newValue = UIButton(frame: CGRect(x: 100, y: 200, width: 200, height: 200))
        newValue.setTitle("添加", for: .normal)
        newValue.setTitleColor(UIColor.gray, for: .normal)
        newValue.addTarget(self, action: #selector(startCreateCard), for: .touchUpInside)
        return newValue
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.button)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func startCreateCard() -> Void {
//        let mainVC = MainViewController()
//        let mainNavigationVC = MainNavigationViewController(rootViewController: mainVC)
//        self.present(mainNavigationVC, animated: true) { 
//            
//        }
        
        let albumVC = PhotoAlbumViewController()
        let mainNavigationVC = MainNavigationViewController(rootViewController: albumVC)
        self.present(mainNavigationVC, animated: true) {
            
        }
    }
}

