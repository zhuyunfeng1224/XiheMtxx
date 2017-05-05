//
//  CutCtrlView.swift
//  XiheMtxx
//
//  Created by echo on 2017/5/4.
//  Copyright © 2017年 羲和. All rights reserved.
//

import UIKit

class CutCtrlView: UIView {

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
    
    // 尺寸调整View
    lazy var cutResizableView: UserResizableView = {
        let _cutResizableView = UserResizableView(frame: CGRect.zero)
        _cutResizableView.isHidden = true
        return _cutResizableView
    }()
    
    /// 原始图片
    var originImage: UIImage? {
        didSet {
            self.imageView.image = originImage
            self.image = originImage
        }
    }
    
    /// 编辑后的图片
    var image: UIImage! {
        didSet {
            self.imageView.image = image
        }
    }
    
    var ratioType: RatioType? {
        didSet {
            self.cutResizableView.isHidden = false
            self.cutResizableView.translationRatio = ratioType!
            self.cutResizableView.setCenterImageHidden(hidden: ratioType != .ratio_free)
            
            // 缩小后的图片像素尺寸
            let ratioSize = ratioType!.ratioDownInSize(originSize: (self.image?.size)!)
            
            // 缩小后的图片比例
            let scale = ratioSize.width / ratioSize.height
            
            // 原始图片View的尺寸
            let originImageScale = (self.image?.size.width)!/(self.image?.size.height)!
            let imageSizeInView = self.imageRectToFit().size
            
            // 按照比例在View中的大小截取图片
            var imageSizeAfterScaleDown = imageSizeInView
            if originImageScale <= scale {
                imageSizeAfterScaleDown = CGSize(width: imageSizeInView.width, height: imageSizeInView.width / scale)
            }
            else {
                imageSizeAfterScaleDown = CGSize(width: imageSizeInView.height * scale, height: imageSizeInView.height)
            }
            
            // 计算resizeView.frame
            let newOrigin = CGPoint(x: (imageSizeInView.width - imageSizeAfterScaleDown.width)/2, y: (imageSizeInView.height - imageSizeAfterScaleDown.height)/2)
            let resizeFrame = CGRect(origin: newOrigin, size: imageSizeAfterScaleDown)
            
            self.resetLayoutOfSubviews()
            self.cutResizableView.imageBounds = CGRect(origin: CGPoint.zero, size: imageSizeInView)
            self.cutResizableView.frame = resizeFrame
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.imageView)
        self.imageView.addSubview(self.grayView)
        self.imageView.addSubview(self.cutResizableView)
        self.cutResizableView.addObserver(self, forKeyPath: "frame", options: .new, context: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.cutResizableView.removeObserver(self, forKeyPath: "frame")
    }
    
    func resetLayoutOfSubviews() -> Void {
        let rect = self.imageRectToFit()
        self.imageView.frame = rect
        self.grayView.frame = CGRect(origin: CGPoint.zero, size: rect.size)
        self.grayView.clearFrame = self.cutResizableView.frame
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "frame" {
            let frame = change?[NSKeyValueChangeKey.newKey] as! CGRect
            if frame != CGRect.zero {
                self.grayView.clearFrame = frame
                self.cutResizableView.gridBorderView.setNeedsDisplay()
                
                // 缩小后的图片像素尺寸
                let cropPixelFrame = self.image.convertToPixelRect(fromRect: self.cutResizableView.frame, inRect: self.imageView.frame)
                self.cutResizableView.sizeLabel.text = "\(Int(cropPixelFrame.size.width)) × \(Int(cropPixelFrame.size.height))"
            }
        }
    }
    
    func imageRectToFit() -> CGRect {
        
        let rect = self.frame
        // 原始图片View的尺寸
        let originImageScale = self.image.size.width/self.image.size.height
        let imageViewSize = rect.size
        let imageViewScale = imageViewSize.width/imageViewSize.height
        var imageSizeInView = imageViewSize
        
        // 得出图片在ImageView中的尺寸
        if imageViewScale <= originImageScale {
            imageSizeInView = CGSize(width: imageViewSize.width, height: imageViewSize.width / originImageScale)
        }
        else {
            imageSizeInView = CGSize(width: imageViewSize.height * originImageScale, height: imageViewSize.height)
        }
        let imageOriginInView = CGPoint(x: (rect.size.width - imageSizeInView.width)/2, y: (rect.size.height - imageSizeInView.height)/2)
        
        return CGRect(origin: imageOriginInView, size: imageSizeInView)
    }
    
    func generateClipImage() -> UIImage {
        
        let rect = self.cutResizableView.frame
        let inRect = self.imageView.bounds
        // 剪切图片
        let cropPixelFrame = self.image.convertToPixelRect(fromRect: rect, inRect: inRect)
        let cropImageSize = cropPixelFrame.size
        let imgRef = self.image.cgImage?.cropping(to: cropPixelFrame)
        
        // 使用UIKit方法绘制图片，防止图片倒置
        UIGraphicsBeginImageContext(cropImageSize)
        let context = UIGraphicsGetCurrentContext()
        
        // 翻转坐标系
        context?.translateBy(x: 0, y: cropImageSize.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        // 画图片，并从context中取出
        context?.draw(imgRef!, in:  CGRect(origin: CGPoint.zero, size: cropImageSize))
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return finalImage!
    }
}
