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
    var image: UIImage?
    // imageView占屏幕高度的比例
    let imageAndScreenHeightRatio: CGFloat = 0.7
    // 图片在ImageView中的位置
    var imageRectInImageView: CGRect = CGRect.zero
    // 编辑之后的图片实际位置，以像素为单位
    var imageRectForPixelsAfterEdited: CGRect = CGRect.zero
    
    // 图片
    lazy var imageView: UIImageView = {
        let _imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height * self.imageAndScreenHeightRatio))
        _imageView.isUserInteractionEnabled = true
        _imageView.contentMode = .scaleAspectFit
        _imageView.backgroundColor = UIColor.colorWithHexString(hex: "#2c2e30")
        return _imageView
    }()
    
    // 遮罩层
    lazy var grayView: GrayView = {
        let _grayView = GrayView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height * self.imageAndScreenHeightRatio))
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
        self.image = self.originImage
        self.view.backgroundColor = UIColor.colorWithHexString(hex: "#2c2e30")
        self.imageView.image = self.image
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
        
        // menuBar
        let menuBarHConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[menuBar]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["menuBar": self.menuBar])
        let menuBarVConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[menuBar(==50)]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["menuBar": self.menuBar])
        self.view.addConstraints(menuBarHConstraints)
        self.view.addConstraints(menuBarVConstraints)
        
        // cutOperationView
        let operationHConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[cutOperationView]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["cutOperationView": self.cutOperationView])
        let operationVConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[cutOperationView]-0-[menuBar]", options: NSLayoutFormatOptions(rawValue:0), metrics:nil, views: ["cutOperationView": self.cutOperationView, "menuBar": self.menuBar])
        
        self.view.addConstraints(operationHConstraints)
        self.view.addConstraints(operationVConstraints)
        
        // cutResetButton and cutButton
        let operationButtonsHContraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[cutResetButton(==60)]->=0-[cutButton(==90)]-10-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["cutResetButton": self.cutResetButton, "cutButton": self.cutConfirmButton])
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
        
        // cancelButton and confirmButton
        let cancelAndConfirmButtonsHContraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[cancelButton(==50)]-30-[cutMenuButton(==50)]->=0-[rotateMenuButton(==50)]-30-[confirmButton(==50)]-10-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["cancelButton": self.cancelButton, "confirmButton": self.confirmButton, "cutMenuButton": self.cutMenuButton, "rotateMenuButton": self.rotateMenuButton])
        let cancelButtonVConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[cancelButton]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["cancelButton": self.cancelButton])
        let confirmButtonVConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[confirmButton]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["confirmButton": self.confirmButton])
        let cutMenuButtonVConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[cutMenuButton]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["cutMenuButton": self.cutMenuButton])
        let rotateMenuButtonVConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[rotateMenuButton]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["rotateMenuButton": self.rotateMenuButton])
        
        self.menuBar.addConstraints(cancelAndConfirmButtonsHContraints)
        self.menuBar.addConstraints(cancelButtonVConstraints)
        self.menuBar.addConstraints(confirmButtonVConstraints)
        self.menuBar.addConstraints(cutMenuButtonVConstraints)
        self.menuBar.addConstraints(rotateMenuButtonVConstraints)
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
    
    // 裁剪菜单按钮点击
    func cutMenuButtonClicked(sender: UIButton) -> Void {
        self.cutMenuButton.isSelected = true
        self.rotateMenuButton.isSelected = false
        self.cutResizableView.isHidden = false
        self.grayView.centerFrame = self.cutResizableView.frame
    }
    
    // 旋转菜单按钮点击
    func rotateMenuButtonClicked(sender: UIButton) -> Void {
        self.rotateMenuButton.isSelected = true
        self.cutMenuButton.isSelected = false
        self.cutResizableView.isHidden = true
        self.grayView.centerFrame = self.imageRectInImageView
    }
    
    // 重置按钮点击
    func cutResetButtonClicked(sender: UIButton) -> Void {
        self.image = self.originImage
        self.imageView.image = image
        self.cutRatioSelectionView.itemSelect(atIndex: 0)
        self.cutRatioSelectionView.itemSelect(atIndex: self.cutRatioSelectionView.selectIndex)
        self.cutResetButton.isEnabled = false
    }
    
    // 裁剪按钮点击
    func cutButtonClicked(sender: UIButton) -> Void {
        let cgImage = self.image?.cgImage?.cropping(to: self.imageRectForPixelsAfterEdited)
        let cropImageSize = self.imageRectForPixelsAfterEdited.size
        
        // 使用UIKit方法绘制图片，防止图片倒置
        UIGraphicsBeginImageContext(cropImageSize)
        let cropImage = UIImage(cgImage: cgImage!)
        cropImage.draw(in: CGRect(origin: CGPoint.zero, size: cropImageSize))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.image = image
        self.imageView.image = image
        self.cutRatioSelectionView.itemSelect(atIndex: self.cutRatioSelectionView.selectIndex)
        self.cutConfirmButton.isEnabled = false
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "frame" {
            let frame = change?[NSKeyValueChangeKey.newKey] as! CGRect
            self.grayView.centerFrame = frame
            self.cutResizableView.gridBorderView.setNeedsDisplay()
            
            // 缩小后的图片像素尺寸
            let w = self.cutResizableView.frame.size.width/self.imageRectInImageView.size.width * self.image!.size.width
            let h = self.cutResizableView.frame.size.height/self.imageRectInImageView.size.height * self.image!.size.height
            let x = (self.cutResizableView.frame.origin.x - self.imageRectInImageView.origin.x) / self.imageRectInImageView.size.width * self.image!.size.width
            let y = (self.cutResizableView.frame.origin.y - self.imageRectInImageView.origin.y) / self.imageRectInImageView.size.width * self.image!.size.width
            self.imageRectForPixelsAfterEdited = CGRect(x: x, y: y, width: w, height: h)
            self.cutResizableView.sizeLabel.text = "\(Int(w)) × \(Int(h))"
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
