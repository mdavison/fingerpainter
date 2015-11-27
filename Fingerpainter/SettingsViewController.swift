//
//  SettingsViewController.swift
//  Fingerpainter
//
//  Created by Morgan Davison on 11/24/15.
//  Copyright © 2015 Morgan Davison. All rights reserved.
//

import UIKit

protocol SettingsViewControllerDelegate: class {
    func settingsViewControllerFinished(settingsViewController: SettingsViewController)
}

class SettingsViewController: UITableViewController {
    
    @IBOutlet weak var brushSlider: UISlider!
    @IBOutlet weak var brushLabel: UILabel!
    @IBOutlet weak var brushImage: UIImageView!
    
    @IBOutlet weak var opacitySlider: UISlider!
    @IBOutlet weak var opacityLabel: UILabel!
    @IBOutlet weak var opacityImage: UIImageView!
    
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var redLabel: UILabel!
    
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var greenLabel: UILabel!
    
    @IBOutlet weak var blueSlider: UISlider!
    @IBOutlet weak var blueLabel: UILabel!
    
    var brush: CGFloat = 10.0
    var opacity: CGFloat = 1.0
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    //var customColor = UIColor()
    
    weak var delegate: SettingsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        brushSlider.value = Float(brush)
        brushLabel.text = String(Int(brush))
        
        opacitySlider.value = Float(opacity)
        opacityLabel.text = NSString(format: "%.2f", opacity.native) as String
        
        redSlider.value = Float(red * 255.0)
        redLabel.text = "R: \(NSString(format: "%d", Int(red)) as String)"
        
        greenSlider.value = Float(green * 255.0)
        greenLabel.text = "G: \(NSString(format: "%d", Int(green)) as String)"
        
        blueSlider.value = Float(blue * 255.0)
        blueLabel.text = "B: \(NSString(format: "%d", Int(blue)) as String)"
        
        drawPreview()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - Actions
    
    @IBAction func sliderChanged(sender: UISlider) {
        if sender == brushSlider {
            brush = CGFloat(sender.value)
            //brushLabel.text = NSString(format: "%.2f", brush.native) as String
            brushLabel.text = String(Int(sender.value))
        } else {
            opacity = CGFloat(sender.value)
            opacityLabel.text = NSString(format: "%.2f", opacity.native) as String
        }
        
        drawPreview()
    }
    
    @IBAction func colorChanged(sender: UISlider) {
        red = CGFloat(redSlider.value / 255.0)
        redLabel.text = "R: \(NSString(format: "%d", Int(redSlider.value)) as String)"
        green = CGFloat(greenSlider.value / 255.0)
        greenLabel.text = "G: \(NSString(format: "%d", Int(greenSlider.value)) as String)"
        blue = CGFloat(blueSlider.value / 255.0)
        blueLabel.text = "B: \(NSString(format: "%d", Int(blueSlider.value)) as String)"
        
        //customColor = UIColor(red: red, green: green, blue: blue, alpha: opacity)
        
        drawPreview()
    }
    
    
    
    private func drawPreview() {
        if (red == 1.0 && green == 1.0 && blue == 1.0) {
            brushImage.backgroundColor = UIColor.lightGrayColor()
            opacityImage.backgroundColor = UIColor.lightGrayColor()
        } else {
            brushImage.backgroundColor = UIColor.whiteColor()
            opacityImage.backgroundColor = UIColor.whiteColor()
        }
        
        // Brush Width
        UIGraphicsBeginImageContext(brushImage.frame.size)
        var context = UIGraphicsGetCurrentContext()
        
        CGContextSetLineCap(context, CGLineCap.Round)
        CGContextSetLineWidth(context, brush)
        CGContextSetRGBStrokeColor(context, red, green, blue, 1.0)
        CGContextMoveToPoint(context, 50.0, 50.0)
        CGContextAddLineToPoint(context, 50.0, 50.0)
        CGContextStrokePath(context)
        
        brushImage.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Opacity
        UIGraphicsBeginImageContext(brushImage.frame.size)
        context = UIGraphicsGetCurrentContext()
        CGContextSetLineCap(context, CGLineCap.Round)
        CGContextSetLineWidth(context, 80)
        CGContextMoveToPoint(context, 50.0, 50.0)
        CGContextAddLineToPoint(context, 50.0, 50.0)
        
        CGContextSetRGBStrokeColor(context, red, green, blue, opacity)
        CGContextStrokePath(context)
        opacityImage.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }

}
