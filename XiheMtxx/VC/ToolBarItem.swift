//
//  ToolBarItem.swift
//  EasyCard
//
//  Created by echo on 2017/2/14.
//  Copyright © 2017年 羲和. All rights reserved.
//

import UIKit

class ToolBarItem: UIView {
    
    var item: ToolBarItemObject!
    
    lazy var itemButton: VerticalButton = {
        let _itemButton = VerticalButton()
        _itemButton.translatesAutoresizingMaskIntoConstraints = false
        _itemButton.setTitleColor(UIColor.darkGray, for: .normal)
        _itemButton.setTitleColor(UIColor.colorWithHexString(hex: "#578fff"), for: .highlighted)
        _itemButton.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        _itemButton.imageView?.contentMode = .center
        _itemButton.addTarget(self, action: #selector(touch(sender:)), for: .touchUpInside)
        _itemButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
        return _itemButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        let itemButtonHConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[itemButton]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["itemButton": self.itemButton])
        self.addConstraints(itemButtonHConstraints)
        
        let itemButtonVConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-1-[itemButton]-1-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["itemButton": self.itemButton])
        self.addConstraints(itemButtonVConstraints)
    }
    
    convenience init(frame: CGRect, itemObject: ToolBarItemObject) {
        self.init(frame: frame)
        self.addSubview(self.itemButton)
        self.setNeedsUpdateConstraints()
        self.item = itemObject
        self.itemButton.setImage(UIImage(named: self.item.imageName!), for: .normal)
        self.itemButton.setImage(UIImage(named: self.item.highlightImageName!), for: .highlighted)
        self.itemButton.setTitle(self.item.titleName, for: .normal)
    }
    
    func touch(sender:ToolBarItem) -> Void {
        if let action = self.item.action {
            action()
        }
    }
}

class ToolBarItemObject: NSObject {
    var imageName: String?
    var highlightImageName: String?
    var titleName: String?
    var action: (() -> ())?
}
