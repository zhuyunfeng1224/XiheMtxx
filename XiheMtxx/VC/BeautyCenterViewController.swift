//
//  MainViewController.swift
//  EasyCard
//
//  Created by echo on 2017/2/14.
//  Copyright © 2017年 羲和. All rights reserved.
//

import UIKit

class BeautyCenterViewController: BaseViewController {
    
    var originImage: UIImage!
    
    // 返回按钮
    lazy var backButton: UIButton = {
        let _backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
        _backButton.setTitleColor(UIColor.gray, for: .normal)
        _backButton.setImage(UIImage(named: "icon_back_a_25x25_"), for: .normal)
        _backButton.addTarget(self, action: #selector(back(sender:)), for: .touchUpInside)
        _backButton.contentHorizontalAlignment = .left
        return _backButton
    }()
    
    // 保存按钮
    lazy var saveButton: UIButton = {
        let _saveButton = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
        _saveButton.setTitleColor(UIColor.gray, for: .normal)
        _saveButton.setImage(UIImage(named: "icon_download_white_16x16_"), for: .normal)
        _saveButton.addTarget(self, action: #selector(save(sender:)), for: .touchUpInside)
        _saveButton.contentHorizontalAlignment = .right
        _saveButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        return _saveButton
    }()
    
    // 撤销按钮
    lazy var undoButton: UIButton = {
        let _undoButton = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
        _undoButton.setTitleColor(UIColor.gray, for: .normal)
        _undoButton.setImage(UIImage(named: "btn_undo_30x30_"), for: .normal)
        _undoButton.addTarget(self, action: #selector(revoke(sender:)), for: .touchUpInside)
        return _undoButton
    }()
    
    // 恢复按钮
    lazy var redoButton: UIButton = {
        let _redoButton = UIButton(frame: CGRect(x: 60, y: 0, width: 60, height: 40))
        _redoButton.setImage(UIImage(named: "btn_redo_30x30_"), for: .normal)
        _redoButton.setTitleColor(UIColor.gray, for: .normal)
        _redoButton.addTarget(self, action: #selector(recover(sender:)), for: .touchUpInside)
        return _redoButton
    }()
    
    // 标题View
    lazy var titleView: UIView = {
        
        let _titleView = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 40))
        _titleView.backgroundColor = UIColor.clear
        return _titleView
    }()
    
    // scrollView
    lazy var imageScrollView: UIScrollView = {
        
        let _imageScrollView = UIScrollView(frame: CGRect(x: 0, y: 44, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 44 - 50))
        _imageScrollView.backgroundColor = UIColor.colorWithHexString(hex: "#2c2e30")
        _imageScrollView.alwaysBounceVertical = true
        _imageScrollView.alwaysBounceHorizontal = true
        _imageScrollView.maximumZoomScale = 4.0
        _imageScrollView.delegate = self
        return _imageScrollView
    }()
    
    // imageView
    lazy var imageView: UIImageView = {
        let _imageView = UIImageView(frame: CGRect(x: 0, y: 100, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width))
        _imageView.backgroundColor = UIColor.white
        return _imageView
    }()
    
    lazy var toolBar: ToolBarView = {
        let editItem = ToolBarItemObject()
        editItem.imageName = "icon_meihua_edit_normal_30x30_"
        editItem.highlightImageName = "icon_meihua_edit_highlighted_30x30_"
        editItem.titleName = "编辑"
        editItem.action = {
            self.editImage()
        }
        
        let enhanceItem = ToolBarItemObject()
        enhanceItem.imageName = "icon_meihua_enhance_normal_30x30_"
        enhanceItem.highlightImageName = "icon_meihua_enhance_highlighted_30x30_"
        enhanceItem.titleName = "增强"
        
        let filterItem = ToolBarItemObject()
        filterItem.imageName = "icon_meihua_filter_normal_30x30_"
        filterItem.highlightImageName = "icon_meihua_filter_highlighted_30x30_"
        filterItem.titleName = "特效"
        
        let stickerItem = ToolBarItemObject()
        stickerItem.imageName = "icon_meihua_sticker_normal_30x30_"
        stickerItem.highlightImageName = "icon_meihua_sticker_highlighted_30x30_"
        stickerItem.titleName = "贴纸"
        
        let _toolBar = ToolBarView(items: [editItem, enhanceItem, filterItem, stickerItem])
        return _toolBar
    }()

    // MARK: - Override Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.view.backgroundColor = UIColor.colorWithHexString(hex: "#2c2e30")
        // 保存按钮
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.saveButton)
        // 标题View - 撤销，恢复按钮
        self.titleView.addSubview(self.undoButton)
        self.titleView.addSubview(self.redoButton)
        self.navigationItem.titleView = self.titleView
        
        // 图片scrollView
        self.view.addSubview(self.imageScrollView)
        
        // imageView
        self.imageView.image = self.originImage
        self.imageView.frame = self.rectImageInScrollView()
        self.imageScrollView.addSubview(self.imageView)
        
        self.view.addSubview(self.toolBar)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Private Actions
    
    //将图片完整的放进scrollView中，并获取imageView.frame
    func rectImageInScrollView() -> CGRect {
        let imageBounds = self.imageScrollView.frame
        let imageRatio = self.originImage.size.width / self.originImage.size.height
        let viewRatio = imageBounds.size.width / imageBounds.size.height
        var size = CGSize.zero
        if imageRatio >= viewRatio {
            size = CGSize(width: imageBounds.size.width, height: imageBounds.size.width/imageRatio)
        }
        else {
            size = CGSize(width: imageBounds.size.height * imageRatio, height: imageBounds.size.height)
        }
        let origin = CGPoint(x: (imageBounds.size.width - size.width)/2, y: (imageBounds.size.height - size.height)/2)
        return CGRect(origin: origin, size: size)
    }
    
    // 返回
    func back(sender: UIButton) -> Void {
        self.dismiss(animated: true) { 
            
        }
    }
    
    // 保存
    func save(sender: UIButton) -> Void {
        
        self.dismiss(animated: true) {
            
        }
    }
    
    // 撤销
    func revoke(sender: UIButton) -> Void {
        
    }
    
    // 恢复
    func recover(sender: UIButton) -> Void {
        
    }
    
    // 编辑图片
    func editImage() -> Void {
        UIView.animate(withDuration: 0.2, animations: { 
            self.toolBar.frame = self.toolBar.frame.offsetBy(dx: 0, dy: self.toolBar.frame.size.height)
        }) { (finished) in
            if finished {
                let editImageVC = EditImageViewController()
                editImageVC.originImage = self.originImage
                editImageVC.modalPresentationStyle = .fullScreen
                editImageVC.transitioningDelegate = self
                self.present(editImageVC, animated: true) {
                    self.toolBar.frame = self.toolBar.frame.offsetBy(dx: 0, dy: -self.toolBar.frame.size.height)
                }
            }
        }
    }
}

extension BeautyCenterViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
