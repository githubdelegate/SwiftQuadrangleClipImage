//
//  ZYClipImageTool.swift
//  Cliptest
//
//  Created by edz on 2021/6/17.
//

import Foundation
import UIKit

public extension UIImage {
    /// 四个点  是  左上角维坐标系 的坐标点  顺时针方向, 四个左边点 使用比例值
    func clipImageWithPoint(topLeft: CGPoint, topRight: CGPoint, bottomRight: CGPoint, bottomLeft: CGPoint) -> UIImage? {
        let ciImage = CIImage(image: self)
        
        let perspectiveCorrection = CIFilter(name: "CIPerspectiveCorrection")
        let imgSize = CGSize(width: self.size.width * self.scale,
                             height: self.size.height * self.scale)
        let context = CIContext(options: nil)
        guard let transform = perspectiveCorrection else { return nil }
        transform.setValue(CIVector(cgPoint: topLeft.cartesian(for: imgSize)),
                           forKey: "inputTopLeft")
        transform.setValue(CIVector(cgPoint: topRight.cartesian(for: imgSize)),
                           forKey: "inputTopRight")
        transform.setValue(CIVector(cgPoint: bottomRight.cartesian(for: imgSize)),
                           forKey: "inputBottomRight")
        transform.setValue(CIVector(cgPoint: bottomLeft.cartesian(for: imgSize)),
                           forKey: "inputBottomLeft")
        transform.setValue(ciImage, forKey: kCIInputImageKey)
        
        guard let perspectiveCorrectedImg = transform.outputImage, let cgImage = context.createCGImage(perspectiveCorrectedImg, from: perspectiveCorrectedImg.extent) else { return nil}
        
        return UIImage(cgImage: cgImage)
    }
}


