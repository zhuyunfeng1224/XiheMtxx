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
    
    func convertToPixelRect(fromRect rect: CGRect, inRect: CGRect) -> CGRect {
        let w = round(rect.size.width/inRect.size.width * self.size.width)
        let h = round(rect.size.height/inRect.size.height * self.size.height)
        let x = (rect.origin.x - inRect.origin.x) / inRect.size.width * self.size.width
        let y = (rect.origin.y - inRect.origin.y) / inRect.size.width * self.size.width
        let pixelRect = CGRect(x: x, y: y, width: w, height: h)
        return pixelRect
    }
}
