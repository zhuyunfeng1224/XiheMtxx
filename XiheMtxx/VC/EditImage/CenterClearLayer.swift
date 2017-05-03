//
//  CenterClearLayer.swift
//  XiheMtxx
//
//  Created by echo on 2017/4/27.
//  Copyright © 2017年 羲和. All rights reserved.
//

import UIKit

class CenterClearLayer: CAShapeLayer {
    
    var clearFrame: CGRect = CGRect.zero
    
    override init() {
        super.init()
        self.speed = 3
        self.fillRule = kCAFillRuleEvenOdd
        let color = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.3).cgColor
        self.fillColor = color
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(in ctx: CGContext) {
        super.draw(in: ctx)
        
        let path = CGMutablePath()
        path.addRect(self.bounds)
        path.addRect(self.clearFrame)
        self.path = path
    }
}
