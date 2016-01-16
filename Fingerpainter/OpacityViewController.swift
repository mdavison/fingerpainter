//
//  OpacityViewController.swift
//  Fingerpainter
//
//  Created by Morgan Davison on 11/30/15.
//  Copyright © 2015 Morgan Davison. All rights reserved.
//

import UIKit

protocol OpacityViewControllerDelegate: class {
    func opacityViewControllerFinished(opacityViewController: OpacityViewController)
}

class OpacityViewController: UIViewController {

    @IBOutlet weak var opacitySlider: UISlider!
    @IBOutlet weak var opacityLabel: UILabel!
    @IBOutlet weak var opacityImage: UIImageView!
    
    var opacity: CGFloat = 1.0
    var brush: CGFloat = 50.0
    var color = UIColor.blackColor()
    
    override var preferredContentSize: CGSize {
        get {
            if presentingViewController != nil {
                return CGSize(width: presentingViewController!.view.bounds.width, height: 170)
            } else {
                return super.preferredContentSize
            }
        }
        set { super.preferredContentSize = newValue }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        opacitySlider.value = Float(opacity)
        opacityLabel.text = NSString(format: "%.2f", opacity.native) as String
        
        drawPreview()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func sliderChanged(sender: UISlider) {
        opacity = CGFloat(sender.value)
        opacityLabel.text = NSString(format: "%.2f", opacity.native) as String
        
        drawPreview()
    }
    
    private func drawPreview() {
        UIGraphicsBeginImageContext(opacityImage.frame.size)
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetLineCap(context, CGLineCap.Round)
        CGContextSetLineWidth(context, brush)
        CGContextMoveToPoint(context, 50.0, 50.0)
        CGContextAddLineToPoint(context, 50.0, 50.0)
        
        CGContextSetStrokeColorWithColor(context, color.CGColor) 
        CGContextSetAlpha(context, opacity)
        CGContextStrokePath(context)
        opacityImage.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }

}
