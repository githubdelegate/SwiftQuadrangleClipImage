//
//  ClipView.swift
//  Cliptest
//
//  Created by edz on 2021/6/17.
//

import UIKit

class ZYClipPointView: UIView {
    
    var circleColor: UIColor = .white
    var innerCircleColor: UIColor = .blue
    
    var circleWidth: CGFloat = 30
    var innerCircleWidth: CGFloat = 25
    
    var innerCicleView: UIView = UIView()
    var circleView: UIView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        circleView.backgroundColor = self.circleColor
        self.addSubview(circleView)
        innerCicleView.backgroundColor = self.innerCircleColor
        self.addSubview(innerCicleView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateUI() {
        circleView.frame.size = CGSize(width: self.circleWidth, height: self.circleWidth)
        circleView.center = CGPoint(x: 0.5, y: 0.5).applying(CGAffineTransform(scaleX: self.bounds.width, y: self.bounds.height))
        circleView.layer.cornerRadius = self.circleWidth / 2

        innerCicleView.frame.size = CGSize(width: self.innerCircleWidth, height: self.innerCircleWidth)
        innerCicleView.center = CGPoint(x: 0.5, y: 0.5).applying(CGAffineTransform(scaleX: self.bounds.width, y: self.bounds.height))
        innerCicleView.layer.cornerRadius = self.innerCircleWidth / 2
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        self.updateUI()
    }
}

class ZYQuadRangleClipView: UIView {

    var lineStrokeColor: UIColor! = UIColor(red: 72/255.0, green: 34/255.0, blue: 236/255, alpha: 1)
    var linefillColor: UIColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0.5)
    var lineErrorTipColor = UIColor(red: 1, green: 153/255, blue: 153/255, alpha: 1)
    var linePath = UIBezierPath()
    
    ///  四个顶点位置  使用的左上角坐标系  比例值
    var leftTopPoint = CGPoint(x: 0, y: 0)
    var rightTopPoint = CGPoint(x: 1, y: 0)
    var leftBottomPoint = CGPoint(x: 0, y: 1)
    var rightBottomPoint = CGPoint(x: 1, y: 1)
    
    var lefttop = ZYClipPointView()
    var leftbottom = ZYClipPointView()
    var righttop = ZYClipPointView()
    var rightbottom = ZYClipPointView()
    
    fileprivate var ltges: UIPanGestureRecognizer!
    fileprivate var lbges: UIPanGestureRecognizer!
    fileprivate var rtges: UIPanGestureRecognizer!
    fileprivate var rbges: UIPanGestureRecognizer!
    
    /// 是否合法
    private var isLinePathValidate = true

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(lefttop)
        self.addSubview(leftbottom)
        self.addSubview(righttop)
        self.addSubview(rightbottom)
        
        ltges = UIPanGestureRecognizer(target: self, action: #selector(panGes))
        lbges = UIPanGestureRecognizer(target: self, action: #selector(panGes))
        rtges = UIPanGestureRecognizer(target: self, action: #selector(panGes))
        rbges = UIPanGestureRecognizer(target: self, action: #selector(panGes))
        
        lefttop.frame.size = CGSize(width: 80, height: 80)
//        lefttop.backgroundColor = .purple
        lefttop.isUserInteractionEnabled = true
        
        leftbottom.frame.size = CGSize(width: 80, height: 80)
//        leftbottom.backgroundColor = .blue
        leftbottom.isUserInteractionEnabled = true
        
        righttop.frame.size = CGSize(width: 80, height: 80)
//        righttop.backgroundColor = .blue
        
        rightbottom.frame.size = CGSize(width: 30, height: 30)
//        rightbottom.backgroundColor = .blue
        
        
        lefttop.addGestureRecognizer(ltges)
        ltges.maximumNumberOfTouches = 1
        
        leftbottom.addGestureRecognizer(lbges)
        lbges.maximumNumberOfTouches = 1
        righttop.addGestureRecognizer(rtges)
        rtges.maximumNumberOfTouches = 1
        rightbottom.addGestureRecognizer(rbges)
        rbges.maximumNumberOfTouches = 1
        
        linePath.lineWidth = 5
        linePath.lineCapStyle = .round
        linePath.setLineDash([5, 5], count: 2, phase: 0)
        linePath.lineJoinStyle = .bevel
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        // 计算imageview 里面image 大小
        
        if let imv = self.superview as? UIImageView, let img = imv.image {
           let fitSize =  CGSize.aspectFit(image: img.size, boundingSize: self.superview!.bounds.size)
            
            self.frame.size = fitSize.size
            self.center = CGPoint(x: 0.5, y: 0.5).applying(CGAffineTransform(scaleX: self.superview!.bounds.width, y: self.superview!.bounds.height))
            superview!.isUserInteractionEnabled = true
            self.backgroundColor = .clear
            
            self.lefttop.center = CGPoint(x: 0.2, y: 0.2).applying(CGAffineTransform(scaleX: self.bounds.width, y: self.bounds.height))
            self.leftbottom.center = CGPoint(x: 0, y: 1).applying(CGAffineTransform(scaleX: self.bounds.width, y: self.bounds.height))
            self.righttop.center = CGPoint(x: 1, y: 0).applying(CGAffineTransform(scaleX: self.bounds.width, y: self.bounds.height))
            self.rightbottom.center = CGPoint(x: 1, y: 1).applying(CGAffineTransform(scaleX: self.bounds.width, y: self.bounds.height))
        
            self.linePath.move(to: self.lefttop.center)
            self.linePath.addLine(to: self.lefttop.center)
            self.linePath.addLine(to: self.righttop.center)
            self.linePath.addLine(to: self.rightbottom.center)
            self.linePath.addLine(to: self.leftbottom.center)
            self.linePath.close()
            
        }
    }
    
    @objc func panGes(ges: UIPanGestureRecognizer) {
        var point = ges.location(in: self)
        
        if point.x <= 0 {
            point.x = 0
        }
        
        if point.y <= 0 {
            point.y = 0
        }
        
        if point.x >= self.bounds.width {
            point.x = self.bounds.width
        }
        
        if point.y >= self.bounds.height {
            point.y = self.bounds.height
        }
                
        if ges == ltges {
            lefttop.center = point
            leftTopPoint = point.applying(CGAffineTransform(scaleX: 1/self.bounds.width, y: 1/self.bounds.height))
            print("xxx")
            
        } else if ges == rtges {
            righttop.center = point
            rightTopPoint = point.applying(CGAffineTransform(scaleX: 1/self.bounds.width, y: 1/self.bounds.height))
        } else if ges == lbges {
            leftbottom.center = point
            leftBottomPoint = point.applying(CGAffineTransform(scaleX: 1/self.bounds.width, y: 1/self.bounds.height))
        } else if ges == rbges {
            rightbottom.center = point
            rightBottomPoint = point.applying(CGAffineTransform(scaleX: 1/self.bounds.width, y: 1/self.bounds.height))
        }
        
        self.refreshLinePath()
        
        let angle1 = lefttop.center.angleBetween(point1: leftbottom.center, point2: righttop.center)
        let angle2 = righttop.center.angleBetween(point1: lefttop.center, point2: rightbottom.center)
        let angle3 = rightbottom.center.angleBetween(point1: righttop.center, point2: leftbottom.center)
        let angle4 = leftbottom.center.angleBetween(point1: lefttop.center, point2: rightbottom.center)
        
        let totalAngle = angle1 + angle2 + angle3 + angle4
        
        print(" angle == \(totalAngle) -- \(CGFloat.pi * 2)")
        let absvalue =  abs(totalAngle - (CGFloat.pi) * 2)
        print(" 误差 = \(absvalue)")
        if absvalue < 0.0001 {
            print("！！！！合法")
            self.isLinePathValidate = true
        } else {
            self.isLinePathValidate = false
            print("！！！！ 非法")
        }
        self.setNeedsDisplay()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func refreshLinePath() {
        self.linePath.removeAllPoints()
        self.linePath.move(to: self.lefttop.center)
        self.linePath.addLine(to: self.lefttop.center)
        self.linePath.addLine(to: self.righttop.center)
        self.linePath.addLine(to: self.rightbottom.center)
        self.linePath.addLine(to: self.leftbottom.center)
        self.linePath.close()
    }
    
    override func draw(_ rect: CGRect) {
        if self.isLinePathValidate == false {
            self.lineErrorTipColor.setFill()
        } else {
            self.linefillColor.setFill()
        }
        self.lineStrokeColor.setStroke()
        
        self.linePath.stroke()
        self.linePath.fill()
    }
    
    public func clip()  -> UIImage? {
        if let imv = self.superview as? UIImageView, let img = imv.image {
             let clip =  img.clipImageWithPoint(topLeft: self.leftTopPoint, topRight: self.rightTopPoint, bottomRight: self.rightBottomPoint, bottomLeft: self.leftBottomPoint)
            return clip
        }
        return nil
    }
}
