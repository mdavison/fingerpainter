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
    
    //weak var delegate: UIPopoverPresentationControllerDelegate?
    
    var opacity: CGFloat = 1.0
    var brush: CGFloat = 10.0
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func sliderChanged(sender: UISlider) {
        opacity = CGFloat(sender.value)
        opacityLabel.text = NSString(format: "%.2f", opacity.native) as String
        
        drawPreview()
    }
    
    private func drawPreview() {
        if (red == 1.0 && green == 1.0 && blue == 1.0) {
            opacityImage.backgroundColor = UIColor.lightGrayColor()
        } else {
            opacityImage.backgroundColor = UIColor.whiteColor()
        }
        
        UIGraphicsBeginImageContext(opacityImage.frame.size)
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetLineCap(context, CGLineCap.Round)
        CGContextSetLineWidth(context, brush)
        CGContextMoveToPoint(context, 50.0, 50.0)
        CGContextAddLineToPoint(context, 50.0, 50.0)
        
        CGContextSetRGBStrokeColor(context, red, green, blue, opacity)
        CGContextStrokePath(context)
        opacityImage.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }

}
