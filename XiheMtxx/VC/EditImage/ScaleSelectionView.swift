//
//  ScaleSelectionView.swift
//  EasyCard
//
//  Created by echo on 2017/2/16.
//  Copyright © 2017年 羲和. All rights reserved.
//

import UIKit

class ScaleSelectionView: UIView {
    
    var dataSource = [["title": "自由", "image": "icon_meihua_scale_free_normal_30x30_", "highlightImage": "icon_meihua_scale_free_highlighted_30x30_"],
                      ["title": "1:1", "image": "icon_meihua_scale_1-1_normal_30x30_", "highlightImage": "icon_meihua_scale_1-1_highlighted_30x30_"],
                      ["title": "2:3", "image": "icon_meihua_scale_2-3_normal_30x30_", "highlightImage": "icon_meihua_scale_2-3_highlighted_30x30_"],
                      ["title": "3:2", "image": "icon_meihua_scale_3-2_normal_30x30_", "highlightImage": "icon_meihua_scale_3-2_highlighted_30x30_"],
                      ["title": "3:4", "image": "icon_meihua_scale_3-4_normal_30x30_", "highlightImage": "icon_meihua_scale_3-4_highlighted_30x30_"],
                      ["title": "4:3", "image": "icon_meihua_scale_4-3_normal_30x30_", "highlightImage": "icon_meihua_scale_4-3_highlighted_30x30_"],
                      ["title": "9:16", "image": "icon_meihua_scale_9-16_normal_30x30_", "highlightImage": "icon_meihua_scale_9-16_highlighted_30x30_"],
                      ["title": "16:9", "image": "icon_meihua_scale_16-9_normal_30x30_", "highlightImage": "icon_meihua_scale_16-9_highlighted_30x30_"]]
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let _collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        _collectionView.register(ScaleSelectionCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: ScaleSelectionCollectionViewCell.self))
        _collectionView.delegate = self
        _collectionView.dataSource = self
        _collectionView.backgroundColor = UIColor.clear
        _collectionView.showsHorizontalScrollIndicator = false
        _collectionView.showsVerticalScrollIndicator = false
        _collectionView.translatesAutoresizingMaskIntoConstraints = false
        return _collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.collectionView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        let hConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[collectionView]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["collectionView": self.collectionView])
        let vConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[collectionView]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["collectionView": self.collectionView])
        self.addConstraints(hConstraints)
        self.addConstraints(vConstraints)
    }
}

extension ScaleSelectionView: UICollectionViewDataSource, UICollectionViewDelegate {
    @available(iOS 6.0, *)
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ScaleSelectionCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ScaleSelectionCollectionViewCell.self), for: indexPath) as! ScaleSelectionCollectionViewCell
        let data: [String : String] = self.dataSource[indexPath.row]
        let imageString = data["image"]!
        let highlightImageString = data["highlightImage"]!
        let titleString = data["title"]!
        
        cell.itemButton.setImage(UIImage(named:imageString), for: .normal)
        cell.itemButton.setImage(UIImage(named:highlightImageString), for: .highlighted)
        cell.itemButton.setTitle(titleString, for: .normal)
        cell.itemButton.setTitle(titleString, for: .highlighted)
        
        return cell
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
}
