//
//  ClipView.swift
//  Cliptest
//
//  Created by edz on 2021/6/17.
//

import UIKit
/// 剪切范围 区域
public typealias ZYQuadRangleCropPoints = (CGPoint, CGPoint, CGPoint, CGPoint)

extension ZYQuadRangleClipView {
    
    /// 旋转当前的剪切区域， 按照旋转的方向， 把每个剪切顶点的值 进行旋转， 每个剪切点都是比例值
    /// - Parameters:
    ///   - points: 原来的剪切点
    ///   - orientation: 旋转方向
    /// - Returns: 旋转后的剪切点
    public static func rotateCrop(points: ZYQuadRangleCropPoints, orientation:UIImage.Orientation) -> ZYQuadRangleCropPoints {
        if orientation == UIImage.Orientation.left {
            let leftbottom = CGPoint(x: points.0.y, y: 1 - points.0.x)
            let lefttop = CGPoint(x: points.1.y, y:  1 - points.1.x)
            let righttop = CGPoint(x: points.2.y, y: 1 - points.2.x)
            let rightbottom = CGPoint(x: points.3.y, y: 1 - points.3.x)
            return (lefttop, righttop,rightbottom, leftbottom)
        } else {
            let leftbottom = CGPoint(x: 1 - points.2.y, y: points.2.x)
            let lefttop = CGPoint(x: 1 - points.3.y, y:  points.3.x)
            let righttop = CGPoint(x: 1 - points.0.y, y: points.0.x)
            let rightbottom = CGPoint(x: 1 - points.1.y, y: points.1.x)
            return (lefttop, righttop,rightbottom, leftbottom)
        }
    }
}

open class ZYQuadRangleClipView: UIView {
    
    
    
    
    open var magView: UIView?
    
    open var lineStrokeColor: UIColor! = UIColor(red: 72/255.0, green: 34/255.0, blue: 236/255, alpha: 1)
    
    open var outCircleWidth: CGFloat = 30, innerCircleWidth: CGFloat = 20
    open var outCircleColor: UIColor = .white, innerCircleColor: UIColor = UIColor.blue
    
    open var safeAreaFillColor: UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3)
    open var errorAreaFillColor: UIColor = UIColor(red: 1, green: 153/255, blue: 153/255, alpha: 0.5)
    
    open var linePath = UIBezierPath()
    open var magnifierglass: ZYMaginifierglass!
    
    /// 剪切范围是否合法
    open var isCropPathValid: Bool {
        return self.isLinePathValidate
    }
    
    /// 剪切范围变化了
    open var cropChange: (() -> Void)?
    
    /// 当前选择区域
    open var currentPoints: (CGPoint, CGPoint, CGPoint, CGPoint) {
        return (leftTopPoint, rightTopPoint, rightBottomPoint, leftBottomPoint)
    }
    
    /// 默认全选区域
    public static let initFullPoints: ZYQuadRangleCropPoints  = (CGPoint(x: 0, y: 0), CGPoint(x: 1, y: 0), CGPoint(x: 1, y: 1), CGPoint(x: 0, y: 1))
    
    
    fileprivate var moffset: CGPoint = CGPoint(x: 0, y: -70)
    
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
        
        magnifierglass = ZYMaginifierglass(offset:  moffset,
                                           radius:  100.0,
                                             scale: 2.0,
                                             borderColor:  UIColor.lightGray,
                                             borderWidth:  3.0,
                                             showsCrosshair:  true,
                                             crosshairColor:  UIColor.lightGray,
                                             crosshairWidth: 0.5)
    }
    
    public convenience init(lefttop: CGPoint, rightTop: CGPoint, rightBottom: CGPoint, leftBottom: CGPoint, mOffset: CGPoint = CGPoint(x: 0, y: -70)) {
        
        self.init(frame: CGRect.zero)
        
        moffset = mOffset
        
        leftTopPoint = lefttop
        rightTopPoint = rightTop
        rightBottomPoint = rightBottom
        leftBottomPoint = leftBottom
        
        
        magnifierglass = ZYMaginifierglass(offset:  moffset,
                                           radius:  100.0,
                                             scale: 2.0,
                                             borderColor:  UIColor.lightGray,
                                             borderWidth:  3.0,
                                             showsCrosshair:  true,
                                             crosshairColor:  UIColor.lightGray,
                                             crosshairWidth: 0.5)
    }
    
    public convenience init(mOffset: CGPoint = CGPoint(x: 0, y: -70)) {
        self.init(frame: CGRect.zero)
        moffset = mOffset
        magnifierglass = ZYMaginifierglass(offset:  moffset,
                                           radius:  100.0,
                                             scale: 2.0,
                                             borderColor:  UIColor.lightGray,
                                             borderWidth:  3.0,
                                             showsCrosshair:  true,
                                             crosshairColor:  UIColor.lightGray,
                                             crosshairWidth: 0.5)
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
        
        if ges.state  == .began {
            ges.view?.isHidden = true
        }
        
        if ges.state == .ended || ges.state == .cancelled || ges.state == .failed {
            ges.view?.isHidden = false
        }
        
        var point = ges.location(in: self)
        var imagpoin = ges.location(in: self.magView)
        let convertRect = self.convert(self.bounds, to: self.magView)
        print("mag point= \(imagpoin)- converntframe = \(convertRect) ")
        
        if imagpoin.x < convertRect.minX {
            imagpoin.x =  convertRect.minX
        }
        
        if imagpoin.x > convertRect.maxX {
            imagpoin.x =  convertRect.maxX
        }

        if imagpoin.y <  convertRect.minY {
            imagpoin.y =  convertRect.minY
        }
        
        if imagpoin.y > convertRect.maxY {
            imagpoin.y =  convertRect.maxY
        }
        
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
            magnifierglass.magnifiedView = self.magView
//            magnifierglass.testView = self
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
        
        if ges.state == .ended {
            self.cropChange?()
        }
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
/// 扩展范围
let extendSpace: CGFloat = 45.0
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
        let insetFrame = self.bounds.insetBy(dx: -extendSpace, dy: -extendSpace)
        print("ZYQuadRangleClipView  point+ \(point)-frame = \(insetFrame)")
        return insetFrame.contains(point)
    }
}


/// 实现了扩展触摸范围的imageview
open class ZYQuadRangelClipImageView: UIImageView {
   
    open override func addSubview(_ view: UIView) {
        if view is ZYQuadRangleClipView {
            tmpclipView = view as? ZYQuadRangleClipView
        }
        super.addSubview(view)
    }
    
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let insetFrame = self.bounds.insetBy(dx: -(extendSpace), dy: -extendSpace)
        let co = insetFrame.contains(point)
        print("ZYQuadRangelClipImageView point+ \(point)-frame = \(insetFrame)-")
         return co
    }
}

/// 当触摸点不在ZYQuadRangelClipExtensionImageView范围的时候，比如x <0的时候，ZYQuadRangelClipExtensionImageView.subviews = nil, 不知道为什么，	导致无法获取到subview 所有使用了全局变量
///
var tmpclipView: ZYQuadRangleClipView?
/// 扩大区域
open class ZYQuadRangelClipExtensionImageView: UIImageView {
    open override func addSubview(_ view: UIView) {
        if view is ZYQuadRangleClipView {
            tmpclipView = view as? ZYQuadRangleClipView
        }
        super.addSubview(view)
    }
   
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let insetFrame = self.bounds.insetBy(dx: -(extendSpace), dy: -extendSpace)
        let co = insetFrame.contains(point)
        print("ZYQuadRangelClipImageView point+ \(point)-frame = \(insetFrame)-")
         return co
    }
    
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if self.point(inside: point, with: event) == true && tmpclipView != nil {
            let convertedPoint = tmpclipView!.convert(point, from: self)
            let hitview = tmpclipView?.hitTest(convertedPoint, with: event)
            print(" point+ \(point)-subview=\(self.subviews)-hitview = \(String(describing: hitview))")
            return hitview
        }
        return super.hitTest(point, with: event)
    }
}
