//
//  MathTool.swift
//  Cliptest
//
//  Created by edz on 2021/6/17.
//

import Foundation
import UIKit


extension CGSize {
    /// 根据imageview 的大小 和image的大小 计算出 aspectfit 下 图片实际大小
    /// - Parameters:
    ///   - aspectRatio: aspectRatio description
    ///   - boundingSize: boundingSize description
    /// - Returns: description
    static func aspectFit(image size: CGSize, boundingSize: CGSize) -> (size: CGSize, xOffset: CGFloat, yOffset: CGFloat)  {
        let mW = boundingSize.width / size.width;
        let mH = boundingSize.height / size.height;
        var fittedWidth = boundingSize.width
        var fittedHeight = boundingSize.height
        var xOffset = CGFloat(0.0)
        var yOffset = CGFloat(0.0)

        if( mH < mW ) {
            fittedWidth = boundingSize.height / size.height * size.width;
            xOffset = abs(boundingSize.width - fittedWidth)/2
        }
        else if( mW < mH ) {
            fittedHeight = boundingSize.width / size.width * size.height;
            yOffset = abs(boundingSize.height - fittedHeight)/2
        }
        let size = CGSize(width: fittedWidth, height: fittedHeight)
        return (size, xOffset, yOffset)
    }
}

extension CGPoint {
    func cartesian(for size: CGSize) -> CGPoint {
        let realPoint = self.applying(CGAffineTransform(scaleX: size.width, y: size.height))
        return CGPoint(x: realPoint.x, y: size.height - realPoint.y)
      }
    
    func distance(to: CGPoint) -> CGFloat {
        return (sqrt(CGPointDistanceSquared(from: self, to: to)))
    }
    
    func CGPointDistanceSquared(from: CGPoint, to: CGPoint) -> CGFloat {
        return (from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)
    }
    
    
    /// 计算三个point 之间的夹角
    /// - Parameters:
    ///   - point1: point1 description
    ///   - point2: point2 description
    /// - Returns: description
    func angleBetween(point1: CGPoint, point2: CGPoint) -> CGFloat {
        let a = self.distance(to: point1)
        let b = point1.distance(to: point2)
        let c = self.distance(to: point2)
        let angle = acos(((a*a)+(c*c)-(b*b))/((2*(a)*(c))))
        print("angl---\(angle)")
        return angle
    }
}
