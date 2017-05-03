//
//  ScaleSelectionView.swift
//  EasyCard
//
//  Created by echo on 2017/2/16.
//  Copyright © 2017年 羲和. All rights reserved.
//

import UIKit

enum RatioType: Int {
    case ratio_free
    case ratio_1_1
    case ratio_2_3
    case ratio_3_2
    case ratio_3_4
    case ratio_4_3
    case ratio_9_16
    case ratio_16_9
    
    func info() -> (aspectRatio: CGSize, title: String, normalImage: String, highlightImage: String) {
        if self == .ratio_1_1 {
            
            return (CGSize(width: 1, height: 1),
                    "1:1",
                    "icon_meihua_scale_1-1_normal_30x30_",
                    "icon_meihua_scale_1-1_highlighted_30x30_")
        }
        else if self == .ratio_2_3 {
            return (CGSize(width: 2, height: 3),
                    "2:3",
                    "icon_meihua_scale_2-3_normal_30x30_",
                    "icon_meihua_scale_2-3_highlighted_30x30_")
        }
        else if self == .ratio_3_2 {
            return (CGSize(width: 3, height: 2),
                    "3:2",
                    "icon_meihua_scale_3-2_normal_30x30_",
                    "icon_meihua_scale_3-2_highlighted_30x30_")
        }
        else if self == .ratio_3_4 {
            return (CGSize(width: 3, height: 4),
                    "3:4",
                    "icon_meihua_scale_3-4_normal_30x30_",
                    "icon_meihua_scale_3-4_highlighted_30x30_")
        }
        else if self == .ratio_4_3 {
            return (CGSize(width: 4, height: 3),
                    "4:3",
                    "icon_meihua_scale_4-3_normal_30x30_",
                    "icon_meihua_scale_4-3_highlighted_30x30_")
        }
        else if self == .ratio_9_16 {
            return (CGSize(width: 9, height: 16),
                    "9:16",
                    "icon_meihua_scale_9-16_normal_30x30_",
                    "icon_meihua_scale_9-16_highlighted_30x30_")
        }
        else if self == .ratio_16_9 {
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
    func ratioDownInSize(originSize: CGSize) -> CGSize {
        let scaleSize = self.info().aspectRatio
        let ratio = scaleSize.width / scaleSize.height
        if (originSize.width / originSize.height) > ratio {
            return CGSize(width: originSize.height * ratio, height: originSize.height)

        }
        return CGSize(width: originSize.width, height: originSize.width / ratio)
    }
}

protocol RatioSelectionViewDelegate: NSObjectProtocol {
    func ratioSelected(ratioType: RatioType) -> Void
}

class RatioSelectionView: UIView {
    
    var selectIndex: Int = 0 {
        didSet {
            self.delegate?.ratioSelected(ratioType: RatioType(rawValue: selectIndex)!)
            self.collectionView.reloadData()
        }
    }
    weak var delegate: RatioSelectionViewDelegate?
    
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
                self.selectIndex = 0
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

extension RatioSelectionView: UICollectionViewDataSource, UICollectionViewDelegate {
    @available(iOS 6.0, *)
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ScaleSelectionCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ScaleSelectionCollectionViewCell.self), for: indexPath) as! ScaleSelectionCollectionViewCell
        
        let ratioType = RatioType(rawValue: indexPath.row)
        let info = ratioType?.info()
        
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
        self.selectIndex = indexPath.row
    }
    
    func itemSelect(sender: UIButton) -> Void {
        self.selectIndex = sender.tag
    }
    
//    func itemSelect(atIndex index: Int) -> Void {
//        self.delegate?.ratioSelected(ratioType: RatioType(rawValue: index)!)
//        collectionView.reloadData()
//    }
}
