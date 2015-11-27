//
//  CanvasView.swift
//  Fingerpainter
//
//  Created by Morgan Davison on 11/23/15.
//  Copyright © 2015 Morgan Davison. All rights reserved.
//

import UIKit

class CanvasView: UIView {
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        //CGContextSetStrokeColor(context, UIColor.magentaColor().CGColor)
        UIColor.magentaColor().setStroke()
        CGContextSetLineWidth(context, 10)
        CGContextBeginPath(context)
        CGContextMoveToPoint(context, 0, 0)
        CGContextAddLineToPoint(context, 150, 400)
        CGContextStrokePath(context)
    }
}
