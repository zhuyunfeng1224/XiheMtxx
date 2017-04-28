//
//  EditImageViewController.swift
//  EasyCard
//
//  Created by echo on 2017/2/21.
//  Copyright © 2017年 羲和. All rights reserved.
//

import UIKit

class EditImageViewController: BaseViewController {
    
    var originImage: UIImage?
    var image: UIImage? {
        didSet {
            self.imageView.image = image
        }
    }
    // imageView占屏幕高度的比例
    let imageAndScreenHeightRatio: CGFloat = 0.7
    // 底部menuBar高度
    let menuBarHeight: CGFloat = 50
    // 图片在ImageView中的位置
    var imageRectInImageView: CGRect = CGRect.zero
    
    // 图片
    lazy var imageView: UIImageView = {
        let _imageView = UIImageView(frame: CGRect.zero)
        _imageView.isUserInteractionEnabled = true
        _imageView.contentMode = .scaleAspectFit
        _imageView.backgroundColor = UIColor.colorWithHexString(hex: "#3c3c3c")
        return _imageView
    }()
    
    // 遮罩层
    lazy var grayView: GrayView = {
        let _grayView = GrayView(frame: CGRect.zero)
        return _grayView
    }()
    
    // 底部背景View
    lazy var bottomView: UIView = {
        let _bottomView = UIView(frame: CGRect.zero)
        _bottomView.backgroundColor = UIColor.white.withAlphaComponent(0.95)
        _bottomView.translatesAutoresizingMaskIntoConstraints = false
        return _bottomView
    }()
    
    // MARK: - Cut View
    
    // 操作背景View
    lazy var cutOperationView: UIView = {
        let _cutOperationView = UIView(frame: CGRect.zero)
        _cutOperationView.backgroundColor = UIColor.white.withAlphaComponent(0.95)
        _cutOperationView.translatesAutoresizingMaskIntoConstraints = false
        return _cutOperationView
    }()
    
    // 重置按钮
    lazy var cutResetButton: UIButton = {
        let _cutResetButton = UIButton(frame: CGRect.zero)
        _cutResetButton.setTitle("重置", for: .normal)
        _cutResetButton.setTitleColor(UIColor.white, for: .normal)
        _cutResetButton.setBackgroundImage(UIImage(named:"btn_60_gray_normal_36x30_"), for: .normal)
        _cutResetButton.setBackgroundImage(UIImage(named:"btn_60_gray_disabled_36x30_"), for: .disabled)
        _cutResetButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        _cutResetButton.isEnabled = false
        _cutResetButton.translatesAutoresizingMaskIntoConstraints = false
        _cutResetButton.addTarget(self, action: #selector(cutResetButtonClicked(sender:)), for: .touchUpInside)
        return _cutResetButton
    }()
    
    // 裁剪按钮
    lazy var cutConfirmButton: UIButton = {
        let _cutConfirmButton = UIButton(frame: CGRect.zero)
        _cutConfirmButton.setTitle("确定裁剪", for: .normal)
        _cutConfirmButton.setTitleColor(UIColor.white, for: .normal)
        _cutConfirmButton
            .setBackgroundImage(UIImage(named:"btn_60_blue_36x30_"), for: .normal)
        _cutConfirmButton
            .setBackgroundImage(UIImage(named:"btn_60_blue_highlighted_36x30_"), for: .highlighted)
        _cutConfirmButton
            .setBackgroundImage(UIImage(named:"btn_60_blue_highlighted_36x30_"), for: .disabled)
        _cutConfirmButton
            .setImage(UIImage(named:"icon_meihua_edit_clip_confirm_normal_30x30_"), for: .normal)
        _cutConfirmButton
            .setImage(UIImage(named:"icon_meihua_edit_clip_confirm_highlighted_30x30_"), for: .highlighted)
        _cutConfirmButton
            .setImage(UIImage(named:"icon_meihua_edit_clip_confirm_highlighted_30x30_"), for: .selected)
        _cutConfirmButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        _cutConfirmButton.translatesAutoresizingMaskIntoConstraints = false
        _cutConfirmButton.addTarget(self, action: #selector(cutButtonClicked(sender:)), for: .touchUpInside)
        return _cutConfirmButton
    }()
    
    // 比例选择列表
    lazy var cutRatioSelectionView: RatioSelectionView = {
        let _cutRatioSelectionView = RatioSelectionView(frame: CGRect.zero)
        _cutRatioSelectionView.translatesAutoresizingMaskIntoConstraints = false
        _cutRatioSelectionView.delegate = self
        return _cutRatioSelectionView
    }()
    
    // 尺寸调整View
    lazy var cutResizableView: UserResizableView = {
        let _cutResizableView = UserResizableView(frame: CGRect.zero)
        _cutResizableView.isHidden = true
        _cutResizableView.delegate = self
        return _cutResizableView
    }()
    
    // 旋转图片展示View
    lazy var rotateCtrlView: RotateCtrlView = {
        let _rotateCtrlView = RotateCtrlView(frame: CGRect.zero)
        _rotateCtrlView.alpha = 0
        _rotateCtrlView.delegate = self
        _rotateCtrlView.dismissCompletation = { image in
            self.image = image
        }
        return _rotateCtrlView
    }()
    
    // MARK: - Rotate View
    
    lazy var rotateOperationView: UIView = {
        let _rotateOperationView = UIView(frame: CGRect.zero)
        _rotateOperationView.backgroundColor = UIColor.white.withAlphaComponent(0.95)
        _rotateOperationView.translatesAutoresizingMaskIntoConstraints = false
        _rotateOperationView.isHidden = true
        return _rotateOperationView
    }()
    
    // 旋转重置按钮
    lazy var rotateResetButton: UIButton = {
        let _rotateResetButton = UIButton(frame: CGRect.zero)
        _rotateResetButton.setTitle("重置", for: .normal)
        _rotateResetButton.setTitleColor(UIColor.white, for: .normal)
        _rotateResetButton
            .setBackgroundImage(UIImage(named:"btn_60_gray_normal_36x30_"), for: .normal)
        _rotateResetButton
            .setBackgroundImage(UIImage(named:"btn_60_gray_disabled_36x30_"), for: .disabled)
        _rotateResetButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        _rotateResetButton.isEnabled = false
        _rotateResetButton.translatesAutoresizingMaskIntoConstraints = false
        _rotateResetButton.addTarget(self, action: #selector(rotateResetButtonClicked(sender:)), for: .touchUpInside)
        return _rotateResetButton
    }()
    
    // 向左旋转按钮
    lazy var rotateLeftButton: UIButton = {
        let _rotateLeftButton = UIButton(frame: CGRect.zero)
        _rotateLeftButton.setImage(UIImage(named:"icon_meihua_edit_rotate_left_normal_30x30_"), for: .normal)
        _rotateLeftButton.setImage(UIImage(named:"icon_meihua_edit_rotate_left_highlighted_30x30_"), for: .highlighted)
        _rotateLeftButton.addTarget(self, action: #selector(rotateLeftButtonClicked(sender:)), for: .touchUpInside)
        _rotateLeftButton.translatesAutoresizingMaskIntoConstraints = false
        return _rotateLeftButton
    }()
    
    // 向右旋转按钮
    lazy var rotateRightButton: UIButton = {
        let _rotateRightButton = UIButton(frame: CGRect.zero)
        _rotateRightButton.setImage(UIImage(named:"icon_meihua_edit_rotate_right_normal_30x30_"), for: .normal)
        _rotateRightButton.setImage(UIImage(named:"icon_meihua_edit_rotate_right_highlighted_30x30_"), for: .highlighted)
        _rotateRightButton.addTarget(self, action: #selector(rotateRightButtonClicked(sender:)), for: .touchUpInside)
        _rotateRightButton.translatesAutoresizingMaskIntoConstraints = false
        return _rotateRightButton
    }()
    
    // 水平向右反转按钮
    lazy var rotateHorizontalButton: UIButton = {
        let _rotateHorizontalButton = UIButton(frame: CGRect.zero)
        _rotateHorizontalButton
            .setImage(UIImage(named:"icon_meihua_edit_rotate_horizontal_normal_30x30_"), for: .normal)
        _rotateHorizontalButton
            .setImage(UIImage(named:"icon_meihua_edit_rotate_horizontal_highlighted_30x30_"), for: .highlighted)
        _rotateHorizontalButton.addTarget(self, action: #selector(rotateHorizontalButtonClicked(sender:)), for: .touchUpInside)
        _rotateHorizontalButton.translatesAutoresizingMaskIntoConstraints = false
        return _rotateHorizontalButton
    }()
    
    // 水平向下反转按钮
    lazy var rotateVerticalButton: UIButton = {
        let _rotateVerticalButton = UIButton(frame: CGRect.zero)
        _rotateVerticalButton
            .setImage(UIImage(named:"icon_meihua_edit_rotate_vertical_normal_30x30_"), for: .normal)
        _rotateVerticalButton
            .setImage(UIImage(named:"icon_meihua_edit_rotate_vertical_highlighted_30x30_"), for: .highlighted)
        _rotateVerticalButton.addTarget(self, action: #selector(rotateVerticalButtonClicked(sender:)), for: .touchUpInside)
        _rotateVerticalButton.translatesAutoresizingMaskIntoConstraints = false
        return _rotateVerticalButton
    }()
    
    
    // MARK: - Menu
    
    // menuBar
    lazy var menuBar: UIView = {
        let _menuBar = UIView(frame: CGRect.zero)
        _menuBar.backgroundColor = UIColor.white
        _menuBar.translatesAutoresizingMaskIntoConstraints = false
        
        _menuBar.layer.masksToBounds = false
        _menuBar.layer.shadowColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
        _menuBar.layer.shadowOffset = CGSize(width: 0, height: -0.5)
        _menuBar.layer.shadowRadius = 0.5
        _menuBar.layer.shadowOpacity = 0.8
        
        return _menuBar
    }()
    
    // 裁剪menubutton
    lazy var cutMenuButton: VerticalButton = {
        let _cutMenuButton = VerticalButton(frame: CGRect.zero)
        _cutMenuButton.imageView?.contentMode = .center
        _cutMenuButton.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        _cutMenuButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 5, 0)
        _cutMenuButton.setTitle("裁剪", for: .normal)
        _cutMenuButton.setTitle("裁剪", for: .selected)
        _cutMenuButton.setTitleColor(UIColor.colorWithHexString(hex: "#578fff"), for: .highlighted)
        _cutMenuButton.setTitleColor(UIColor.colorWithHexString(hex: "#578fff"), for: .selected)
        _cutMenuButton.setTitleColor(UIColor.gray, for: .normal)
        _cutMenuButton
            .setImage(UIImage(named:"icon_meihua_edit_clip_normal_30x30_"), for: .normal)
        _cutMenuButton
            .setImage(UIImage(named:"icon_meihua_edit_clip_highlighted_30x30_"), for: .highlighted)
        _cutMenuButton
            .setImage(UIImage(named:"icon_meihua_edit_clip_highlighted_30x30_"), for: .selected)
        _cutMenuButton
            .addTarget(self, action: #selector(cutMenuButtonClicked(sender:)), for: .touchUpInside)
        _cutMenuButton.translatesAutoresizingMaskIntoConstraints = false
        return _cutMenuButton
    }()
    
    // 旋转menubutton
    lazy var rotateMenuButton: VerticalButton = {
        let _rotateMenuButton = VerticalButton(frame: CGRect.zero)
        _rotateMenuButton.imageView?.contentMode = .center
        _rotateMenuButton.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        _rotateMenuButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 5, 0)
        _rotateMenuButton.setTitle("旋转", for: .normal)
        _rotateMenuButton.setTitle("旋转", for: .selected)
        _rotateMenuButton.setTitleColor(UIColor.colorWithHexString(hex: "#578fff"), for: .highlighted)
        _rotateMenuButton.setTitleColor(UIColor.colorWithHexString(hex: "#578fff"), for: .selected)
        _rotateMenuButton.setTitleColor(UIColor.gray, for: .normal)
        _rotateMenuButton
            .setImage(UIImage(named:"icon_meihua_edit_rotate_normal_30x30_"), for: .normal)
        _rotateMenuButton
            .setImage(UIImage(named:"icon_meihua_edit_rotate_highlighted_30x30_"), for: .highlighted)
        _rotateMenuButton
            .setImage(UIImage(named:"icon_meihua_edit_rotate_highlighted_30x30_"), for: .selected)
        _rotateMenuButton
            .addTarget(self, action: #selector(rotateMenuButtonClicked(sender:)), for: .touchUpInside)
        _rotateMenuButton.translatesAutoresizingMaskIntoConstraints = false
        return _rotateMenuButton
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.colorWithHexString(hex: "#2c2e30")
        
        self.image = self.originImage
        self.imageView.addSubview(self.grayView)
        self.imageView.addSubview(self.cutResizableView)
        self.view.addSubview(self.imageView)
        
        self.view.addSubview(self.bottomView)
        self.bottomView.addSubview(self.cutOperationView)
        self.cutOperationView.addSubview(self.cutResetButton)
        self.cutOperationView.addSubview(self.cutConfirmButton)
        self.cutOperationView.addSubview(self.cutRatioSelectionView)
        
        self.bottomView.addSubview(self.menuBar)
        self.cutMenuButton.isSelected = true
        self.menuBar.addSubview(self.cutMenuButton)
        self.menuBar.addSubview(self.rotateMenuButton)
        self.menuBar.addSubview(self.cancelButton)
        self.menuBar.addSubview(self.confirmButton)
        
        self.bottomView.addSubview(self.rotateOperationView)
        self.rotateOperationView.addSubview(self.rotateResetButton)
        self.rotateOperationView.addSubview(self.rotateLeftButton)
        self.rotateOperationView.addSubview(self.rotateRightButton)
        self.rotateOperationView.addSubview(self.rotateHorizontalButton)
        self.rotateOperationView.addSubview(self.rotateVerticalButton)
        
        self.view.setNeedsUpdateConstraints()
        self.cutResizableView.addObserver(self, forKeyPath: "frame", options: .new, context: nil)
    }
    
    deinit {
        self.cutResizableView.removeObserver(self, forKeyPath: "frame")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.bottomView.frame = self.cutOperationView.frame.offsetBy(dx: 0, dy: UIScreen.main.bounds.size.height * (1.0-self.imageAndScreenHeightRatio))
        UIView.animate(withDuration: 0.3, animations: {
            self.bottomView.frame = self.cutOperationView.frame.offsetBy(dx: 0, dy: -UIScreen.main.bounds.size.height * (1.0-self.imageAndScreenHeightRatio))
        })
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        // bottomView
        let bottomViewHConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[bottomView]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["bottomView": self.bottomView])
        let bottomViewVConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-y-[bottomView]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: ["y": UIScreen.main.bounds.size.height * self.imageAndScreenHeightRatio], views: ["bottomView": self.bottomView])
        
        self.view.addConstraints(bottomViewHConstraints)
        self.view.addConstraints(bottomViewVConstraints)
        
        
        // ------------------------------cutOperationView-------------------
        
        // cutOperationView
        let operationHConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[cutOperationView]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["cutOperationView": self.cutOperationView])
        let operationVConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[cutOperationView]-0-[menuBar]", options: NSLayoutFormatOptions(rawValue:0), metrics:nil, views: ["cutOperationView": self.cutOperationView, "menuBar": self.menuBar])
        
        self.view.addConstraints(operationHConstraints)
        self.view.addConstraints(operationVConstraints)
        
        // cutResetButton and cutButton
        let operationButtonsHContraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[cutResetButton(==60)]->=0-[cutButton(==100)]-10-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["cutResetButton": self.cutResetButton, "cutButton": self.cutConfirmButton])
        let operationResetButtonVConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[cutResetButton(==30)]-10-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["cutResetButton": self.cutResetButton])
        let operationCutButtonVConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[cutButton(==30)]-10-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["cutButton": self.cutConfirmButton])
        self.cutOperationView.addConstraints(operationButtonsHContraints)
        self.cutOperationView.addConstraints(operationResetButtonVConstraints)
        self.cutOperationView.addConstraints(operationCutButtonVConstraints)
        
        // selectionView
        let selectionViewHConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[selectionView]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["selectionView": self.cutRatioSelectionView])
        let selectionViewVConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[selectionView]-10-[cutResetButton]", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["selectionView": self.cutRatioSelectionView, "cutResetButton": self.cutResetButton])
        self.cutOperationView.addConstraints(selectionViewHConstraints)
        self.cutOperationView.addConstraints(selectionViewVConstraints)
        
        // ------------------------- rotateOperationView -------------------
        
        // rotateOperationView
        let rotateOperationHConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[rotateOperationView]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["rotateOperationView": self.rotateOperationView])
        let rotateOperationVConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[rotateOperationView]-0-[menuBar]", options: NSLayoutFormatOptions(rawValue:0), metrics:nil, views: ["rotateOperationView": self.rotateOperationView, "menuBar": self.menuBar])
        self.view.addConstraints(rotateOperationHConstraints)
        self.view.addConstraints(rotateOperationVConstraints)
        
        let rotateOperationButtonsHContraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[rotateResetButton(==60)]->=20-[rotateLeftButton(==30)]-25-[rotateRightButton(==30)]-25-[rotateHorizontalButton(==30)]-25-[rotateVerticalButton(==30)]-15-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["rotateResetButton": self.rotateResetButton, "rotateLeftButton": self.rotateLeftButton, "rotateRightButton" : self.rotateRightButton, "rotateHorizontalButton" : self.rotateHorizontalButton, "rotateVerticalButton": self.rotateVerticalButton])
        
        let bottom = (UIScreen.main.bounds.height * (1 - self.imageAndScreenHeightRatio) - self.menuBarHeight) / 2 - 15
        let rotateResetButtonVConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[rotateResetButton(==30)]-bottom-|", options: NSLayoutFormatOptions(rawValue:0), metrics: ["bottom": bottom], views: ["rotateResetButton": self.rotateResetButton])
        
        let rotateRightButtonVConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[rotateRightButton(==30)]-bottom-|", options: NSLayoutFormatOptions(rawValue:0), metrics: ["bottom": bottom], views: ["rotateRightButton": self.rotateRightButton])
        
        let rotateLeftButtonVConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[rotateLeftButton(==30)]-bottom-|", options: NSLayoutFormatOptions(rawValue:0), metrics: ["bottom": bottom], views: ["rotateLeftButton": self.rotateLeftButton])
        
        let rotateHorizontalButtonVConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[rotateHorizontalButton(==30)]-bottom-|", options: NSLayoutFormatOptions(rawValue:0), metrics: ["bottom": bottom], views: ["rotateHorizontalButton": self.rotateHorizontalButton])
        
        let rotateVerticalButtonVConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[rotateVerticalButton(==30)]-bottom-|", options: NSLayoutFormatOptions(rawValue:0), metrics: ["bottom": bottom], views: ["rotateVerticalButton": self.rotateVerticalButton])
        self.rotateOperationView.addConstraints(rotateOperationButtonsHContraints)
        self.rotateOperationView.addConstraints(rotateResetButtonVConstraints)
        self.rotateOperationView.addConstraints(rotateLeftButtonVConstraints)
        self.rotateOperationView.addConstraints(rotateRightButtonVConstraints)
        self.rotateOperationView.addConstraints(rotateHorizontalButtonVConstraints)
        self.rotateOperationView.addConstraints(rotateVerticalButtonVConstraints)
        
        // ---------------------------menuBar----------------------------
        
        // cancelButton and confirmButton
        let cancelAndConfirmButtonsHContraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[cancelButton(==50)]-30-[cutMenuButton(==50)]->=0-[rotateMenuButton(==50)]-30-[confirmButton(==50)]-10-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["cancelButton": self.cancelButton, "confirmButton": self.confirmButton, "cutMenuButton": self.cutMenuButton, "rotateMenuButton": self.rotateMenuButton])
        let cancelButtonVConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[cancelButton]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["cancelButton": self.cancelButton])
        let confirmButtonVConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[confirmButton]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["confirmButton": self.confirmButton])
        let cutMenuButtonVConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[cutMenuButton]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["cutMenuButton": self.cutMenuButton])
        let rotateMenuButtonVConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[rotateMenuButton]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["rotateMenuButton": self.rotateMenuButton])
        
        // menuBar
        let menuBarHConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[menuBar]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["menuBar": self.menuBar])
        let menuBarVConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[menuBar(==menuBarHeight)]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: ["menuBarHeight": self.menuBarHeight], views: ["menuBar": self.menuBar])
        self.view.addConstraints(menuBarHConstraints)
        self.view.addConstraints(menuBarVConstraints)
        
        self.menuBar.addConstraints(cancelAndConfirmButtonsHContraints)
        self.menuBar.addConstraints(cancelButtonVConstraints)
        self.menuBar.addConstraints(confirmButtonVConstraints)
        self.menuBar.addConstraints(cutMenuButtonVConstraints)
        self.menuBar.addConstraints(rotateMenuButtonVConstraints)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let rect = CGRect(x: 0,
                          y: 0,
                          width: UIScreen.main.bounds.size.width,
                          height: UIScreen.main.bounds.size.height * self.imageAndScreenHeightRatio)
        self.imageView.frame = rect
        self.grayView.frame = rect
        self.grayView.clearFrame = self.cutResizableView.frame
        self.rotateCtrlView.frame = rect
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Actions
    
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
    
    // 裁剪菜单按钮点击
    func cutMenuButtonClicked(sender: UIButton) -> Void {
        self.cutMenuButton.isSelected = true
        self.rotateMenuButton.isSelected = false
        self.cutResizableView.isHidden = false
        self.grayView.clearFrame = self.cutResizableView.frame
        self.view.setNeedsLayout()
        
        UIView.animate(withDuration: 0.2, animations: { 
            self.cutOperationView.alpha = 1
            self.rotateOperationView.alpha = 0
            self.rotateCtrlView.alpha = 0
        }) { (finished) in
            if finished {
                self.cutOperationView.isHidden = false
                self.rotateOperationView.isHidden = true
                self.rotateCtrlView.removeFromSuperview()
            }
        }
    }
    
    // 旋转菜单按钮点击
    func rotateMenuButtonClicked(sender: UIButton) -> Void {
        self.rotateMenuButton.isSelected = true
        self.cutMenuButton.isSelected = false
        self.cutResizableView.isHidden = true
//        self.grayView.frame = self.imageRectInImageView
//        self.grayView.clearFrame = self.imageRectInImageView
        self.view.addSubview(self.rotateCtrlView)
//        self.rotateCtrlView.frame = self.imageRectInImageView
        self.rotateCtrlView.originImage = self.image
        self.view.setNeedsLayout()
        
        UIView.animate(withDuration: 0.2, animations: {
            self.rotateCtrlView.alpha = 1
            self.cutOperationView.alpha = 0
            self.rotateOperationView.alpha = 1
        }) { (finished) in
            if finished {
                self.cutOperationView.isHidden = true
                self.rotateOperationView.isHidden = false
            }
        }
    }
   
    // 重置按钮点击
    func cutResetButtonClicked(sender: UIButton) -> Void {
        self.image = self.originImage
        self.cutRatioSelectionView.itemSelect(atIndex: 0)
        self.cutRatioSelectionView.itemSelect(atIndex: self.cutRatioSelectionView.selectIndex)
        self.cutResetButton.isEnabled = false
        self.view.setNeedsLayout()
    }
    
    // 裁剪按钮点击
    func cutButtonClicked(sender: UIButton) -> Void {
        
        let cutImage = self.image?.clipToRect(rect: self.cutResizableView.frame, inRect: self.imageRectInImageView)
        self.image = cutImage
        self.cutRatioSelectionView.itemSelect(atIndex: self.cutRatioSelectionView.selectIndex)
        self.cutConfirmButton.isEnabled = false
        self.imageRectInImageView = self.cutResizableView.frame
        self.view.setNeedsLayout()
    }
    
    // 旋转重置按钮
    func rotateResetButtonClicked(sender: UIButton) -> Void {
        self.rotateCtrlView.rotateReset()
        self.rotateResetButton.isEnabled = false
    }
    
    // 向左旋转按钮
    func rotateLeftButtonClicked(sender: UIButton) -> Void {
        self.rotateCtrlView.rotateLeft()
    }
    
    // 向右旋转按钮
    func rotateRightButtonClicked(sender: UIButton) -> Void {
        self.rotateCtrlView.rotateRight()
    }
    
    // 向右反转按钮
    func rotateHorizontalButtonClicked(sender: UIButton) -> Void {
        self.rotateCtrlView.rotateHorizontalMirror()
    }
    
    // 向下反转按钮
    func rotateVerticalButtonClicked(sender: UIButton) -> Void {
        self.rotateCtrlView.rotateVerticalnMirror()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "frame" {
            let frame = change?[NSKeyValueChangeKey.newKey] as! CGRect
            self.grayView.clearFrame = frame
            self.cutResizableView.gridBorderView.setNeedsDisplay()
            
            // 缩小后的图片像素尺寸
            let cropPixelFrame = self.image?.convertToPixelRect(fromRect: self.cutResizableView.frame, inRect: self.imageRectInImageView)
            self.cutResizableView.sizeLabel.text = "\(Int((cropPixelFrame?.size.width)!)) × \(Int((cropPixelFrame?.size.height)!))"
        }
    }
}

extension EditImageViewController: RatioSelectionViewDelegate {
    func ratioSelected(ratioType: RatioType) {
        self.cutResizableView.isHidden = false
        self.cutResizableView.translationRatio = ratioType
        self.cutResetButton.isEnabled = true
        self.cutConfirmButton.isEnabled = true
        
        if ratioType == .ratio_free && self.cutRatioSelectionView.selectIndex != 0 {
            self.cutResizableView.setCenterImageHidden(hidden: false)
            self.cutRatioSelectionView.selectIndex = ratioType.rawValue
            return
        }
        self.cutRatioSelectionView.selectIndex = ratioType.rawValue
        self.cutResizableView.setCenterImageHidden(hidden: ratioType != .ratio_free)
        
        // 缩小后的图片像素尺寸
        let ratioSize = ratioType.ratioDownInSize(originSize: (self.image?.size)!)
        
        // 缩小后的图片比例
        let scale = ratioSize.width / ratioSize.height
        
        // 原始图片View的尺寸
        let originImageScale = (self.image?.size.width)!/(self.image?.size.height)!
        let imageViewSize = self.imageView.frame.size
        let imageViewScale = imageViewSize.width/imageViewSize.height
        var imageSizeInView = imageViewSize
        
        // 得出图片在ImageView中的尺寸
        if imageViewScale <= originImageScale {
            imageSizeInView = CGSize(width: imageViewSize.width, height: imageViewSize.width / originImageScale)
        }
        else {
            imageSizeInView = CGSize(width: imageViewSize.height * originImageScale, height: imageViewSize.height)
        }
        let imageOriginInView = CGPoint(x: (self.imageView.frame.size.width - imageSizeInView.width)/2, y: (self.imageView.frame.size.height - imageSizeInView.height)/2)
        
        // 按照比例在View中的大小截取图片
        var imageSizeAfterScaleDown = imageSizeInView
        if originImageScale <= scale {
            imageSizeAfterScaleDown = CGSize(width: imageSizeInView.width, height: imageSizeInView.width / scale)
        }
        else {
            imageSizeAfterScaleDown = CGSize(width: imageSizeInView.height * scale, height: imageSizeInView.height)
        }
        
        // 计算resizeView.frame
        let newOrigin = CGPoint(x: (self.imageView.frame.size.width - imageSizeAfterScaleDown.width)/2, y: (self.imageView.frame.size.height - imageSizeAfterScaleDown.height)/2)
        let resizeFrame = CGRect(origin: newOrigin, size: imageSizeAfterScaleDown)
        
        self.imageRectInImageView = CGRect(origin: imageOriginInView, size: imageSizeInView)
        self.cutResizableView.imageBounds = self.imageRectInImageView
        
        self.cutResizableView.frame = resizeFrame
    }
}

extension EditImageViewController: UserResizableViewDelegate {
    func resizeView() {
        self.cutResetButton.isEnabled = true
        self.cutConfirmButton.isEnabled = true
    }
}

extension EditImageViewController: RotateCtrlViewDelegate {
    func rotateImageChanged() {
        self.rotateResetButton.isEnabled = true
    }
}
