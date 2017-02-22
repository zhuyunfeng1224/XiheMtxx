//
//  ToolBarItem.swift
//  EasyCard
//
//  Created by echo on 2017/2/14.
//  Copyright © 2017年 羲和. All rights reserved.
//

import UIKit

class ToolBarItem: UIControl {
    
    var item: ToolBarItemObject!
    
    lazy var imageView: UIImageView = {
        let _imageView = UIImageView()
        _imageView.translatesAutoresizingMaskIntoConstraints = false
        _imageView.contentMode = .scaleAspectFit
        return _imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let _titleLabel = UILabel()
        _titleLabel.textColor = UIColor.gray
        _titleLabel.translatesAutoresizingMaskIntoConstraints = false
        _titleLabel.font = UIFont.systemFont(ofSize: 10)
        _titleLabel.textAlignment = .center
        return _titleLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        let imageViewHConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-13-[imageView]-13-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["imageView": self.imageView])
        self.addConstraints(imageViewHConstraints)
        
        let imageViewVConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-1-[imageView(==width)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: ["width": ((superview?.frame.size.height)! - 26.0)], views: ["imageView": self.imageView, "superView": self])
        self.addConstraints(imageViewVConstraints)
        
        let titleLabelHConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-7.5-[titleLabel]-7.5-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["titleLabel": self.titleLabel])
        self.addConstraints(titleLabelHConstraints)
        
        let titleLabelVConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[titleLabel(==12)]-5-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["titleLabel": self.titleLabel])
        self.addConstraints(titleLabelVConstraints)
    }
    
    convenience init(frame: CGRect, itemObject: ToolBarItemObject) {
        self.init(frame: frame)
        self.item = itemObject
        self.imageView.image = UIImage(named: (itemObject.imageName)!)
        self.addSubview(self.imageView)
        self.titleLabel.text = itemObject.titleName
        self.addSubview(self.titleLabel)
        self.setNeedsUpdateConstraints()
        
        self.addTarget(self, action: #selector(touch(sender:)), for: .touchUpInside)
    }
    
    func touch(sender:ToolBarItem) -> Void {
        if let action = self.item.action {
            action()
        }
    }
}

class ToolBarItemObject: NSObject {
    var imageName: String?
    var titleName: String?
    var action: (() -> ())?
}
