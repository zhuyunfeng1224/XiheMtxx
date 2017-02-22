//
//  PhotoAssetCollectionViewCell.swift
//  EasyCard
//
//  Created by echo on 2017/2/22.
//  Copyright © 2017年 羲和. All rights reserved.
//

import UIKit
import Photos

class PhotoAssetCollectionViewCell: UICollectionViewCell {
    
    var asset: PHAsset? {
        willSet(newValue) {
            let option = PHImageRequestOptions()
            option.resizeMode = .fast
            option.isNetworkAccessAllowed = true
            PHCachingImageManager.default().requestImage(for: newValue!, targetSize: CGSize(width: 180, height: 180), contentMode: .aspectFill, options: option, resultHandler: { (image, info) in
                self.mImageView.image = image
            })
        }
    }
    
    lazy var mImageView: UIImageView = {
        let _mImageView = UIImageView()
        _mImageView.contentMode = .scaleAspectFill
        _mImageView.clipsToBounds = true
        _mImageView.translatesAutoresizingMaskIntoConstraints = false
        return _mImageView
    }()
    
    lazy var reviewButton: UIButton = {
        let _reviewButton = UIButton()
        _reviewButton.setImage(UIImage(named:"icon_review_36x36_"), for: .normal)
        _reviewButton.translatesAutoresizingMaskIntoConstraints = false
        return _reviewButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.mImageView)
        self.contentView.addSubview(self.reviewButton)
        self.contentView.setNeedsUpdateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        let imageHConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[imageView]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["imageView": self.mImageView])
        let imageVConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[imageView]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["imageView": self.mImageView])
        self.contentView.addConstraints(imageHConstraints)
        self.contentView.addConstraints(imageVConstraints)
        
        let reviewButtonHConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:[reviewButton(==30)]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["reviewButton": self.reviewButton])
        let reviewButtonVConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[reviewButton(==30)]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["reviewButton": self.reviewButton])
        self.contentView.addConstraints(reviewButtonHConstraints)
        self.contentView.addConstraints(reviewButtonVConstraints)
    }
}
