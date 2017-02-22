//
//  VerticalButton.swift
//  EasyCard
//
//  Created by echo on 2017/2/16.
//  Copyright © 2017年 羲和. All rights reserved.
//

import UIKit

public class VerticalButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.titleLabel?.textAlignment = .center
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        
        var rect = super.titleRect(forContentRect: contentRect)
        var origin = rect.origin
        var size = rect.size
        
        origin.x = self.titleEdgeInsets.left
        if let _ = self.currentImage {
            origin.y = contentRect.size.height - self.titleEdgeInsets.bottom - size.height
        }
        
        size.width = contentRect.size.width - self.titleEdgeInsets.left - self.titleEdgeInsets.right
        
        rect.origin = origin
        rect.size = size
        
        return rect
    }
    
    public override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        
        let x = contentRect.origin.x + self.imageEdgeInsets.left
        let y = contentRect.origin.y + self.imageEdgeInsets.top
        let w = contentRect.size.width - self.imageEdgeInsets.left - self.imageEdgeInsets.right
        var h = contentRect.size.height - self.imageEdgeInsets.top - self.imageEdgeInsets.bottom
        
        if let _ = self.currentTitle {
            let titleRect = self.titleRect(forContentRect: contentRect)
            h = contentRect.size.height - self.imageEdgeInsets.top - self.imageEdgeInsets.bottom - titleRect.size.height - self.titleEdgeInsets.top - self.titleEdgeInsets.bottom
        }
        
        let rect = CGRect(x: x, y: y, width: w, height: h)
        return rect
    }
    
    private func titleHeight() -> CGFloat {
        let titleHeight = self.titleLabel?.font.pointSize
        return titleHeight!
    }
}
