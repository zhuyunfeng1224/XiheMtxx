//
//  EditImageViewController.swift
//  EasyCard
//
//  Created by echo on 2017/2/21.
//  Copyright © 2017年 羲和. All rights reserved.
//

import UIKit

class EditImageViewController: UIViewController {
    
    // 图片
    lazy var imageView: UIImageView = {
        let _imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height * 0.65))
        _imageView.contentMode = .scaleAspectFit
        _imageView.backgroundColor = UIColor.colorWithHexString(hex: "#2c2e30")
        return _imageView
    }()
    
    // 遮罩层
    lazy var grayView: GrayView = {
        let _grayView = GrayView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height * 0.65))
        return _grayView
    }()
    
    // 操作背景View
    lazy var operationView: UIView = {
        let _operationView = UIView(frame: CGRect.zero)
        _operationView.backgroundColor = UIColor.white.withAlphaComponent(0.95)
        _operationView.translatesAutoresizingMaskIntoConstraints = false
        return _operationView
    }()
    
    // 重置按钮
    lazy var resetButton: UIButton = {
        let _resetButton = UIButton(frame: CGRect.zero)
        _resetButton.setTitle("重置", for: .normal)
        _resetButton.setTitleColor(UIColor.white, for: .normal)
        _resetButton.setBackgroundImage(UIImage(named:"btn_60_gray_normal_36x30_"), for: .normal)
        _resetButton.setBackgroundImage(UIImage(named:"btn_60_gray_disabled_36x30_"), for: .disabled)
        _resetButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        _resetButton.isEnabled = false
        _resetButton.translatesAutoresizingMaskIntoConstraints = false
        _resetButton.addTarget(self, action: #selector(resetButtonClicked(sender:)), for: .touchUpInside)
        return _resetButton
    }()
    
    // 裁剪按钮
    lazy var cutButton: UIButton = {
        let _cutButton = UIButton(frame: CGRect.zero)
        _cutButton.setTitle("确定裁剪", for: .normal)
        _cutButton.setTitleColor(UIColor.white, for: .normal)
        _cutButton.setBackgroundImage(UIImage(named:"btn_60_blue_36x30_"), for: .normal)
        _cutButton.setBackgroundImage(UIImage(named:"btn_60_blue_highlighted_36x30_"), for: .highlighted)
        _cutButton.setBackgroundImage(UIImage(named:"btn_60_blue_highlighted_36x30_"), for: .disabled)
        _cutButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        _cutButton.translatesAutoresizingMaskIntoConstraints = false
        _cutButton.addTarget(self, action: #selector(cutButtonClicked(sender:)), for: .touchUpInside)
        return _cutButton
    }()
    
    
    // menuBar
    lazy var menuBar: UIView = {
        let _menuBar = UIView(frame: CGRect.zero)
        _menuBar.backgroundColor = UIColor.white
        _menuBar.translatesAutoresizingMaskIntoConstraints = false
        
        let shadowView = UIView(frame: CGRect.zero)
        shadowView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        shadowView.layer.masksToBounds = false
        shadowView.layer.shadowColor = UIColor.white.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
        shadowView.layer.shadowRadius = 0.5
        shadowView.layer.shadowOpacity = 0.8
        _menuBar.addSubview(shadowView)
        
        return _menuBar
    }()
    
    // 取消
    lazy var cancelButton: UIButton = {
        let _cancelButton = UIButton(frame: CGRect.zero)
        _cancelButton.setImage(UIImage(named:"icon_cancel_normal_30x30_"), for: .normal)
        _cancelButton.setImage(UIImage(named:"icon_cancel_highlighted_30x30_"), for: .disabled)
        _cancelButton.addTarget(self, action: #selector(cancelButtonClicked(sender:)), for: .touchUpInside)
        _cancelButton.translatesAutoresizingMaskIntoConstraints = false
        return _cancelButton
    }()
    
    // 确定按钮
    lazy var confirmButton: UIButton = {
        let _confirmButton = UIButton(frame: CGRect.zero)
        _confirmButton.setImage(UIImage(named:"icon_confirm_normal_30x30_") , for: .normal)
        _confirmButton.setImage(UIImage(named:"icon_confirm_highlighted_30x30_"), for: .disabled)
        _confirmButton.translatesAutoresizingMaskIntoConstraints = false
        _confirmButton.addTarget(self, action: #selector(confirmButtonClicked(sender:)), for: .touchUpInside)
        return _confirmButton
    }()
    
    // 比例选择列表
    lazy var scaleSelectionView: ScaleSelectionView = {
        let _scaleSelectionView = ScaleSelectionView(frame: CGRect.zero)
        _scaleSelectionView.translatesAutoresizingMaskIntoConstraints = false
        return _scaleSelectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.colorWithHexString(hex: "#2c2e30")
        self.view.addSubview(self.imageView)
        self.imageView.addSubview(self.grayView)
        
        self.view.addSubview(self.operationView)
        self.operationView.addSubview(self.resetButton)
        self.operationView.addSubview(self.cutButton)
        self.operationView.addSubview(self.scaleSelectionView)
        
        self.view.addSubview(self.menuBar)
        self.menuBar.addSubview(self.cancelButton)
        self.menuBar.addSubview(self.confirmButton)
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        // operationView
        let operationHConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[operationView]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["operationView": operationView])
        let operationVConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-y-[operationView]-bottom-|", options: NSLayoutFormatOptions(rawValue:0), metrics: ["y": UIScreen.main.bounds.size.height * 0.65, "bottom": 50], views: ["operationView": operationView])
        self.view.addConstraints(operationHConstraints)
        self.view.addConstraints(operationVConstraints)
        
        // menuBar
        let menuBarHConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[menuBar]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["menuBar": self.menuBar])
        let menuBarVConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[operationView]-0-[menuBar]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["operationView": operationView, "menuBar": self.menuBar])
        self.view.addConstraints(menuBarHConstraints)
        self.view.addConstraints(menuBarVConstraints)
        
        // resetButton and cutButton
        let operationButtonsHContraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[resetButton(==60)]->=0-[cutButton(==80)]-10-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["resetButton": self.resetButton, "cutButton": self.cutButton])
        let operationResetButtonVConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[resetButton(==30)]-18-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["resetButton": self.resetButton])
        let operationCutButtonVConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[cutButton(==30)]-18-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["cutButton": self.cutButton])
        self.operationView.addConstraints(operationButtonsHContraints)
        self.operationView.addConstraints(operationResetButtonVConstraints)
        self.operationView.addConstraints(operationCutButtonVConstraints)
        
        // selectionView
        let selectionViewHConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[selectionView]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["selectionView": self.scaleSelectionView])
        let selectionViewVConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-15-[selectionView]-15-[resetButton]", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["selectionView": self.scaleSelectionView, "resetButton": self.resetButton])
        self.operationView.addConstraints(selectionViewHConstraints)
        self.operationView.addConstraints(selectionViewVConstraints)
        
        // cancelButton and confirmButton
        let cancelAndConfirmButtonsHContraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[cancelButton(==50)]->=0-[confirmButton(==50)]-10-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["cancelButton": self.cancelButton, "confirmButton": self.confirmButton])
        let cancelButtonVConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[cancelButton]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["cancelButton": self.cancelButton])
        let confirmButtonVConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[confirmButton]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["confirmButton": self.confirmButton])
        self.menuBar.addConstraints(cancelAndConfirmButtonsHContraints)
        self.menuBar.addConstraints(cancelButtonVConstraints)
        self.menuBar.addConstraints(confirmButtonVConstraints)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Actions
    // 取消按钮点击
    func cancelButtonClicked(sender: UIButton) -> Void {
        self.dismiss(animated: true) { 
            
        }
    }
    
    // 确定按钮点击
    func confirmButtonClicked(sender: UIButton) -> Void {
        self.dismiss(animated: true) { 
            
        }
    }
    
    // 重置按钮点击
    func resetButtonClicked(sender: UIButton) -> Void {
        
    }
    
    // 裁剪按钮点击
    func cutButtonClicked(sender: UIButton) -> Void {
        
    }
}
