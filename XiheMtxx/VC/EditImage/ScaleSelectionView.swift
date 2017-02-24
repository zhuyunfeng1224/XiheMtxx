//
//  ScaleSelectionView.swift
//  EasyCard
//
//  Created by echo on 2017/2/16.
//  Copyright © 2017年 羲和. All rights reserved.
//

import UIKit

enum ScaleType: Int {
    case scale_free
    case scale_1_1
    case scale_2_3
    case scale_3_2
    case scale_3_4
    case scale_4_3
    case scale_9_16
    case scale_16_9
    
    func info() -> (scale: CGSize, title: String, normalImage: String, highlightImage: String) {
        if self == .scale_1_1 {
            
            return (CGSize(width: 1, height: 1),
                    "1:1",
                    "icon_meihua_scale_1-1_normal_30x30_",
                    "icon_meihua_scale_1-1_highlighted_30x30_")
        }
        else if self == .scale_2_3 {
            return (CGSize(width: 2, height: 3),
                    "2:3",
                    "icon_meihua_scale_2-3_normal_30x30_",
                    "icon_meihua_scale_2-3_highlighted_30x30_")
        }
        else if self == .scale_3_2 {
            return (CGSize(width: 3, height: 2),
                    "3:2",
                    "icon_meihua_scale_3-2_normal_30x30_",
                    "icon_meihua_scale_3-2_highlighted_30x30_")
        }
        else if self == .scale_3_4 {
            return (CGSize(width: 3, height: 4),
                    "3:4",
                    "icon_meihua_scale_3-4_normal_30x30_",
                    "icon_meihua_scale_3-4_highlighted_30x30_")
        }
        else if self == .scale_4_3 {
            return (CGSize(width: 4, height: 3),
                    "4:3",
                    "icon_meihua_scale_4-3_normal_30x30_",
                    "icon_meihua_scale_4-3_highlighted_30x30_")
        }
        else if self == .scale_9_16 {
            return (CGSize(width: 9, height: 16),
                    "9:16",
                    "icon_meihua_scale_9-16_normal_30x30_",
                    "icon_meihua_scale_9-16_highlighted_30x30_")
        }
        else if self == .scale_16_9 {
            return (CGSize(width: 16, height: 9),
                    "16:9",
                    "icon_meihua_scale_16-9_normal_30x30_",
                    "icon_meihua_scale_16-9_highlighted_30x30_")
        }
        else {
            return (CGSize(width: 1, height: 1),
                    "自由",
                    "icon_meihua_scale_free_normal_30x30_",
                    "icon_meihua_scale_free_highlighted_30x30_")
        }
    }
    
    // 按比例缩小
    func scaleDownInSize(originSize: CGSize) -> CGSize {
        let scaleSize = self.info().scale
        let scale = scaleSize.width / scaleSize.height
        if (originSize.width / originSize.height) > scale {
            return CGSize(width: originSize.height * scale, height: originSize.height)

        }
        return CGSize(width: originSize.width, height: originSize.width / scale)
    }
}

protocol ScaleSelectionViewDelegate: NSObjectProtocol {
    func scaleSelected(scaleType: ScaleType) -> Void
}

class ScaleSelectionView: UIView {
    
    var selectIndex: Int = 0
    weak var delegate: ScaleSelectionViewDelegate?
    
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
        self.collectionView.performBatchUpdates({
            
        }) { (finished) in
            if finished {
                self.itemSelect(atIndex: 0)
            }
        }
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
        
        let scaleType = ScaleType(rawValue: indexPath.row)
        let info = scaleType?.info()
        
        cell.itemButton.setImage(UIImage(named:info!.normalImage), for: .normal)
        cell.itemButton.setImage(UIImage(named:info!.highlightImage), for: .highlighted)
        cell.itemButton.setImage(UIImage(named:info!.highlightImage), for: .selected)
        cell.itemButton.setTitle(info!.title, for: .normal)
        cell.itemButton.setTitle(info!.title, for: .highlighted)
        cell.itemButton.isSelected = self.selectIndex == indexPath.row
        cell.itemButton.tag = indexPath.row
        cell.itemButton.addTarget(self, action: #selector(itemSelect(sender:)), for: .touchUpInside)
        
        return cell
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.itemSelect(atIndex: indexPath.row)
    }
    
    func itemSelect(sender: UIButton) -> Void {
        self.itemSelect(atIndex: sender.tag)
    }
    
    func itemSelect(atIndex index: Int) -> Void {
        self.selectIndex = index
        collectionView.reloadData()
        self.delegate?.scaleSelected(scaleType: ScaleType(rawValue: self.selectIndex)!)
    }
}
