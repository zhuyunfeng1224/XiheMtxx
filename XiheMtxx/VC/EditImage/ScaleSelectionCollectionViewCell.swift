//
//  ScaleSelectionCollectionViewCell.swift
//  EasyCard
//
//  Created by echo on 2017/2/17.
//  Copyright © 2017年 羲和. All rights reserved.
//

import UIKit

class ScaleSelectionCollectionViewCell: UICollectionViewCell {
    lazy var itemButton: VerticalButton = {
        let _itemButton = VerticalButton(frame: CGRect.zero)
        _itemButton.translatesAutoresizingMaskIntoConstraints = false
        _itemButton.imageView?.contentMode = .center
        _itemButton.setTitleColor(UIColor.colorWithHexString(hex: "#578fff"), for: .highlighted)
        _itemButton.setTitleColor(UIColor.colorWithHexString(hex: "#578fff"), for: .selected)
        _itemButton.setTitleColor(UIColor.gray, for: .normal)
        _itemButton.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        return _itemButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.itemButton)
        self.setNeedsUpdateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        let itemButtonHConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[itemButton]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["itemButton": itemButton])
        self.contentView.addConstraints(itemButtonHConstraints)
        
        let itemButtonVConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[itemButton]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["itemButton": itemButton])
        self.contentView.addConstraints(itemButtonVConstraints)
    }
}
