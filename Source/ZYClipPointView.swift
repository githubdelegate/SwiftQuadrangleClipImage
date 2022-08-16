//
//  ZYClipPointView.swift
//  Cliptest
//
//  Created by zy on 2021/6/25.
//

import Foundation
import UIKit


/// 四个角的圆点
class ZYClipPointView: UIView {
    
    /// 外边圆
    var circleColor: UIColor = .white
    var circleWidth: CGFloat = 30
    
    /// 内边圆
    var innerCircleColor: UIColor = .red
    var innerCircleWidth: CGFloat = 20
    
    var innerCicleView: UIView = UIView()
    var circleView: UIView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(circleView)
        self.addSubview(innerCicleView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateUI() {
        
        circleView.backgroundColor = self.circleColor
        innerCicleView.backgroundColor = self.innerCircleColor
//        innerCicleView.backgroundColor = .red
        
        circleView.frame.size = CGSize(width: self.circleWidth, height: self.circleWidth)
        circleView.center = CGPoint(x: 0.5, y: 0.5).applying(CGAffineTransform(scaleX: self.bounds.width, y: self.bounds.height))
        circleView.layer.cornerRadius = self.circleWidth / 2

        innerCicleView.frame.size = CGSize(width: self.innerCircleWidth, height: self.innerCircleWidth)
        innerCicleView.center = CGPoint(x: 0.5, y: 0.5).applying(CGAffineTransform(scaleX: self.bounds.width, y: self.bounds.height))
        innerCicleView.layer.cornerRadius = self.innerCircleWidth / 2
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateUI()
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        self.updateUI()
    }
    
//    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
//        
//    }
}
