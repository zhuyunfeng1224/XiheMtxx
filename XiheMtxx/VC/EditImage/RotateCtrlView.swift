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
        return _bgView
    }()
    
    lazy var imageView: UIImageView = {
        let _imageView = UIImageView(frame: CGRect(origin: CGPoint.zero, size: self.frame.size))
        _imageView.contentMode = .scaleAspectFit
        _imageView.isUserInteractionEnabled = true
        return _imageView
    }()
    
    lazy var clearMaskView: GrayView = {
        let _maskView = GrayView(frame: CGRect(origin: CGPoint.zero, size: self.frame.size))
        _maskView.clearFrame = CGRect(origin: CGPoint.zero, size: self.frame.size)
        return _maskView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
//        self.addSubview(self.bgView)
//        self.bgView.addSubview(self.imageView)
//        self.addSubview(self.clearMaskView)
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(rotateImage(gesture:)))
        self.imageView.addGestureRecognizer(rotationGesture)
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
    
    func rotateImage(gesture: UIRotationGestureRecognizer) -> Void {
        let imageTransform = self.imageView.transform
//        imageTransform.rotated(by: gesture.rotation)
//        self.imageView.transform = imageTransform
//        gesture.rotation = 0.0
    }
}
