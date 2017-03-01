//
//  UserResizableView.swift
//  XiheMtxx
//
//  Created by echo on 2017/2/23.
//  Copyright © 2017年 羲和. All rights reserved.
//

import UIKit

protocol UserResizableViewDelegate: NSObjectProtocol {
    func resizeView() -> Void
}

class UserResizableView: UIView {
    var imageBounds: CGRect!
    let cornerImageWidth: CGFloat = 45.0
    var aspectRatio: CGFloat = 0.0
    weak var delegate: UserResizableViewDelegate?
    let limitSize = CGSize(width: 90.0, height: 90.0)
    
    var translationRatio: RatioType = .ratio_free {
        didSet {
            let _ratio = self.translationRatio.info().aspectRatio
            if _ratio.height == 0 || _ratio.width == 0 {
                self.aspectRatio = 0
            }
            self.aspectRatio = _ratio.width / _ratio.height
        }
    }

    lazy var gridBorderView: GridBorderView = {
        let _gridBorderView = GridBorderView(frame: CGRect.zero)
        _gridBorderView.isUserInteractionEnabled = true
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(moveAllView(sender:)))
        _gridBorderView.addGestureRecognizer(panGesture)
        return _gridBorderView
    }()
    
    lazy var sizeLabel: UILabel = {
        let _sizeLabel = UILabel(frame: CGRect.zero)
        _sizeLabel.textColor = UIColor.white
        _sizeLabel.textAlignment = .center
        _sizeLabel.shadowColor = UIColor.black.withAlphaComponent(0.5)
        _sizeLabel.shadowOffset = CGSize(width: 1, height: 1)
        return _sizeLabel
    }()
    
    lazy var leftTopCorner: UIImageView = {
        let _leftTopCorner = UIImageView(frame: CGRect.zero)
        _leftTopCorner.image = UIImage(named: "btn_clip_dragCorner_35x35_")
        _leftTopCorner.isUserInteractionEnabled = true
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(leftTopCornerPan(sender:)))
        _leftTopCorner.addGestureRecognizer(panGesture)
        return _leftTopCorner
    }()
    
    lazy var centerTopCorner: UIImageView = {
        let _centerTopCorner = UIImageView(frame:CGRect.zero)
        _centerTopCorner.image = UIImage(named: "btn_clip_horizen_35x35_")
        _centerTopCorner.isUserInteractionEnabled = true
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(centerTopCornerPan(sender:)))
        _centerTopCorner.addGestureRecognizer(panGesture)
        return _centerTopCorner
    }()
    
    lazy var rightTopCorner: UIImageView = {
        let _rightTopCorner = UIImageView(frame: CGRect.zero)
        let image = UIImage(named: "btn_clip_dragCorner_35x35_")
        _rightTopCorner.isUserInteractionEnabled = true
        _rightTopCorner.image = UIImage(cgImage: (image?.cgImage)!, scale: 1, orientation: UIImageOrientation.right)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(rightTopCornerPan(sender:)))
        _rightTopCorner.addGestureRecognizer(panGesture)
        return _rightTopCorner
    }()
    
    lazy var leftCenterCorner: UIImageView = {
        let _leftCenterCorner = UIImageView(frame:CGRect.zero)
        let image = UIImage(named: "btn_clip_horizen_35x35_")
        _leftCenterCorner.isUserInteractionEnabled = true
        _leftCenterCorner.image = UIImage(cgImage: (image?.cgImage)!, scale: 1, orientation: UIImageOrientation.right)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(leftCenterCornerPan(sender:)))
        _leftCenterCorner.addGestureRecognizer(panGesture)
        return _leftCenterCorner
    }()
    
    lazy var rightCenterCorner: UIImageView = {
        let _rightCenterCorner = UIImageView(frame:CGRect.zero)
        let image = UIImage(named: "btn_clip_horizen_35x35_")
        _rightCenterCorner.isUserInteractionEnabled = true
        _rightCenterCorner.image = UIImage(cgImage: (image?.cgImage)!, scale: 1, orientation: UIImageOrientation.right)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(rightCenterCornerPan(sender:)))
        _rightCenterCorner.addGestureRecognizer(panGesture)
        return _rightCenterCorner
    }()
    
    lazy var leftBottomCorner: UIImageView = {
        let _leftBottomCorner = UIImageView(frame:CGRect.zero)
        let image = UIImage(named: "btn_clip_dragCorner_35x35_")
        _leftBottomCorner.isUserInteractionEnabled = true
        _leftBottomCorner.image = UIImage(cgImage: (image?.cgImage)!, scale: 1, orientation: UIImageOrientation.downMirrored)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(leftBottomCornerPan(sender:)))
        _leftBottomCorner.addGestureRecognizer(panGesture)
        return _leftBottomCorner
    }()
    
    lazy var centerBottomCorner: UIImageView = {
        let _centerBottomCorner = UIImageView(frame:CGRect.zero)
        _centerBottomCorner.image = UIImage(named: "btn_clip_horizen_35x35_")
        _centerBottomCorner.isUserInteractionEnabled = true
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(centerBottomCornerPan(sender:)))
        _centerBottomCorner.addGestureRecognizer(panGesture)
        return _centerBottomCorner
    }()
    
    lazy var rightBottomCorner: UIImageView = {
        let _rightBottomCorner = UIImageView(frame:CGRect.zero)
        let image = UIImage(named: "btn_clip_dragCorner_35x35_")
        _rightBottomCorner.isUserInteractionEnabled = true
        _rightBottomCorner.image = UIImage(cgImage: (image?.cgImage)!, scale: 1, orientation: UIImageOrientation.rightMirrored)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(rightBottomCornerPan(sender:)))
        _rightBottomCorner.addGestureRecognizer(panGesture)
        return _rightBottomCorner
    }()

    // MARK: Override Method
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = false
        self.addSubview(self.sizeLabel)
        self.addSubview(self.gridBorderView)
        self.addSubview(self.leftTopCorner)
        self.addSubview(self.leftCenterCorner)
        self.addSubview(self.leftBottomCorner)
        self.addSubview(self.centerTopCorner)
        self.addSubview(self.centerBottomCorner)
        self.addSubview(self.rightTopCorner)
        self.addSubview(self.rightCenterCorner)
        self.addSubview(self.rightBottomCorner)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.sizeLabel.frame = CGRect(origin: CGPoint.zero, size: self.frame.size)
        self.gridBorderView.frame = CGRect(origin: CGPoint.zero, size: self.frame.size)
        self.leftTopCorner.frame = CGRect(x: -cornerImageWidth/2, y: -cornerImageWidth/2, width: cornerImageWidth, height: cornerImageWidth)
        self.centerTopCorner.frame = CGRect(x: (self.frame.width-cornerImageWidth)/2, y: -cornerImageWidth/2, width: cornerImageWidth, height: cornerImageWidth)
        self.rightTopCorner.frame = CGRect(x: self.frame.width-cornerImageWidth/2, y: -cornerImageWidth/2, width: cornerImageWidth, height: cornerImageWidth)
        self.leftCenterCorner.frame = CGRect(x: -cornerImageWidth/2, y: (self.frame.height-cornerImageWidth)/2, width: cornerImageWidth, height: cornerImageWidth)
        self.rightCenterCorner.frame = CGRect(x: self.frame.width-cornerImageWidth/2, y: (self.frame.height-cornerImageWidth)/2, width: cornerImageWidth, height: cornerImageWidth)
        self.leftBottomCorner.frame = CGRect(x: -cornerImageWidth/2, y: self.frame.height-cornerImageWidth/2, width: cornerImageWidth, height: cornerImageWidth)
        self.centerBottomCorner.frame = CGRect(x: (self.frame.width-cornerImageWidth)/2, y: self.frame.height-cornerImageWidth/2, width: cornerImageWidth, height: cornerImageWidth)
        self.rightBottomCorner.frame = CGRect(x: self.frame.width-cornerImageWidth/2, y: self.frame.height-cornerImageWidth/2, width: cornerImageWidth, height: cornerImageWidth)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 扩大各个角拖动的热点
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if self.isHidden {
            return nil
        }
        
        if self.leftBottomCorner.frame.contains(point) && !self.leftBottomCorner.isHidden {
            return self.leftBottomCorner
        }
        
        if self.leftTopCorner.frame.contains(point) && !self.leftTopCorner.isHidden {
            return self.leftTopCorner
        }
        
        if self.leftCenterCorner.frame.contains(point) && !self.leftCenterCorner.isHidden {
            return self.leftCenterCorner
        }
        
        if self.centerTopCorner.frame.contains(point) && !self.centerTopCorner.isHidden {
            return self.centerTopCorner
        }
        
        if self.centerBottomCorner.frame.contains(point) && !self.centerBottomCorner.isHidden {
            return self.centerBottomCorner
        }
        
        if self.rightTopCorner.frame.contains(point) && !self.rightTopCorner.isHidden {
            return self.rightTopCorner
        }
        
        if self.rightCenterCorner.frame.contains(point) && !self.rightCenterCorner.isHidden {
            return self.rightCenterCorner
        }
        
        if self.rightBottomCorner.frame.contains(point) && !self.rightBottomCorner.isHidden {
            return self.rightBottomCorner
        }
       
        if self.gridBorderView.frame.contains(point) && !self.gridBorderView.isHidden {
            return self.gridBorderView
        }
        return self
    }
    
    // MARK: Public Method
    // 隐藏中间的图片
    func setCenterImageHidden(hidden: Bool) -> Void {
        self.leftCenterCorner.isHidden = hidden
        self.rightCenterCorner.isHidden = hidden
        self.centerTopCorner.isHidden = hidden
        self.centerBottomCorner.isHidden = hidden
    }
    
    // MARK: 手势事件
    
    // 拖拽移动事件
    func moveAllView(sender: UIPanGestureRecognizer) -> Void {
        let translationPoint = sender.translation(in: self)
        
        var origin = self.frame.origin
        let size = self.frame.size
        
        // x,y坐标按手势移动
        origin.x += translationPoint.x
        origin.y += translationPoint.y
        
        // x限制在左边界
        if origin.x < self.imageBounds.origin.x {
            origin.x = self.imageBounds.origin.x
        }
        
        // x限制在右边界
        if origin.x > self.imageBounds.maxX - size.width {
            origin.x = self.imageBounds.maxX - size.width
        }
        
        // y限制在上边界
        if origin.y < self.imageBounds.origin.y {
            origin.y = self.imageBounds.origin.y
        }
        
        // y限制在下边界
        if origin.y > self.imageBounds.maxY - size.height {
            origin.y = self.imageBounds.maxY - size.height
        }
        
        self.frame = CGRect(origin: origin, size: size)
        sender.setTranslation(CGPoint.zero, in: self)
        
        if sender.state == .ended {
            self.delegate?.resizeView()
        }
        
    }
    
    // 左上角
    func leftTopCornerPan(sender: UIPanGestureRecognizer) -> Void {
        let translationPoint = sender.translation(in: self)
        var origin = self.frame.origin
        var size = self.frame.size
        var isWidthStandard = fabsf(Float(translationPoint.x)) > fabsf(Float(translationPoint.y))
    
        // --------x---------
        // x,y坐标按手势移动
        origin.x += translationPoint.x
        origin.y += translationPoint.y
        
        // x限制在左边界
        if origin.x < self.imageBounds.minX {
            origin.x = self.imageBounds.minX
            isWidthStandard = true
        }
        
        // x限制在右边界
        if origin.x > self.frame.maxX - self.limitSize.width {
            origin.x = self.frame.maxX - self.limitSize.width
            isWidthStandard = true
        }
        
        size.width = self.frame.maxX - origin.x
        
        // --------y---------
        // 如果y超出界限，限制在边界内
        if origin.y < self.imageBounds.minY {
            origin.y = self.imageBounds.minY
            isWidthStandard = false
        }
        
        // 如果高度小于限制，则取limitSize.height
        if origin.y > self.frame.maxY - self.limitSize.height {
            origin.y = self.frame.maxY - self.limitSize.height
            isWidthStandard = false
        }
        
        size.height = self.frame.maxY - origin.y
        
        // 如果比例类型不是free
        if self.translationRatio != .ratio_free {
            
            // 哪个方向滑动的最大为标准
            if isWidthStandard {
                size.height = size.width / self.aspectRatio
                origin.y = self.frame.maxY - size.height
            }
            else {
                size.width = size.height * self.aspectRatio
                origin.x = self.frame.maxX - size.width
            }
        }
        
        self.frame = CGRect(origin: origin, size: size)
        sender.setTranslation(CGPoint.zero, in: self)
        if sender.state == .ended {
            self.delegate?.resizeView()
        }
    }
    
    // 左下角
    func leftBottomCornerPan(sender: UIPanGestureRecognizer) -> Void {
        let translationPoint = sender.translation(in: self)
        
        var origin = self.frame.origin
        var size = self.frame.size
        var isWidthStandard = fabsf(Float(translationPoint.x)) > fabsf(Float(translationPoint.y))
        
        // x,height按手势移动
        origin.x += translationPoint.x
        size.height += translationPoint.y
        
        // ----------------x-width--------------------
        // 限制x超出左边界
        if origin.x < self.imageBounds.minX {
            origin.x = self.imageBounds.minX
            isWidthStandard = true
        }
        
        // 限制x超出右边界
        if self.frame.maxX - origin.x < self.limitSize.width {
            origin.x = self.frame.maxX - self.limitSize.width
            isWidthStandard = true
        }
        
        size.width = self.frame.maxX - origin.x
        
        // ----------------y--------------------
        // 如果y超出界限，限制在边界内
        if self.frame.minY + size.height > self.imageBounds.maxY {
            size.height = self.imageBounds.maxY - self.frame.minY
            isWidthStandard = false
        }
        
        // 如果高度小于限制，则取limitSize.height
        if size.height < self.limitSize.height {
            size.height = self.limitSize.height
            isWidthStandard = false
        }
        
        // 如果比例类型不是free
        if self.translationRatio != .ratio_free {
            
            // 以宽为标准缩放
            if isWidthStandard {
                
                size.height = size.width / self.aspectRatio
            }
            else {
                
                size.width = size.height * self.aspectRatio
                origin.x = self.frame.maxX - size.width
            }
        }
        
        self.frame = CGRect(origin: origin, size: size)
        sender.setTranslation(CGPoint.zero, in: self)
        if sender.state == .ended {
            self.delegate?.resizeView()
        }
    }
    
    // 右上角
    func rightTopCornerPan(sender: UIPanGestureRecognizer) -> Void {
        let translationPoint = sender.translation(in: self)
        
        var origin = self.frame.origin
        var size = self.frame.size
        var isWidthStandard = fabsf(Float(translationPoint.x)) > fabsf(Float(translationPoint.y))
        
        // y, width按手势移动
        origin.y += translationPoint.y
        size.width += translationPoint.x
        
        // y限制在上边界
        if origin.y < self.imageBounds.origin.y {
            origin.y = self.imageBounds.origin.y
            isWidthStandard = false
        }
        
        // y限制在下边界
        if origin.y > self.frame.maxY - self.limitSize.height {
            origin.y = self.frame.maxY - self.limitSize.height
            isWidthStandard = false
        }
        size.height = self.frame.maxY - origin.y
        
        // width限制在最大边界
        if self.frame.minX + size.width > self.imageBounds.maxX {
            size.width = self.imageBounds.maxX - self.frame.minX
            isWidthStandard = true
        }
        
        // 如果高度小于限制，则取limitSize.height
        if size.width < self.limitSize.width {
            size.width = self.limitSize.width
            isWidthStandard = true
        }
        
        // 如果比例类型不是free
        if self.translationRatio != .ratio_free {
            
            // 以宽为标准缩放
            if isWidthStandard {
                
                size.height = size.width / self.aspectRatio
                origin.y = self.frame.maxY - size.height
            }
            else {
                
                size.width = size.height * self.aspectRatio
            }
        }
        
        self.frame = CGRect(origin: origin, size: size)
        sender.setTranslation(CGPoint.zero, in: self)
        if sender.state == .ended {
            self.delegate?.resizeView()
        }
    }
    
    // 右下角
    func rightBottomCornerPan(sender: UIPanGestureRecognizer) -> Void {
        let translationPoint = sender.translation(in: self)
        
        let origin = self.frame.origin
        var size = self.frame.size
        var isWidthStandard = fabsf(Float(translationPoint.x)) > fabsf(Float(translationPoint.y))
        
        // y, width按手势移动
        size.width += translationPoint.x
        size.height += translationPoint.y
        
        // width限制在左边界
        if size.width < self.limitSize.width {
            size.width = self.limitSize.width
            isWidthStandard = true
        }
        
        // width限制在右边界
        if size.width > self.imageBounds.maxX - self.frame.minX {
            size.width = self.imageBounds.maxX - self.frame.minX
            isWidthStandard = true
        }
        
        // height限制在上边界
        if size.height < self.limitSize.height {
            size.height = self.limitSize.height
            isWidthStandard = false
        }
        
        // height限制在下边界
        if size.height > self.imageBounds.maxY - self.frame.minY {
            size.height = self.imageBounds.maxY - self.frame.minY
            isWidthStandard = false
        }
        
        // 如果比例类型不是free
        if self.translationRatio != .ratio_free {
            
            // 以宽为标准缩放
            if isWidthStandard {
                
                size.height = size.width / self.aspectRatio
            }
            else {
                
                size.width = size.height * self.aspectRatio
            }
        }
        
        self.frame = CGRect(origin: origin, size: size)
        sender.setTranslation(CGPoint.zero, in: self)
        if sender.state == .ended {
            self.delegate?.resizeView()
        }
    }
    
    // 左中
    func leftCenterCornerPan(sender: UIPanGestureRecognizer) -> Void {
        let translationPoint = sender.translation(in: self)
        
        var origin = self.frame.origin
        var size = self.frame.size
        
        if self.boundInLeft(translationPoint: translationPoint)  {
            origin.x += translationPoint.x
            size.width -= translationPoint.x
        }
        
        self.frame = CGRect(origin: origin, size: size)
        sender.setTranslation(CGPoint.zero, in: self)
        if sender.state == .ended {
            self.delegate?.resizeView()
        }
    }
    
    // 右中
    func rightCenterCornerPan(sender: UIPanGestureRecognizer) -> Void {
        let translationPoint = sender.translation(in: self)
        
        let origin = self.frame.origin
        var size = self.frame.size
        
        if self.boundInRight(translationPoint: translationPoint) {
            size.width += translationPoint.x
        }
        
        self.frame = CGRect(origin: origin, size: size)
        sender.setTranslation(CGPoint.zero, in: self)
        
        if sender.state == .ended {
            self.delegate?.resizeView()
        }
    }
    
    // 上中
    func centerTopCornerPan(sender: UIPanGestureRecognizer) -> Void {
        let translationPoint = sender.translation(in: self)
        
        var origin = self.frame.origin
        var size = self.frame.size
        
        if self.boundInTop(translationPoint: translationPoint) {
            origin.y += translationPoint.y
            size.height -= translationPoint.y
        }
        
        self.frame = CGRect(origin: origin, size: size)
        sender.setTranslation(CGPoint.zero, in: self)
        
        if sender.state == .ended {
            self.delegate?.resizeView()
        }
    }
    
    // 下中
    func centerBottomCornerPan(sender: UIPanGestureRecognizer) -> Void {
        let translationPoint = sender.translation(in: self)
        
        let origin = self.frame.origin
        var size = self.frame.size
        
        if self.boundInBottom(translationPoint: translationPoint) {
            size.height += translationPoint.y
        }
        
        self.frame = CGRect(origin: origin, size: size)
        sender.setTranslation(CGPoint.zero, in: self)
        
        if sender.state == .ended {
            self.delegate?.resizeView()
        }
    }
    
    // MARK: Private Method
    
    // 是否在左边界内
    func boundInLeft(translationPoint: CGPoint) -> Bool {
        let origin = self.frame.origin
        
        let x = origin.x + translationPoint.x
        return x > self.imageBounds.minX
            && (self.frame.maxX - x) > self.limitSize.width
    }
    
    // 是否在右边界内
    func boundInRight(translationPoint: CGPoint) -> Bool {
        let origin = self.frame.origin
        let size = self.frame.size
        
        let w = size.width + translationPoint.x
        return w + origin.x < self.imageBounds.maxX
            && w > self.limitSize.width
    }
    
    // 是否在上边界内
    func boundInTop(translationPoint: CGPoint) -> Bool {
        let origin = self.frame.origin
        let y = origin.y + translationPoint.y
        
        return y > self.imageBounds.minY
            && (self.frame.maxY - y) > self.limitSize.height
    }
    
    // 是否在下边界内
    func boundInBottom(translationPoint: CGPoint) -> Bool {
        let origin = self.frame.origin
        let size = self.frame.size
        
        let h = size.height + translationPoint.y
        return h + origin.y < self.imageBounds.maxY
            && h > self.limitSize.height
    }
    
}
