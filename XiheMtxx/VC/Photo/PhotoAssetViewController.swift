//
//  PhotoAssetViewController.swift
//  EasyCard
//
//  Created by echo on 2017/2/22.
//  Copyright © 2017年 羲和. All rights reserved.
//

import UIKit
import Photos

class PhotoAssetViewController: PhotoBaseViewController {
    
    var assets: [PHAsset] = [] {
        didSet {
            self.collectionView.reloadData()
            // 开始加载滚动到最后
            self.collectionView.performBatchUpdates({
                
            }) { (finish) in
                if finish {
                    let indexPath = IndexPath(item: self.assets.count - 1, section: 0)
                    self.collectionView.scrollToItem(at:indexPath , at: .bottom, animated: false)
                }
            }
        }
    }
    
    lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 3
        layout.minimumLineSpacing = 3
        let width: CGFloat = (UIScreen.main.bounds.size.width - 6)/3
        layout.itemSize = CGSize(width: width, height: width)
        
        let _collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        _collectionView.backgroundColor = UIColor.white
        _collectionView.translatesAutoresizingMaskIntoConstraints = false
        _collectionView.alwaysBounceVertical = true
        _collectionView.register(PhotoAssetCollectionViewCell.self, forCellWithReuseIdentifier: String(PhotoAssetCollectionViewCell.self.description()))
        _collectionView.delegate = self
        _collectionView.dataSource = self
        
        return _collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.collectionView)
        self.view.setNeedsUpdateConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        let hConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[collectionView]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["collectionView": self.collectionView])
        let vConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[collectionView]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["collectionView": self.collectionView])
        self.view.addConstraints(hConstraints)
        self.view.addConstraints(vConstraints)
    }
}

extension PhotoAssetViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.assets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(PhotoAssetCollectionViewCell.self.description()), for: indexPath) as! PhotoAssetCollectionViewCell
        if indexPath.row < self.assets.count {
            let asset = self.assets[indexPath.row]
            cell.asset = asset
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < self.assets.count {
            let asset = self.assets[indexPath.row]
            
            let option = PHImageRequestOptions()
            option.resizeMode = .exact
            option.isNetworkAccessAllowed = true
            PHCachingImageManager.default().requestImageData(for: asset, options: option, resultHandler: { (data, str, orientation, info) in
                let mainVC = BeautyCenterViewController()
                let image = UIImage(data: data!)
                mainVC.originImage = self.removeOrientation(image: image!)
                self.navigationController?.pushViewController(mainVC, animated: true)
            })
        }
    }
    
    // 移除掉原始图片的Orientation
    func removeOrientation(image: UIImage) -> UIImage {
        
        if image.imageOrientation == .up {
            return image
        }
        
        return UIImage.rotateCameraImageToProperOrientation(imageSource: image)
    }
}
