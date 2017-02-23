//
//  PhotoBaseViewController.swift
//  EasyCard
//
//  Created by echo on 2017/2/22.
//  Copyright © 2017年 羲和. All rights reserved.
//

import UIKit

class PhotoBaseViewController: UIViewController {
    
    lazy var cameraButton: UIButton = {
        let _cameraButton = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 35))
        _cameraButton.setImage(UIImage(named:"icon_btn_camera_b_27x27_"), for: .normal)
        _cameraButton.setTitle("相机", for: .normal)
        _cameraButton.setTitleColor(UIColor.colorWithHexString(hex: "#578fff"), for: .normal)
        _cameraButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        _cameraButton.addTarget(self, action: #selector(cameraButtonClicked(sender:)), for: .touchUpInside)
        return _cameraButton
    }()
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.cameraButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.colorWithHexString(hex: "#2c2e30")
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 17), NSForegroundColorAttributeName: UIColor.colorWithHexString(hex: "#333333")]
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named:"btn_back_arrow_25x25_")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named:"btn_back_arrow_25x25_")
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 13), NSForegroundColorAttributeName: UIColor.colorWithHexString(hex: "#333333")], for: .normal)
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: 3, vertical: -3), for: .default)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: Actions
    func cameraButtonClicked(sender: Any) -> Void {
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
