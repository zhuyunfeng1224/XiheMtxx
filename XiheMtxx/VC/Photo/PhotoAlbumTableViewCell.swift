//
//  PhotoAlbumTableViewCell.swift
//  EasyCard
//
//  Created by echo on 2017/2/21.
//  Copyright © 2017年 羲和. All rights reserved.
//

import UIKit
import Photos

class PhotoAlbumTableViewCell: UITableViewCell {

    lazy var mImageView: UIImageView = {
        let _imageView = UIImageView()
        _imageView.contentMode = .scaleAspectFill
        _imageView.clipsToBounds = true
        _imageView.translatesAutoresizingMaskIntoConstraints = false
        return _imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let _titleLabel = UILabel()
        _titleLabel.translatesAutoresizingMaskIntoConstraints = false
        _titleLabel.textColor = UIColor.gray
        return _titleLabel
    }()
    
    lazy var detailLabel: UILabel = {
        let _detailLabel = UILabel()
        _detailLabel.translatesAutoresizingMaskIntoConstraints = false
        _detailLabel.textColor = UIColor.lightGray
        return _detailLabel
    }()
    
    lazy var arrowView: UIImageView = {
        let _arrowView = UIImageView()
        _arrowView.contentMode = .center
        _arrowView.clipsToBounds = true
        _arrowView.translatesAutoresizingMaskIntoConstraints = false
        _arrowView.image = UIImage(named: "icon_settings_arrowNext_7x13_")
        return _arrowView
    }()
    
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
        self.contentView.addSubview(self.mImageView)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.detailLabel)
        self.contentView.addSubview(self.arrowView)
        self.setNeedsUpdateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        let imageHContraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[imageView]", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["imageView": self.mImageView])
        let imageVContraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[imageView]-10-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["imageView": self.mImageView])
        let imageWidthEHeightConstraint = NSLayoutConstraint(item: self.mImageView, attribute: .width, relatedBy: .equal, toItem: self.mImageView, attribute: .height, multiplier: 1, constant: 0)
        self.contentView.addConstraints(imageHContraints)
        self.contentView.addConstraints(imageVContraints)
        self.contentView.addConstraint(imageWidthEHeightConstraint)
        
        let titleLabelHContraints = NSLayoutConstraint.constraints(withVisualFormat: "H:[imageView]-10-[titleLabel]-15-[arrowView]", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["titleLabel": self.titleLabel, "imageView": self.mImageView, "arrowView": self.arrowView])
        let titleLabelVContraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-15-[titleLabel(==20)]", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["titleLabel": self.titleLabel])
        self.contentView.addConstraints(titleLabelHContraints)
        self.contentView.addConstraints(titleLabelVContraints)
        
        let detailLabelHContraints = NSLayoutConstraint.constraints(withVisualFormat: "H:[imageView]-10-[detailLabel]-15-[arrowView]", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["detailLabel": self.detailLabel, "imageView": self.mImageView, "arrowView": self.arrowView])
        let detailLabelVContraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[titleLabel]-10-[detailLabel(==20)]", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["titleLabel": self.titleLabel, "detailLabel": self.detailLabel])
        self.contentView.addConstraints(detailLabelHContraints)
        self.contentView.addConstraints(detailLabelVContraints)
        
        let arrowViewHContraints = NSLayoutConstraint.constraints(withVisualFormat: "H:[arrowView(==20)]-10-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["arrowView": self.arrowView])
        let arrowViewVContraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[arrowView]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["arrowView": self.arrowView])
        self.contentView.addConstraints(arrowViewHContraints)
        self.contentView.addConstraints(arrowViewVContraints)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
