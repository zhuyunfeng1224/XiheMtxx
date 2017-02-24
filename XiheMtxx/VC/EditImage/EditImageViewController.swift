//
//  EditImageViewController.swift
//  EasyCard
//
//  Created by echo on 2017/2/21.
//  Copyright © 2017年 羲和. All rights reserved.
//

import UIKit

class EditImageViewController: BaseViewController {
    
    var image: UIImage?
    let imageAndScreenHeightRatio: CGFloat = 0.7
    
    // 图片
    lazy var imageView: UIImageView = {
        let _imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height * self.imageAndScreenHeightRatio))
        _imageView.contentMode = .scaleAspectFit
        _imageView.backgroundColor = UIColor.colorWithHexString(hex: "#2c2e30")
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
        
        _menuBar.layer.masksToBounds = false
        _menuBar.layer.shadowColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
        _menuBar.layer.shadowOffset = CGSize(width: 0, height: -0.5)
        _menuBar.layer.shadowRadius = 0.5
        _menuBar.layer.shadowOpacity = 0.8
        
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
        _scaleSelectionView.delegate = self
        return _scaleSelectionView
    }()
    
    // 尺寸调整View
    lazy var resizableView: UserResizableView = {
        let _resizableView = UserResizableView(frame: CGRect.zero)
        _resizableView.isHidden = true
        return _resizableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.colorWithHexString(hex: "#2c2e30")
        self.imageView.image = self.image
        self.imageView.addSubview(self.resizableView)
        self.view.addSubview(self.imageView)
        self.imageView.addSubview(self.grayView)
        
        self.view.addSubview(self.bottomView)
        self.bottomView.addSubview(self.operationView)
        self.operationView.addSubview(self.resetButton)
        self.operationView.addSubview(self.cutButton)
        self.operationView.addSubview(self.scaleSelectionView)
        
        self.bottomView.addSubview(self.menuBar)
        self.menuBar.addSubview(self.cancelButton)
        self.menuBar.addSubview(self.confirmButton)
        
        self.view.setNeedsUpdateConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.bottomView.frame = self.operationView.frame.offsetBy(dx: 0, dy: UIScreen.main.bounds.size.height * (1.0-self.imageAndScreenHeightRatio))
        UIView.animate(withDuration: 0.3, animations: {
            self.bottomView.frame = self.operationView.frame.offsetBy(dx: 0, dy: -UIScreen.main.bounds.size.height * (1.0-self.imageAndScreenHeightRatio))
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
        
        // operationView
        let operationHConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[operationView]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["operationView": self.operationView])
        let operationVConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[operationView]-0-[menuBar]", options: NSLayoutFormatOptions(rawValue:0), metrics:nil, views: ["operationView": self.operationView, "menuBar": self.menuBar])
        
        self.view.addConstraints(operationHConstraints)
        self.view.addConstraints(operationVConstraints)
        
        // resetButton and cutButton
        let operationButtonsHContraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[resetButton(==60)]->=0-[cutButton(==80)]-10-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["resetButton": self.resetButton, "cutButton": self.cutButton])
        let operationResetButtonVConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[resetButton(==30)]-10-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["resetButton": self.resetButton])
        let operationCutButtonVConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[cutButton(==30)]-10-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["cutButton": self.cutButton])
        self.operationView.addConstraints(operationButtonsHContraints)
        self.operationView.addConstraints(operationResetButtonVConstraints)
        self.operationView.addConstraints(operationCutButtonVConstraints)
        
        // selectionView
        let selectionViewHConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[selectionView]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["selectionView": self.scaleSelectionView])
        let selectionViewVConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[selectionView]-10-[resetButton]", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["selectionView": self.scaleSelectionView, "resetButton": self.resetButton])
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

extension EditImageViewController: ScaleSelectionViewDelegate {
    func scaleSelected(scaleType: ScaleType) {
        self.resizableView.setCenterImageHidden(hidden: scaleType != .scale_free)
        self.resizableView.isHidden = false
        // 缩小后的图片像素尺寸
        let scaleSize = scaleType.scaleDownInSize(originSize: (self.image?.size)!)
        self.resizableView.sizeLabel.text = "\(Int(scaleSize.width)) * \(Int(scaleSize.height))"
        
        // 缩小后的图片比例
        let scale = scaleSize.width / scaleSize.height
        
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
        
        // 按照图片在View中的大小截取图片
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
        self.resizableView.frame = resizeFrame
        self.grayView.centerFrame = resizeFrame
        self.grayView.setNeedsDisplay()
        self.resizableView.gridBorderView.setNeedsDisplay()
    }
}
