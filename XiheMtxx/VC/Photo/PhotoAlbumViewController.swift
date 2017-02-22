//
//  PhotoAlbumViewController.swift
//  EasyCard
//
//  Created by echo on 2017/2/21.
//  Copyright © 2017年 羲和. All rights reserved.
//

import UIKit
import Photos

// 相册对象
class AlbumObject: NSObject {
    var assets: [PHAsset] = []
    var albumName: String = ""
}

class PhotoAlbumViewController: PhotoBaseViewController {
    
    lazy var tableView: UITableView = {
        let _tableView = UITableView(frame: CGRect.zero)
        _tableView.backgroundColor = UIColor.colorWithHexString(hex: "#f9f9f9")
        _tableView.register(PhotoAlbumTableViewCell.self, forCellReuseIdentifier: String(describing: PhotoAlbumTableViewCell.self))
        _tableView.translatesAutoresizingMaskIntoConstraints = false
        _tableView.rowHeight = 90
        _tableView.delegate = self
        _tableView.dataSource = self
        _tableView.tableFooterView = UIView()
        _tableView.separatorColor = UIColor.colorWithHexString(hex: "#e6e6e6")
        return _tableView
    }()
    
    var albums: [AlbumObject] = []
    
    lazy var userAlbums: AlbumObject = {
        let _userAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
        let assets = PhotoAlbumViewController.fetchAssetsFromCollection(collectionResult: _userAlbums)
        
        var album = AlbumObject()
        album.assets = assets
        album.albumName = "相机胶卷"
        return album
    }()
    
    lazy var recentAlbums: AlbumObject = {
        let _recentAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumRecentlyAdded, options: nil)
        let assets = PhotoAlbumViewController.fetchAssetsFromCollection(collectionResult: _recentAlbums)
        
        var album = AlbumObject()
        album.assets = assets
        album.albumName = "最近添加"
        return album
    }()
    
    lazy var favourAlbums: AlbumObject = {
        let _favourAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumFavorites, options: nil)
        let assets = PhotoAlbumViewController.fetchAssetsFromCollection(collectionResult: _favourAlbums)
        
        var album = AlbumObject()
        album.assets = assets
        album.albumName = "个人收藏"
        return album
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "选择照片"
        self.view.addSubview(self.tableView)
        self.view.setNeedsUpdateConstraints()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"btn_back_arrow_25x25_"), style: .done, target: self, action: #selector(backButtonClicked(sender:)))
        self.navigationItem.leftItemsSupplementBackButton = true
        
        if self.userAlbums.assets.count > 0 {
            self.albums.append(self.userAlbums)
        }
        if self.recentAlbums.assets.count > 0 {
            self.albums.append(self.recentAlbums)
        }
        if self.favourAlbums.assets.count > 0 {
            self.albums.append(self.favourAlbums)
        }
        let indexFirst = IndexPath(row: 0, section: 0)
        self.tableView(self.tableView, didSelectRowAt: indexFirst)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        let tableHContraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[tableView]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["tableView": self.tableView])
        let tableVContraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[tableView]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["tableView": self.tableView])
        self.view.addConstraints(tableHContraints)
        self.view.addConstraints(tableVContraints)
    }
    
    // MARK: Private Method
    
    // 获取相册中图片
    open static func fetchAssetsFromCollection(collectionResult: PHFetchResult<PHAssetCollection>!) -> [PHAsset] {
        var assets: [PHAsset] = []
        let option = PHFetchOptions()
        option.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        var result: PHFetchResult<PHAsset>?
        if collectionResult.count != 0 {
            result = PHAsset.fetchAssets(in: collectionResult.firstObject!, options: option)
        }
        if let result = result {
            result.enumerateObjects({ (obj, index, stop) in
                if obj.mediaType == .image {
                    assets.append(obj)
                }
            })
            
        }
        return assets
    }
    
    func backButtonClicked(sender: Any) -> Void {
        self.dismiss(animated: true) {
            
        }
    }
}

extension PhotoAlbumViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PhotoAlbumTableViewCell = tableView.dequeueReusableCell(withIdentifier: String(describing: PhotoAlbumTableViewCell.self)) as! PhotoAlbumTableViewCell
        
        if indexPath.row < self.albums.count {
            let album = self.albums[indexPath.row]
            cell.titleLabel.text = album.albumName
            let assets = album.assets
            cell.detailLabel.text = "\(assets.count)张"
            if let lastAsset: PHAsset = assets.last {
                cell.asset = lastAsset
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let assetVC = PhotoAssetViewController()
        if indexPath.row < self.albums.count {
            let album = self.albums[indexPath.row]
            assetVC.assets = album.assets
            assetVC.title = album.albumName
        }
        self.navigationController?.pushViewController(assetVC, animated: true)
    }
}
