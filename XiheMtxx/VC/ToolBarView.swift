//
//  ToolBarView.swift
//  EasyCard
//
//  Created by echo on 2017/2/14.
//  Copyright © 2017年 羲和. All rights reserved.
//

import UIKit

let height: CGFloat = 50

class ToolBarView: UIView {
    
    lazy var toolBarScrollView: UIScrollView = {
        let _toolBarScrollView = UIScrollView(frame: CGRect.zero)
        _toolBarScrollView.alwaysBounceHorizontal = true
        _toolBarScrollView.backgroundColor = UIColor.colorWithHexString(hex: "ffffff")
        return _toolBarScrollView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    // 根据ToolBarItemObject对象创建item
    convenience init(items: [ToolBarItemObject]) {
        
        let rect = CGRect(x: 0,
                          y: (UIScreen.main.bounds.size.height - height),
                          width: UIScreen.main.bounds.size.width,
                          height: height)
        self.init(frame: rect)
        self.toolBarScrollView.frame = CGRect(x: 0, y: 0, width: rect.size.width, height: rect.size.height)
        self.addSubview(self.toolBarScrollView)
        for i in 0...(items.count - 1) {
            let itemObject = items[i]
            let w: CGFloat = 55
            let x: CGFloat = CGFloat(i) * w
            let h: CGFloat = height
            let frame = CGRect(x: x, y: 0, width: w, height: h)
            let item = ToolBarItem(frame: frame, itemObject: itemObject)
            self.toolBarScrollView.addSubview(item)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
