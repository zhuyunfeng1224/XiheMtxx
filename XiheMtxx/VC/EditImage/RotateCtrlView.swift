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
    
    var originImage: UIImage? {
        didSet {
            self.imageView.image = originImage
            self.image = originImage
        }
    }
    
    var image: UIImage? {
        didSet {
            self.imageView.image = image
        }
    }
    
    var rotation: CGFloat = 0.0
    
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
            UIView.animate(withDuration: 0.3, animations: {
                let scale = self.imageViewScale()
                self.imageView.transform = self.imageView.transform.scaledBy(x: scale, y: scale)
                self.clearMaskView.frame = self.imageView.bounds
                self.clearMaskView.center = self.imageView.center
                self.clearMaskView.clearFrame = self.imageView.bounds
            })
        }
        lastPosition = gesture.location(in: self.bgView)
    }
    
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
        UIView.animate(withDuration: 0.3, animations: {
            let scale = self.imageViewScale()
            self.imageView.transform = self.imageView.transform.scaledBy(x: scale, y: scale)
            self.clearMaskView.frame = self.imageView.bounds
            self.clearMaskView.center = self.imageView.center
            self.clearMaskView.clearFrame = self.imageView.bounds
        })
    }
}
