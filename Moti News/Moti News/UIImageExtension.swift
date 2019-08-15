//
//  UIImageExtension.swift
//  Moti News
//
//  Created by Modestas Valauskas on 10.07.16.
//  Copyright © 2016 Modestas Valauskas. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    func imageByCroppingImage(size: CGSize) -> UIImage {
        let refWidth : CGFloat = CGFloat(CGImageGetWidth(self.CGImage))
        let refHeight : CGFloat = CGFloat(CGImageGetHeight(self.CGImage))
        
        let x = (refWidth - size.width) / 2
        let y = (refHeight - size.height) / 2
        
        let cropRect = CGRectMake(x, y, size.height, size.width)
        let imageRef = CGImageCreateWithImageInRect(self.CGImage, cropRect)
        
        let cropped : UIImage = UIImage(CGImage: imageRef!, scale: 0, orientation: self.imageOrientation)
        
        
        return cropped
    }
}