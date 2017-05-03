//
//  GrayView.swift
//  EasyCard
//
//  Created by echo on 2017/2/21.
//  Copyright © 2017年 羲和. All rights reserved.
//

import UIKit

class GrayView: UIView {
    
    var clearFrame: CGRect = CGRect.zero {
        didSet {
            self.clearLayer.frame = self.bounds
            self.clearLayer.clearFrame = self.clearFrame
            self.clearLayer.setNeedsDisplay()
        }
    }
    
    var clearLayer = CenterClearLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clearLayer.frame = self.bounds
        self.layer.addSublayer(self.clearLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
