//
//  ClipView.swift
//  Cliptest
//
//  Created by edz on 2021/6/17.
//

import UIKit

open class ZYQuadRangleClipView: UIView {
    
    open var lineStrokeColor: UIColor! = UIColor(red: 72/255.0, green: 34/255.0, blue: 236/255, alpha: 1)
    
    open var outCircleWidth: CGFloat = 30, innerCircleWidth: CGFloat = 20
    open var outCircleColor: UIColor = .white, innerCircleColor: UIColor = UIColor.blue
    
    open var safeAreaFillColor: UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3)
    open var errorAreaFillColor: UIColor = UIColor(red: 1, green: 153/255, blue: 153/255, alpha: 0.5)
    
    open var linePath = UIBezierPath()
    open var magnifierglass: ZYMaginifierglass!
    
    
    /// 当前选择区域
    open var currentPoints: (CGPoint, CGPoint, CGPoint, CGPoint) {
        return (leftTopPoint, rightTopPoint, leftBottomPoint, rightBottomPoint)
    }
    
    /// 默认全选区域
    public static let initFullPoints: (CGPoint, CGPoint, CGPoint, CGPoint)  = (CGPoint(x: 0, y: 0), CGPoint(x: 1, y: 0), CGPoint(x: 0, y: 1), CGPoint(x: 1, y: 1))
    
    ///  四个顶点位置  使用的左上角坐标系  比例值
    fileprivate var leftTopPoint = CGPoint(x: 0, y: 0)
    fileprivate var rightTopPoint = CGPoint(x: 1, y: 0)
    fileprivate var leftBottomPoint = CGPoint(x: 0, y: 1)
    fileprivate var rightBottomPoint = CGPoint(x: 1, y: 1)
    
    fileprivate var lefttop = ZYClipPointView()
    fileprivate var leftbottom = ZYClipPointView()
    fileprivate var righttop = ZYClipPointView()
    fileprivate var rightbottom = ZYClipPointView()
    
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
        
        
        setupPoint(view: lefttop)
        setupPoint(view: leftbottom)
        setupPoint(view: righttop)
        setupPoint(view: rightbottom)
        
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
        
        magnifierglass = ZYMaginifierglass(offset:  CGPoint.zero,
                                           radius:  100.0,
                                             scale: 2.0,
                                             borderColor:  UIColor.lightGray,
                                             borderWidth:  3.0,
                                             showsCrosshair:  true,
                                             crosshairColor:  UIColor.lightGray,
                                             crosshairWidth: 0.5)
    }
    
    public convenience init(lefttop: CGPoint, rightTop: CGPoint, rightBottom: CGPoint, leftBottom: CGPoint) {
        self.init(frame: CGRect.zero)
        
        leftTopPoint = lefttop
        rightTopPoint = rightTop
        rightBottomPoint = rightBottom
        leftBottomPoint = leftBottom
    }
    
    func setupPoint(view: ZYClipPointView) {
        let mul: CGFloat = 3
        view.frame.size = CGSize(width: outCircleWidth * mul, height: outCircleWidth * mul)
        view.circleColor = self.outCircleColor;
        view.innerCircleColor = self.innerCircleColor;
        view.circleWidth = self.outCircleWidth;
        view.innerCircleWidth = self.innerCircleWidth
    }
    
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        setupPoint(view: self.lefttop)
        setupPoint(view: leftbottom)
        setupPoint(view: righttop)
        setupPoint(view: rightbottom)
        
    }
    
    open override func didMoveToWindow() {
        super.didMoveToWindow()
        
        // 计算imageview 里面image 大小
        
        guard self.superview != nil else {
            return
        }
        
        if let imv = self.superview as? UIImageView, let img = imv.image {
           let fitSize =  CGSize.aspectFit(image: img.size, boundingSize: self.superview!.bounds.size)
            
            self.frame.size = fitSize.size
            self.center = CGPoint(x: 0.5, y: 0.5).applying(CGAffineTransform(scaleX: self.superview!.bounds.width, y: self.superview!.bounds.height))
            superview!.isUserInteractionEnabled = true
            self.backgroundColor = .clear
            
            self.lefttop.center = self.leftTopPoint.applying(CGAffineTransform(scaleX: self.bounds.width, y: self.bounds.height))
            self.leftbottom.center = self.leftBottomPoint.applying(CGAffineTransform(scaleX: self.bounds.width, y: self.bounds.height))
            self.righttop.center = self.rightTopPoint.applying(CGAffineTransform(scaleX: self.bounds.width, y: self.bounds.height))
            self.rightbottom.center = self.rightBottomPoint.applying(CGAffineTransform(scaleX: self.bounds.width, y: self.bounds.height))
        
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
        let imagpoin = ges.location(in: self.superview)
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
        
        switch ges.state {
        case .began:
            magnifierglass.magnifiedView = self.superview
            magnifierglass.magnify(at: imagpoin)
        case .changed:
            magnifierglass.magnify(at: imagpoin)
        case .cancelled, .ended:
            magnifierglass.magnifiedView = nil
        case .possible, .failed:
            magnifierglass.magnifiedView = nil
        @unknown default:
            magnifierglass.magnifiedView = nil
        }
        
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
    
    required public init?(coder: NSCoder) {
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
    
    open override func draw(_ rect: CGRect) {
        if self.isLinePathValidate == false {
            self.errorAreaFillColor.setFill()
        } else {
            self.safeAreaFillColor.setFill()
        }
        self.lineStrokeColor.setStroke()
        
        self.linePath.stroke()
        self.linePath.fill()
    }
    
    
    /// 获取当前剪切的区域
    /// - Returns: 返回四个点 的 比例位置
    open func getCurrentClipArea() -> (topLeft: CGPoint, topRight: CGPoint, bottomLeft: CGPoint, bottomRight: CGPoint) {
        return (self.leftTopPoint, self.rightTopPoint,self.leftBottomPoint, self.rightBottomPoint)
    }
    
    public static func clipViewPoints(lefttop: CGPoint, rightTop: CGPoint, rightBottom: CGPoint, leftBottom: CGPoint) -> ZYQuadRangleClipView {
        let clip = ZYQuadRangleClipView()
        clip.leftTopPoint = lefttop
        clip.rightTopPoint = rightTop
        clip.rightBottomPoint = rightBottom
        clip.leftBottomPoint = leftBottom
        return clip
    }
}

extension ZYQuadRangleClipView {
    
    /// 如果superview 是 imageview 直接剪切获取 image
    /// - Returns: image
    open func clipImage() -> UIImage? {
        if self.isLinePathValidate == false {
            return nil
        }


        if let imv = self.superview as? UIImageView, let img = imv.image {
            if self.leftTopPoint == CGPoint(x: 0, y: 0), self.leftBottomPoint == CGPoint(x: 0, y: 1), self.rightTopPoint == CGPoint(x: 1, y: 0), self.rightBottomPoint == CGPoint(x: 1, y: 1) {
                return img
            }
             let clip =  img.clipImageWithPoint(topLeft: self.leftTopPoint, topRight: self.rightTopPoint, bottomRight: self.rightBottomPoint, bottomLeft: self.leftBottomPoint)
            return clip
        }
        return nil
    }
    
    
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let insetFrame = self.bounds.insetBy(dx: -45, dy: -45)
        return insetFrame.contains(point)
    }
}


/// 实现了扩展触摸范围的imageview
open class ZYQuadRangelClipImageView: UIImageView {
    /// 扩展范围
    var extendSpace: CGFloat = 45.0
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let insetFrame = self.bounds.insetBy(dx: -(extendSpace), dy: -extendSpace)
         return insetFrame.contains(point)
    }
}
