//
//  BrushSizeViewController.swift
//  Fingerpainter
//
//  Created by Morgan Davison on 11/27/15.
//  Copyright © 2015 Morgan Davison. All rights reserved.
//

import UIKit

protocol BrushSizeViewControllerDelegate: class {
    func brushSizeViewControllerFinished(brushSizeViewController: BrushSizeViewController)
}

class BrushSizeViewController: UIViewController {

    @IBOutlet weak var sizeSlider: UISlider!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var sizeImage: UIImageView!
    
    //weak var delegate: UIPopoverPresentationControllerDelegate?
    
    var brush: CGFloat = 10.0
    var opacity: CGFloat = 1.0
//    var red: CGFloat = 0.0
//    var green: CGFloat = 0.0
//    var blue: CGFloat = 0.0
    var color = UIColor.blackColor()
    
    override var preferredContentSize: CGSize {
        get {
            if presentingViewController != nil {
                //return CGSize(width: presentingViewController!.view.bounds.width, height: 170)
                //return CGSize(width: presentingViewController!.view.bounds.width, height: 10)
                return CGSizeMake(presentingViewController!.view.bounds.width, 170)
            } else {
                return super.preferredContentSize
            }
        }
        set { super.preferredContentSize = newValue }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sizeSlider.value = Float(brush)
        sizeLabel.text = String(Int(brush))
        
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
    
    
    // MARK: - Actions
    
    @IBAction func sliderChanged(sender: UISlider) {
        brush = CGFloat(sender.value)
        sizeLabel.text = String(Int(sender.value))
        
        drawPreview()
    }
    
    
    private func drawPreview() {
//        if (red == 1.0 && green == 1.0 && blue == 1.0) {
//            sizeImage.backgroundColor = UIColor.lightGrayColor()
//        } else {
//            sizeImage.backgroundColor = UIColor.whiteColor()
//        }
        
        UIGraphicsBeginImageContext(sizeImage.frame.size)
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetLineCap(context, CGLineCap.Round)
        CGContextSetLineWidth(context, brush)
        //CGContextSetRGBStrokeColor(context, red, green, blue, opacity)
        CGContextSetStrokeColorWithColor(context, color.CGColor)
        CGContextMoveToPoint(context, 50.0, 50.0)
        CGContextAddLineToPoint(context, 50.0, 50.0)
        CGContextStrokePath(context)
        
        sizeImage.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }


}
