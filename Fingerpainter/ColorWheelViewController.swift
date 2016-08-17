//
//  ColorWheelViewController.swift
//  Fingerpainting
//
//  Created by Morgan Davison on 1/11/16.
//  Copyright © 2016 Morgan Davison. All rights reserved.
//

import UIKit

protocol ColorWheelViewControllerDelegate: class {
    func colorWheelViewControllerFinished(colorWheelViewController: ColorWheelViewController)
}

class ColorWheelViewController: UIViewController {

    @IBOutlet weak var colorWheel: ColorWheel!
    @IBOutlet weak var colorPreview: UIImageView!
    
    var selectedColor: UIColor?
    var didSelectNewColor = false
    weak var delegate: ColorWheelViewControllerDelegate?

    override var preferredContentSize: CGSize {
        get {
            if presentingViewController != nil {
                return CGSize(width: presentingViewController!.view.bounds.width, height: presentingViewController!.view.bounds.height * 0.75)
            } else {
                return super.preferredContentSize
            }
        }
        set { super.preferredContentSize = newValue }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawPreview()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Actions
    
    @IBAction func handleTapGesture(sender: UITapGestureRecognizer) {
        let point = sender.locationInView(colorWheel)
        
        if colorWheel.colorAtPoint(point) != UIColor.clearColor() {
            selectedColor = colorWheel.colorAtPoint(point)
            didSelectNewColor = true
            drawPreview()
        }
    }
    
    @IBAction func done(sender: UIBarButtonItem) {
        delegate?.colorWheelViewControllerFinished(self)
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: - Private methods
    
    private func drawPreview() {
        var color = UIColor.lightGrayColor()
        if let selectedColor = selectedColor {
            color = selectedColor
        }
        
        // Brush Width
        let radius = CGFloat(50.0)
        let offset = radius - 10 // Need to offset to center
        
        UIGraphicsBeginImageContext(colorPreview.frame.size)
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetLineCap(context, CGLineCap.Round)
        CGContextSetLineWidth(context, radius)
        CGContextSetStrokeColorWithColor(context, color.CGColor)
        CGContextMoveToPoint(context, offset, offset)
        CGContextAddLineToPoint(context, offset, offset)
        CGContextStrokePath(context)
        
        colorPreview.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }

}
