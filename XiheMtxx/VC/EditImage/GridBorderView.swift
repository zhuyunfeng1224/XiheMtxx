//
//  GridBorderView.swift
//  XiheMtxx
//
//  Created by echo on 2017/2/23.
//  Copyright © 2017年 羲和. All rights reserved.
//

import UIKit

class GridBorderView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(UIColor.white.cgColor)
        let lineWidth: CGFloat = 1
        context?.setLineWidth(lineWidth)
        context?.beginPath()
        let shadowOffset = CGSize(width: 1, height: 1)
        context?.setShadow(offset: shadowOffset, blur: 2, color: UIColor.black.withAlphaComponent(0.3).cgColor)
        
        // 横线
        context?.move(to: CGPoint(x: rect.origin.x, y: rect.origin.y + lineWidth/2))
        context?.addLine(to: CGPoint(x: rect.size.width, y: rect.origin.y + lineWidth/2))
        
        context?.move(to: CGPoint(x: rect.origin.x, y: rect.size.height * 1 / 3))
        context?.addLine(to: CGPoint(x: rect.size.width, y: rect.size.height * 1 / 3))
        
        context?.move(to: CGPoint(x: rect.origin.x, y: rect.size.height * 2 / 3))
        context?.addLine(to: CGPoint(x: rect.size.width, y: rect.size.height * 2 / 3))
        
        context?.move(to: CGPoint(x: rect.origin.x, y: rect.size.height - lineWidth/2))
        context?.addLine(to: CGPoint(x: rect.size.width, y: rect.size.height - lineWidth/2))
        
        // 竖线
        context?.move(to: CGPoint(x: rect.origin.x + lineWidth/2, y: rect.origin.y))
        context?.addLine(to: CGPoint(x: rect.origin.x + lineWidth/2, y: rect.size.height))
        
        context?.move(to: CGPoint(x: rect.size.width * 1 / 3, y: rect.origin.y))
        context?.addLine(to: CGPoint(x: rect.size.width * 1 / 3, y: rect.size.height))
        
        context?.move(to: CGPoint(x: rect.size.width * 2 / 3, y: rect.origin.y))
        context?.addLine(to: CGPoint(x: rect.size.width * 2 / 3, y: rect.size.height))
        
        context?.move(to: CGPoint(x: rect.size.width - lineWidth/2, y: rect.origin.y))
        context?.addLine(to: CGPoint(x: rect.size.width - lineWidth/2, y: rect.size.height))
        
        context?.strokePath()
    }
}
