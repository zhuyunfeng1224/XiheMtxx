//
//  UIImage+Extension.swift
//  XiheMtxx
//
//  Created by echo on 2017/3/8.
//  Copyright © 2017年 羲和. All rights reserved.
//

import Foundation
import UIKit


extension UIImage {
    
    class func rotateCameraImageToProperOrientation(imageSource : UIImage) -> UIImage {
        
        let imgRef = imageSource.cgImage;
        
        let width = CGFloat((imgRef?.width)!)
        let height = CGFloat((imgRef?.height)!)
        
        UIGraphicsBeginImageContext(imageSource.size)
        let context = UIGraphicsGetCurrentContext()
        
        var bounds = CGRect(x: 0, y: 0, width: width, height: height)
        let imageSize = CGSize(width: width, height: height)
        
        switch(imageSource.imageOrientation) {
        case .up : break
            
        case .upMirrored :
            context?.translateBy(x: imageSize.width, y:  0.0)
            context?.scaleBy(x: -1.0, y:  1.0)
        case .down :
            context?.translateBy(x: imageSize.width, y: imageSize.height)
            context?.rotate(by: CGFloat(Double.pi))
            
        case .downMirrored :
            context?.translateBy(x: 0.0, y: imageSize.height)
            context?.scaleBy(x: 1.0, y: -1.0)
            
        case .left :
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width;
            bounds.size.width = storedHeight;
            context?.translateBy(x: 0.0, y: imageSize.width)
            context?.rotate(by: 3.0 * CGFloat(Double.pi) / 2.0)
            
        case .leftMirrored :
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width;
            bounds.size.width = storedHeight;
            context?.translateBy(x: imageSize.height, y: imageSize.width)
            context?.scaleBy(x: -1.0, y: 1.0)
            context?.rotate(by: 3.0 * CGFloat(Double.pi) / 2.0)
            
        case .right :
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width;
            bounds.size.width = storedHeight;
            context?.translateBy(x: imageSize.height, y: 0.0)
            context?.rotate(by: CGFloat(Double.pi) / 2.0)
            
        case .rightMirrored :
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width;
            bounds.size.width = storedHeight;
            context?.scaleBy(x: -1.0, y: 1.0)
            context?.rotate(by: CGFloat(Double.pi) / 2.0)
        }
        
        context?.draw(imgRef!, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        let imageCopy = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return imageCopy!
    }
    
    // 剪切图片
    func clipToRect(rect: CGRect, inRect: CGRect) -> UIImage {
        
        // 剪切图片
        let cropPixelFrame = self.convertToPixelRect(fromRect: rect, inRect: inRect)
        let cropImageSize = cropPixelFrame.size
        let imgRef = self.cgImage?.cropping(to: cropPixelFrame)
        
        // 使用UIKit方法绘制图片，防止图片倒置
        UIGraphicsBeginImageContext(cropImageSize)
        let context = UIGraphicsGetCurrentContext()
        
        // 翻转坐标系
        context?.translateBy(x: 0, y: cropImageSize.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        // 画图片，并从context中取出
        context?.draw(imgRef!, in:  CGRect(origin: CGPoint.zero, size: cropImageSize))
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return finalImage!
    }
    
    // 旋转一定角度之后剪切图片
    func clipToRect(rect: CGRect, inRect: CGRect, afterRotation rotation: CGFloat) -> UIImage {

        let originImage = self.cgImage
        let cropPixelFrame = self.convertToPixelRect(fromRect: rect, inRect: inRect)
        
        // 使用UIKit方法绘制图片，防止图片倒置
        UIGraphicsBeginImageContext(inRect.size)
        let context = UIGraphicsGetCurrentContext()
        // 翻转坐标系
        context?.translateBy(x: inRect.size.width/2, y: inRect.size.height/2)
        context?.rotate(by: rotation)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        // 画图片，并从context中取出
        context?.draw(originImage!, in:  CGRect(origin: CGPoint(x: -inRect.size.width / 2, y:-inRect.size.height / 2), size: inRect.size))
        let rotationImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // 剪切图片
//        let cropPixelFrame = self.convertToPixelRect(fromRect: rect, inRect: inRect)
//        let cropImageSize = cropPixelFrame.size
//        let imgRef = rotationImage?.cgImage?.cropping(to: cropPixelFrame)
////
////        // 画图片，并从context中取出
//        context?.draw(imgRef!, in:  CGRect(origin: CGPoint.zero, size: cropPixelFrame.size))
////
//        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
//        
        UIGraphicsEndImageContext()
        
        return rotationImage!
    }
    
    func convertToPixelRect(fromRect rect: CGRect, inRect: CGRect) -> CGRect {
        let w = round(rect.size.width/inRect.size.width * self.size.width)
        let h = round(rect.size.height/inRect.size.height * self.size.height)
        let x = (rect.origin.x - inRect.origin.x) / inRect.size.width * self.size.width
        let y = (rect.origin.y - inRect.origin.y) / inRect.size.width * self.size.width
        let pixelRect = CGRect(x: x, y: y, width: w, height: h)
        return pixelRect
    }
}
