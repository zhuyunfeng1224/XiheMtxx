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
        return _sizeLabel
    }()
    
    lazy var leftTopCorner: UIImageView = {
        let _leftTopCorner = UIImageView()
        return _leftTopCorner
    }()
    
    lazy var centerTopCorner: UIImageView = {
        let _centerTopCorner = UIImageView()
        return _centerTopCorner
    }()
    
    lazy var rightTopCorner: UIImageView = {
        let _rightTopCorner = UIImageView()
        return _rightTopCorner
    }()
    
    lazy var leftCenterCorner: UIImageView = {
        let _leftCenterCorner = UIImageView()
        return _leftCenterCorner
    }()
    
    lazy var rightCenterCorner: UIImageView = {
        let _rightCenterCorner = UIImageView()
        return _rightCenterCorner
    }()
    
    lazy var leftBottomCorner: UIImageView = {
        let _leftBottomCorner = UIImageView()
        return _leftBottomCorner
    }()
    
    lazy var centerBottomCorner: UIImageView = {
        let _centerBottomCorner = UIImageView()
        return _centerBottomCorner
    }()
    
    lazy var rightBottomCorner: UIImageView = {
        let _rightBottomCorner = UIImageView()
        return _rightBottomCorner
    }()
}
