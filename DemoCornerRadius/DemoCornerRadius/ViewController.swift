//
//  ViewController.swift
//  DemoCornerRadius
//
//  Created by zj－db0465 on 16/3/3.
//  Copyright © 2016年 icetime17. All rights reserved.
//

import UIKit

extension UIImage {
    func cs_imageWithCornerRadius(radius: CGFloat, sizeToFit: CGSize) -> UIImage {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: sizeToFit)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.mainScreen().scale)
        let path: CGPathRef = UIBezierPath(roundedRect: rect, byRoundingCorners: UIRectCorner.AllCorners, cornerRadii: CGSize(width: radius, height: radius)).CGPath
        CGContextAddPath(UIGraphicsGetCurrentContext(), path)
        CGContextClip(UIGraphicsGetCurrentContext())
        
        self.drawInRect(rect)
        CGContextDrawPath(UIGraphicsGetCurrentContext(), .FillStroke)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

extension UIImageView {
    func cs_cornerRadiusImageView(radius: CGFloat) {
        self.image = self.image?.cs_imageWithCornerRadius(radius, sizeToFit: self.bounds.size)
    }
}

extension UIView {
    func cs_cornerRadius(radius: CGFloat,
                    borderWidth: CGFloat,
                    borderColor: UIColor,
                backgroundColor: UIColor) {
        let width = self.frame.size.width
        let height = self.frame.size.height
        
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, UIScreen.mainScreen().scale)
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetLineWidth(context, borderWidth)
        CGContextSetStrokeColorWithColor(context, borderColor.CGColor)
        CGContextSetFillColorWithColor(context, backgroundColor.CGColor)
                    
        CGContextMoveToPoint(context,
                                width - borderWidth / 2,
                                radius + borderWidth / 2)  // 开始坐标
        CGContextAddArcToPoint(context,
                                width - borderWidth / 2,
                                height - borderWidth / 2,
                                width - radius - borderWidth / 2,
                                height - borderWidth / 2,
                                radius)  // 右下角
        CGContextAddArcToPoint(context,
                                borderWidth / 2,
                                height - borderWidth / 2,
                                borderWidth / 2,
                                height - radius - borderWidth / 2,
                                radius) // 左下角
        CGContextAddArcToPoint(context,
                                borderWidth / 2,
                                borderWidth / 2,
                                width - borderWidth / 2,
                                borderWidth / 2,
                                radius) // 左上角
        CGContextAddArcToPoint(context,
                                width - borderWidth / 2,
                                borderWidth / 2,
                                width - borderWidth / 2,
                                radius + borderWidth / 2,
                                radius) // 右上角
        
        CGContextDrawPath(context, .FillStroke)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let imageView: UIImageView = UIImageView(image: image)
        self.insertSubview(imageView, atIndex: 0)
    }
}

class ViewController: UIViewController {

    var label: UILabel!
    var btn: UIButton!
    var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.btn = UIButton(frame: CGRectMake(50, self.view.frame.size.height - 100, self.view.frame.size.width - 100, 50))
        self.btn.setTitle("Demo", forState: UIControlState.Normal)
        self.btn.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        self.btn.setTitleColor(UIColor.redColor(), forState: UIControlState.Highlighted)
        self.btn.layer.borderColor = UIColor.redColor().CGColor
        self.btn.layer.cornerRadius = 5.0
        self.btn.layer.borderWidth = 2.0
        self.btn.addTarget(self, action: Selector("actionBtn"), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(self.btn)
        
        
        self.label = UILabel(frame: CGRectMake(50, self.view.frame.size.height - 200, self.view.frame.size.width - 100, 50))
        self.label.backgroundColor = UIColor.grayColor()
        self.label.textAlignment = NSTextAlignment.Center
        self.label.layer.cornerRadius = 5.0
        /**
         cornerRadius默认只会影响到View的背景颜色和border
         UILabel/UIImageView这样内部还有子视图的不行，要设置masksToBounds属性为true
        */
        self.label.layer.masksToBounds = true
        self.label.text = "label"
        self.view.addSubview(self.label)

        
        self.imageView = UIImageView(frame: CGRectMake(100, 50, self.view.frame.size.width - 200, 200))
        self.imageView.image = UIImage(named: "Model.png")
//        self.imageView.layer.cornerRadius = 10.0
//        self.imageView.layer.masksToBounds = true
        self.imageView.cs_cornerRadiusImageView(10.0)
        self.view.addSubview(self.imageView)
        
        let aView: UIView = UIView(frame: CGRectMake(100, 300, self.view.frame.size.width - 200, 100))
        // 普通视图直接使用即可
        //        aView.layer.cornerRadius = 10.0
        // 使用cs_cornerRadius的扩展方法，就不能使用UIView自身的borderWidth，boarderColor，backgroundColor了
        aView.cs_cornerRadius(10.0,
                            borderWidth: 2.0,
                            borderColor: UIColor.redColor(),
                        backgroundColor: UIColor.greenColor())
        self.view.addSubview(aView)
    }

    func actionBtn(sender: UIButton) {
    
    }
    
}

