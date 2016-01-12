//
//  ColorViewController.swift
//  Fingerpainter
//
//  Created by Morgan Davison on 11/30/15.
//  Copyright © 2015 Morgan Davison. All rights reserved.
//

import UIKit

protocol ColorViewControllerDelegate: class {
    func colorViewControllerFinished(colorViewController: ColorViewController)
}

class ColorViewController: UIViewController {

    @IBOutlet weak var colorImage: UIImageView!
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var redLabel: UILabel!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var greenLabel: UILabel!
    @IBOutlet weak var blueSlider: UISlider!
    @IBOutlet weak var blueLabel: UILabel!
    
    //var customColor = CustomColor(red: 0.0, green: 0.0, blue: 0.0)!
    var brush: CGFloat = 10.0
    var opacity: CGFloat = 1.0
    
    override var preferredContentSize: CGSize {
        get {
            if presentingViewController != nil {
                return CGSize(width: presentingViewController!.view.bounds.width, height: 250)
            } else {
                return super.preferredContentSize
            }
        }
        set { super.preferredContentSize = newValue }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        redSlider.value = Float(customColor.red * 255.0)
//        redLabel.text = "⚫︎ \(NSString(format: "%d", Int(customColor.red * 255.0)) as String)"
//        
//        greenSlider.value = Float(customColor.green * 255.0)
//        greenLabel.text = "⚫︎ \(NSString(format: "%d", Int(customColor.green * 255.0)) as String)"
//        
//        blueSlider.value = Float(customColor.blue * 255.0)
//        blueLabel.text = "⚫︎ \(NSString(format: "%d", Int(customColor.blue * 255.0)) as String)"
        
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
    
    @IBAction func colorChanged(sender: UISlider) {
//        customColor.red = CGFloat(redSlider.value / 255.0)
//        redLabel.text = "⚫︎ \(NSString(format: "%d", Int(redSlider.value)) as String)"
//        customColor.green = CGFloat(greenSlider.value / 255.0)
//        greenLabel.text = "⚫︎ \(NSString(format: "%d", Int(greenSlider.value)) as String)"
//        customColor.blue = CGFloat(blueSlider.value / 255.0)
//        blueLabel.text = "⚫︎ \(NSString(format: "%d", Int(blueSlider.value)) as String)"
        
        drawPreview()
    }
    
    
    private func drawPreview() {
//        if (customColor.red == 1.0 && customColor.green == 1.0 && customColor.blue == 1.0) {
//            colorImage.backgroundColor = UIColor.lightGrayColor()
//        } else {
//            colorImage.backgroundColor = UIColor.whiteColor()
//        }
//        
//        // Brush Width
//        UIGraphicsBeginImageContext(colorImage.frame.size)
//        let context = UIGraphicsGetCurrentContext()
//        
//        CGContextSetLineCap(context, CGLineCap.Round)
//        CGContextSetLineWidth(context, brush)
//        CGContextSetRGBStrokeColor(context, customColor.red, customColor.green, customColor.blue, opacity)
//        CGContextMoveToPoint(context, 50.0, 50.0)
//        CGContextAddLineToPoint(context, 50.0, 50.0)
//        CGContextStrokePath(context)
//        
//        colorImage.image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
    }

}
