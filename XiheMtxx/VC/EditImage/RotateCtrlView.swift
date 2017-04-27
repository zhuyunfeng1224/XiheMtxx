//
//  RotateCtrlView.swift
//  XiheMtxx
//
//  Created by echo on 2017/3/3.
//  Copyright © 2017年 羲和. All rights reserved.
//

import UIKit

class RotateCtrlView: UIView {

    lazy var bgView: UIView = {
        let _bgView = UIView(frame: CGRect(origin: CGPoint.zero, size: self.frame.size))
        _bgView.backgroundColor = UIColor.colorWithHexString(hex: "#2c2e30")
        _bgView.clipsToBounds = true
        return _bgView
    }()
    
    lazy var imageView: UIImageView = {
        let _imageView = UIImageView(frame: CGRect(origin: CGPoint.zero, size: self.frame.size))
        _imageView.clipsToBounds = true
        _imageView.contentMode = .scaleAspectFit
        return _imageView
    }()
    
    lazy var clearMaskView: GrayView = {
        let _maskView = GrayView(frame: CGRect(origin: CGPoint.zero, size: self.frame.size))
        _maskView.clearFrame = CGRect(origin: CGPoint.zero, size: self.frame.size)
        _maskView.isUserInteractionEnabled = false
        return _maskView
    }()
    
    //  结束执行块
    var dismissCompletation: ((UIImage) -> (Void))?
    
    /// 原始图片
    var originImage: UIImage? {
        didSet {
            self.imageView.image = originImage
            self.image = originImage
        }
    }
    
    /// 编辑后的图片
    var image: UIImage? {
        didSet {
            self.imageView.image = image
        }
    }
    
    
    /// 旋转角度
    var rotation: CGFloat = 0.0
    
    /// 上一次拖动的位置
    lazy var lastPosition = CGPoint.zero
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        self.addSubview(self.bgView)
        self.bgView.addSubview(self.imageView)
        self.addSubview(self.clearMaskView)
        
        // 拖动手势
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panImage(gesture:)))
        self.bgView.addGestureRecognizer(panGesture)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.bgView.frame = CGRect(origin: CGPoint.zero, size: self.frame.size)
        self.imageView.frame = CGRect(origin: CGPoint.zero, size: self.frame.size)
        self.clearMaskView.frame = CGRect(origin: CGPoint.zero, size: self.frame.size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func removeFromSuperview() {
        
        assert(self.image?.cgImage != nil, "图片丢失")
        // 生成剪切后的图片
        if let cgImage = self.newTransformedImage(transform: self.imageView.transform,
                                                  sourceImage: (self.image?.cgImage)!,
                                                  imageSize: (self.image?.size)!) {
            self.image = UIImage(cgImage: cgImage)
        }
        if let dismissCompletation = self.dismissCompletation {
            dismissCompletation(self.image!)
            self.imageView.transform = .identity
        }
    }
    
    
    // MARK: Action Events
    
    // 拖动手势响应
    func panImage(gesture: UIPanGestureRecognizer) -> Void {
        if gesture.state == .changed {
            let origin = CGPoint(x: self.bgView.frame.size.width/2, y: self.bgView.frame.size.height/2)
            
            let currentPosition = gesture.location(in: self.bgView)
            let vectorA = CGPoint(x: lastPosition.x - origin.x, y: lastPosition.y - origin.y)
            let vectorB = CGPoint(x: currentPosition.x - origin.x, y: currentPosition.y - origin.y)
            
            // 向量a的模
            let modA = sqrtf(powf(Float(vectorA.x), 2) + powf(Float(vectorA.y), 2))
            // 向量b的模
            let modB = sqrtf(powf(Float(vectorB.x), 2) + powf(Float(vectorB.y), 2))
            // 向量a，b的点乘
            let pointMuti = Float(vectorA.x * vectorB.x + vectorA.y * vectorB.y)
            
            // 夹角
            let angle = acos(pointMuti / (modA * modB))
            
            // 叉乘求旋转方向，顺时针还是逆时针
            let crossAB = vectorA.x * vectorB.y - vectorA.y * vectorB.x
            let sign: Float = crossAB > 0.0 ? 1.0: -1.0
            
            if !angle.isNaN && angle != 0.0 {
                rotation += CGFloat(angle * sign)
                self.imageView.transform = CGAffineTransform(rotationAngle: rotation)
                self.clearMaskView.clearFrame = self.caculateCutRect()
            }
        }
        else if gesture.state == .ended || gesture.state == .cancelled {
            
            // 裁剪区域放到最大
            self.enlargeWhenTouchUp()
        }
        lastPosition = gesture.location(in: self.bgView)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.3, animations: { 
            self.imageView.transform = CGAffineTransform(rotationAngle: self.rotation)
            self.clearMaskView.frame = self.imageView.bounds
            self.clearMaskView.center = self.imageView.center
            self.clearMaskView.clearFrame = self.caculateCutRect()
        })
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 裁剪区域放到最大
       self.enlargeWhenTouchUp()
    }
    
    
    // MARK: Private Method
    
    // 计算剪切区域
    func caculateCutRect() -> CGRect {
        let scale = self.imageViewScale()
        
        let cutSize = self.imageView.bounds.size.applying(CGAffineTransform(scaleX: 1/scale, y: 1/scale))
        let cutFrame = CGRect(x: self.imageView.center.x - cutSize.width/2,
                              y: self.imageView.center.y - cutSize.height/2,
                              width: cutSize.width,
                              height: cutSize.height)
        return cutFrame
    }
    
    // 旋转之后图片放大的倍数
    func imageViewScale() -> CGFloat {
        let scaleX = self.imageView.frame.size.width/self.imageView.bounds.size.width
        let scaleY = self.imageView.frame.size.height/self.imageView.bounds.size.height
        let scale = fabsf(Float(scaleX)) > fabsf(Float(scaleY)) ? scaleX : scaleY
        return scale
    }
    
    // 裁剪区域放到最大
    func enlargeWhenTouchUp() -> Void {
        UIView.animate(withDuration: 0.3, animations: {
            let scale = self.imageViewScale()
            self.imageView.transform = self.imageView.transform.scaledBy(x: scale, y: scale)
            self.clearMaskView.frame = self.imageView.bounds
            self.clearMaskView.center = self.imageView.center
            self.clearMaskView.clearFrame = self.imageView.bounds
        })
    }
    
    
    /// create a new image according to transform and origin image
    ///
    /// - Parameters:
    ///   - transform: the transform after image rotated
    ///   - sourceImage: sourceImage
    ///   - imageSize: size of sourceImage
    /// - Returns: new Image
    func newTransformedImage(transform: CGAffineTransform,
                             sourceImage:CGImage,
                             imageSize: CGSize) -> CGImage? {
        
        // 计算旋转后图片的大小
        let size = CGSize(width: imageSize.width * self.imageViewScale(), height: imageSize.height * self.imageViewScale())
        
        // 创建画布
        let context = CGContext.init(data: nil,
                                     width: Int(imageSize.width),
                                     height: Int(imageSize.height),
                                     bitsPerComponent: sourceImage.bitsPerComponent,
                                     bytesPerRow: 0,
                                     space: sourceImage.colorSpace!,
                                     bitmapInfo: sourceImage.bitmapInfo.rawValue)
        
        context?.setFillColor(UIColor.clear.cgColor)
        context?.fill(CGRect(origin: CGPoint.zero, size: imageSize))
        
        // quartz旋转以左上角为中心，so 将画布移到右下角，旋转之后再向上移到原来位置
        context?.translateBy(x: imageSize.width / 2, y: imageSize.height / 2)
        context?.concatenate(transform.inverted())
        context?.translateBy(x: -size.width / 2, y: -size.height / 2)
        
        context?.draw(sourceImage, in: CGRect(x: 0,
                                              y: 0,
                                              width: size.width,
                                              height: size.height))
        
        let result = context?.makeImage()
        assert(result != nil, "旋转图片剪切失败")
        UIGraphicsEndImageContext()
        return result!
    }
}
