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
        self.speed = 2
        self.fillRule = kCAFillRuleEvenOdd
        let color = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.3).cgColor
        self.fillColor = color
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
        
//        let animation = CABasicAnimation(keyPath: "transform.scale")
//        animation.duration = 0.3
//        animation.fromValue = self.bounds.size.width / self.clearFrame.size.width
//        animation.toValue = 1
        
//        self.add(animation, forKey: nil)
    }
}
