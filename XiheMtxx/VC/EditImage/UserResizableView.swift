//
//  UserResizableView.swift
//  XiheMtxx
//
//  Created by echo on 2017/2/23.
//  Copyright © 2017年 羲和. All rights reserved.
//

import UIKit

class UserResizableView: UIView {
    lazy var gridBorderView: GridBorderView = {
        let _gridBorderView = GridBorderView(frame: CGRect.zero)
        return _gridBorderView
    }()
    
    lazy var sizeLabel: UILabel = {
        let _sizeLabel = UILabel(frame: CGRect.zero)
        _sizeLabel.textColor = UIColor.white
        _sizeLabel.textAlignment = .center
        return _sizeLabel
    }()
    
    lazy var leftTopCorner: UIImageView = {
        let _leftTopCorner = UIImageView(frame: CGRect.zero)
        _leftTopCorner.image = UIImage(named: "btn_clip_dragCorner_35x35_")
        return _leftTopCorner
    }()
    
    lazy var centerTopCorner: UIImageView = {
        let _centerTopCorner = UIImageView(frame:CGRect.zero)
        _centerTopCorner.image = UIImage(named: "btn_clip_horizen_35x35_")
        return _centerTopCorner
    }()
    
    lazy var rightTopCorner: UIImageView = {
        let _rightTopCorner = UIImageView(frame: CGRect.zero)
        let image = UIImage(named: "btn_clip_dragCorner_35x35_")
        _rightTopCorner.image = UIImage(cgImage: (image?.cgImage)!, scale: 1, orientation: UIImageOrientation.right)
        return _rightTopCorner
    }()
    
    lazy var leftCenterCorner: UIImageView = {
        let _leftCenterCorner = UIImageView(frame:CGRect.zero)
        let image = UIImage(named: "btn_clip_horizen_35x35_")
        _leftCenterCorner.image = UIImage(cgImage: (image?.cgImage)!, scale: 1, orientation: UIImageOrientation.right)
        return _leftCenterCorner
    }()
    
    lazy var rightCenterCorner: UIImageView = {
        let _rightCenterCorner = UIImageView(frame:CGRect.zero)
        let image = UIImage(named: "btn_clip_horizen_35x35_")
        _rightCenterCorner.image = UIImage(cgImage: (image?.cgImage)!, scale: 1, orientation: UIImageOrientation.right)
        return _rightCenterCorner
    }()
    
    lazy var leftBottomCorner: UIImageView = {
        let _leftBottomCorner = UIImageView(frame:CGRect.zero)
        let image = UIImage(named: "btn_clip_dragCorner_35x35_")
        _leftBottomCorner.image = UIImage(cgImage: (image?.cgImage)!, scale: 1, orientation: UIImageOrientation.downMirrored)
        return _leftBottomCorner
    }()
    
    lazy var centerBottomCorner: UIImageView = {
        let _centerBottomCorner = UIImageView(frame:CGRect.zero)
        _centerBottomCorner.image = UIImage(named: "btn_clip_horizen_35x35_")
        return _centerBottomCorner
    }()
    
    lazy var rightBottomCorner: UIImageView = {
        let _rightBottomCorner = UIImageView(frame:CGRect.zero)
        let image = UIImage(named: "btn_clip_dragCorner_35x35_")
        _rightBottomCorner.image = UIImage(cgImage: (image?.cgImage)!, scale: 1, orientation: UIImageOrientation.rightMirrored)
        return _rightBottomCorner
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
        self.leftTopCorner.frame = CGRect(x: -17.5, y: -17.5, width: 35, height: 35)
        self.centerTopCorner.frame = CGRect(x: (self.frame.width-35)/2, y: -17.5, width: 35, height: 35)
        self.rightTopCorner.frame = CGRect(x: self.frame.width-17.5, y: -17.5, width: 35, height: 35)
        self.leftCenterCorner.frame = CGRect(x: -17.5, y: (self.frame.height-35)/2, width: 35, height: 35)
        self.rightCenterCorner.frame = CGRect(x: self.frame.width-17.5, y: (self.frame.height-35)/2, width: 35, height: 35)
        self.leftBottomCorner.frame = CGRect(x: -17.5, y: self.frame.height-17.5, width: 35, height: 35)
        self.centerBottomCorner.frame = CGRect(x: (self.frame.width-35)/2, y: self.frame.height-17.5, width: 35, height: 35)
        self.rightBottomCorner.frame = CGRect(x: self.frame.width-17.5, y: self.frame.height-17.5, width: 35, height: 35)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 隐藏中间的图片
    func setCenterImageHidden(hidden: Bool) -> Void {
        self.leftCenterCorner.isHidden = hidden
        self.rightCenterCorner.isHidden = hidden
        self.centerTopCorner.isHidden = hidden
        self.centerBottomCorner.isHidden = hidden
    }
    
}
