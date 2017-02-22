//
//  GrayView.swift
//  EasyCard
//
//  Created by echo on 2017/2/21.
//  Copyright © 2017年 羲和. All rights reserved.
//

import UIKit

class GrayView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
