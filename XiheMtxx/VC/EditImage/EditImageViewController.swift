//
//  EditImageViewController.swift
//  EasyCard
//
//  Created by echo on 2017/2/21.
//  Copyright © 2017年 羲和. All rights reserved.
//

import UIKit

class EditImageViewController: BaseViewController {
    // 编辑模式
    enum EditMode {
        case cut
        case rotate
    }
    // 编辑模式
    var editMode: EditMode = .cut
    // imageView占屏幕高度的比例
    let imageAndScreenHeightRatio: CGFloat = 0.7
    // 底部menuBar高度
    let menuBarHeight: CGFloat = 50
    // 初始图片
    var originImage: UIImage?
    var image: UIImage? {
        didSet {
            self.cutCtrlView.originImage = image
        }
    }
    var completation:((UIImage)->())?
    
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
    
    lazy var cutCtrlView: CutCtrlView = {
        let _cutCtrlView = CutCtrlView(frame: CGRect.zero)
        _cutCtrlView.cutResizableView.delegate = self
        return _cutCtrlView
    }()
    
    // 旋转图片展示View
    lazy var rotateCtrlView: RotateCtrlView = {
        let _rotateCtrlView = RotateCtrlView(frame: CGRect.zero)
        _rotateCtrlView.isHidden = true
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
        
        self.cutCtrlView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height * self.imageAndScreenHeightRatio)
        self.view.addSubview(self.cutCtrlView)
        
        self.rotateCtrlView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height * self.imageAndScreenHeightRatio)
        self.view.addSubview(self.rotateCtrlView)
        
        
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
        
        if self.editMode == .cut, let completation = self.completation{
            completation(self.image!)
        }
        else if self.editMode == .rotate, let completation = self.completation {
            self.rotateCtrlView.generateNewTransformImage()
            completation(self.rotateCtrlView.image!)
        }
        self.dismiss(animated: true) { 
            
        }
    }
    
    // 裁剪菜单按钮点击
    func cutMenuButtonClicked(sender: UIButton) -> Void {
        
        self.editMode = .cut
        
        self.cutMenuButton.isSelected = true
        self.rotateMenuButton.isSelected = false
        self.cutCtrlView.resetLayoutOfSubviews()
        
        UIView.animate(withDuration: 0.2, animations: {
            self.cutCtrlView.isHidden = false
            self.cutOperationView.alpha = 1
            self.rotateOperationView.alpha = 0
            self.rotateCtrlView.alpha = 0
        }) { (finished) in
            if finished {
                self.cutOperationView.isHidden = false
                self.rotateOperationView.isHidden = true
                self.rotateCtrlView.isHidden = true
            }
        }
    }
    
    // 旋转菜单按钮点击
    func rotateMenuButtonClicked(sender: UIButton) -> Void {
        
        self.editMode = .rotate
        
        self.rotateMenuButton.isSelected = true
        self.cutMenuButton.isSelected = false
        
        self.rotateCtrlView.originImage = self.image
        self.rotateCtrlView.resetLayoutOfSubviews()
        
        UIView.animate(withDuration: 0.2, animations: {
            self.cutCtrlView.isHidden = true
            self.rotateCtrlView.isHidden = false
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
        self.cutRatioSelectionView.selectIndex = 0
        self.cutResetButton.isEnabled = false
    }
    
    // 裁剪按钮点击
    func cutButtonClicked(sender: UIButton) -> Void {
        
        self.image = self.cutCtrlView.generateClipImage()
        self.cutRatioSelectionView.selectIndex = self.cutRatioSelectionView.selectIndex
        self.cutConfirmButton.isEnabled = false
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
}


// MARK: RatioSelectionViewDelegate

extension EditImageViewController: RatioSelectionViewDelegate {
    func ratioSelected(ratioType: RatioType) {
        self.cutCtrlView.ratioType = ratioType
        self.cutResetButton.isEnabled = true
        self.cutConfirmButton.isEnabled = true
        
        if ratioType == .ratio_free && self.cutRatioSelectionView.selectIndex != 0 {
            self.cutRatioSelectionView.selectIndex = ratioType.rawValue
        }
    }
}


// MARK: UserResizableViewDelegate

extension EditImageViewController: UserResizableViewDelegate {
    func resizeView() {
        self.cutResetButton.isEnabled = true
        self.cutConfirmButton.isEnabled = true
    }
}


// MARK: RotateCtrlViewDelegate

extension EditImageViewController: RotateCtrlViewDelegate {
    func rotateImageChanged() {
        self.rotateResetButton.isEnabled = true
    }
}
