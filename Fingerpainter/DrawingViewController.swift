//
//  DrawingViewController.swift
//  Fingerpainter
//
//  Created by Morgan Davison on 11/23/15.
//  Copyright © 2015 Morgan Davison. All rights reserved.
//

import UIKit

class DrawingViewController: UIViewController, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var canvas: UIImageView!
    @IBOutlet weak var tempCanvas: UIImageView!
    
    @IBOutlet weak var blackButton: UIButton!
    @IBOutlet weak var grayButton: UIButton!
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var orangeButton: UIButton!
    @IBOutlet weak var brownButton: UIButton!
    @IBOutlet weak var yellowButton: UIButton!
    @IBOutlet weak var whiteButton: UIButton!
    @IBOutlet weak var customColorButton: UIButton!
    
    
    var lastPoint = CGPoint.zero
    var prevPoint1 = CGPoint.zero
    var prevPoint2 = CGPoint.zero
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var brushWidth: CGFloat = 10.0
    var opacity: CGFloat = 1.0
    var swiped = false
    var customColor = UIColor()
    var customColorRedComponent: CGFloat = 0.0
    var customColorGreenComponent: CGFloat = 0.0
    var customColorBlueComponent: CGFloat = 0.0
    var customColorAlphaComponent: CGFloat = 1.0
    
    var activityController: UIActivityViewController?
    
    let colors: [(CGFloat, CGFloat, CGFloat)] = [
        (0, 0, 0), // Black
        (128.0 / 255.0, 128.0 / 255.0, 128.0 / 255.0), // Gray
        (1.0, 0, 0), // Red
        (0.0, 128.0 / 255.0, 1.0), // Blue
        (0.0, 128.0 / 255.0, 0), // Green
        (1.0, 128.0 / 255.0, 0), // Orange
        (128.0 / 255.0, 64.0 / 255.0, 0), // Brown
        (1.0, 1.0, 102.0 / 255.0), // Yellow
        (1.0, 1.0, 1.0) // White
    ]
    
    struct Storyboard {
        static let SettingsSegueIdentifier = "ShowSettings"
        static let BrushSizeSegueIdentifier = "ShowBrushSize"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        swiped = false
        let touch = touches.first! as UITouch
        prevPoint1 = touch.previousLocationInView(view)
        prevPoint2 = touch.previousLocationInView(view)
        lastPoint = touch.locationInView(view)
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        swiped = true
        let touch = touches.first! as UITouch
        let currentPoint = touch.locationInView(view)
        
        prevPoint2 = prevPoint1
        prevPoint1 = touch.previousLocationInView(view)
        
        drawLineTo(currentPoint)
        
        lastPoint = currentPoint
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if !swiped {
            // draw a single point
            drawLineFrom(lastPoint, toPoint: lastPoint)
        }
        
        // Merge tempCanvas into canvas
        UIGraphicsBeginImageContext(canvas.frame.size)
        canvas.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: CGBlendMode.Normal, alpha: 1.0)
        tempCanvas.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: CGBlendMode.Normal, alpha: opacity)
        //canvas.contentMode = .ScaleAspectFit
        canvas.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        tempCanvas.image = nil
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Storyboard.SettingsSegueIdentifier {
            let navigationController = segue.destinationViewController as! UINavigationController
            let settingsViewController = navigationController.topViewController as! SettingsViewController
            settingsViewController.delegate = self
            settingsViewController.brush = brushWidth
            settingsViewController.opacity = opacity
            settingsViewController.red = red
            settingsViewController.green = green
            settingsViewController.blue = blue
        } else if segue.identifier == Storyboard.BrushSizeSegueIdentifier {
            let popoverPresentationController = segue.destinationViewController.popoverPresentationController
            popoverPresentationController!.delegate = self
            //print(popoverPresentationController?.presentedViewController)
            if let brushSizeViewController = popoverPresentationController?.presentedViewController as? BrushSizeViewController {
                brushSizeViewController.brush = brushWidth
            }
        }
    }
    
    
    // MARK: - UIPopoverPresentationControllerDelegate
    
//    func presentationController(controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
//        let presentedViewController = controller.presentedViewController
//        let navigationController = UINavigationController(rootViewController: presentedViewController)
//        let dismissButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "dismissPopover:")
//        presentedViewController.navigationItem.rightBarButtonItem = dismissButton
//        
//        return navigationController
//    }
//    
//    func dismissPopover(sender: AnyObject) {
//        self.dismissViewControllerAnimated(true, completion: nil)
//    }
    
    func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController) {
        if let brushSizeViewController = popoverPresentationController.presentedViewController as? BrushSizeViewController {
            brushSizeViewControllerFinished(brushSizeViewController)
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    
    // MARK: - Actions
    
    @IBAction func clearImage(sender: UIBarButtonItem) {
        canvas.image = nil 
    }
    
    @IBAction func colorChanged(sender: AnyObject) {
        var index = sender.tag ?? 0
        
        if index < 0 || index >= colors.count {
            index = 0
        }

        (red, green, blue) = colors[index]
        
        if index == colors.count - 1 {
            opacity = 1.0
        }
        
        if let button = sender as? UIButton {
            toggleButton(button)
        }
    }
    
    @IBAction func customColorSelected(sender: UIButton) {
        red = customColorRedComponent
        green = customColorGreenComponent
        blue = customColorBlueComponent
        opacity = customColorAlphaComponent
        
        toggleButton(sender)
    }
    
    @IBAction func unwindToDrawingController(segue: UIStoryboardSegue) {
        print("unwound")
        if let settingsViewController = segue.sourceViewController as? SettingsViewController {
            settingsViewControllerFinished(settingsViewController)
        }
    }
    
    @IBAction func share(sender: AnyObject) {
        UIGraphicsBeginImageContext(canvas.bounds.size)
        canvas.image?.drawInRect(CGRect(x: 0, y: 0, width: canvas.frame.size.width, height: canvas.frame.size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // adding a string to the activity items array prevents the icloud sharing option from coming up
        // http://stackoverflow.com/questions/25796125/ios-8-disable-icloud-photo-sharing-activity
        activityController = UIActivityViewController(activityItems: [image, ""], applicationActivities: nil)
        activityController?.excludedActivityTypes = [
            UIActivityTypePrint,
            UIActivityTypePostToWeibo,
            UIActivityTypePostToVimeo,
            UIActivityTypePostToTwitter,
            UIActivityTypePostToTencentWeibo,
            UIActivityTypePostToFlickr,
            UIActivityTypePostToFacebook,
            UIActivityTypeOpenInIBooks,
            UIActivityTypeMessage,
            UIActivityTypeMail,
            UIActivityTypeCopyToPasteboard,
            UIActivityTypeAssignToContact,
            UIActivityTypeAirDrop,
            UIActivityTypeAddToReadingList]
        activityController?.popoverPresentationController?.sourceView = view
        presentViewController(activityController!, animated: true, completion: nil)
    }
    
    
    
    // This method results in more jagged line
    private func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        UIGraphicsBeginImageContext(view.frame.size)
        let context = UIGraphicsGetCurrentContext()
        tempCanvas.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        
        CGContextMoveToPoint(context, fromPoint.x, fromPoint.y)
        CGContextAddLineToPoint(context, toPoint.x, toPoint.y)
        
        CGContextSetLineCap(context, CGLineCap.Round)
        CGContextSetLineWidth(context, brushWidth)
        CGContextSetRGBStrokeColor(context, red, green, blue, 1.0)
        CGContextSetBlendMode(context, CGBlendMode.Normal)
        
        CGContextStrokePath(context)
        
        tempCanvas.image = UIGraphicsGetImageFromCurrentImageContext()
        tempCanvas.alpha = opacity
        UIGraphicsEndImageContext()
    }
    
    // This method results in a smoother line
    private func drawLineTo(point: CGPoint) {
        UIGraphicsBeginImageContext(view.frame.size)
        let context = UIGraphicsGetCurrentContext()
        tempCanvas.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        
        let mid1 = CGPointMake((prevPoint1.x + prevPoint2.x)*0.5, (prevPoint1.y + prevPoint2.y)*0.5)
        let mid2 = CGPointMake((point.x + prevPoint1.x)*0.5, (point.y + prevPoint1.y)*0.5)
        
        CGContextMoveToPoint(context, mid1.x, mid1.y)
        CGContextAddQuadCurveToPoint(context, prevPoint1.x, prevPoint1.y, mid2.x, mid2.y)
        
        CGContextSetLineCap(context, CGLineCap.Round)
        CGContextSetLineWidth(context, brushWidth)
        CGContextSetRGBStrokeColor(context, red, green, blue, 1.0)
        CGContextSetBlendMode(context, CGBlendMode.Normal)
        
        CGContextStrokePath(context)
        
        tempCanvas.image = UIGraphicsGetImageFromCurrentImageContext()
        tempCanvas.alpha = opacity
        UIGraphicsEndImageContext()
    }
    
    private func toggleButton(button: UIButton) {
        resetButtons()
        if button == whiteButton {
            button.setTitle("◎", forState: UIControlState.Normal)
        } else if button == customColorButton {
            button.setTitle("♥︎", forState: UIControlState.Normal)
        } else {
            button.setTitle("◉", forState: UIControlState.Normal)
        }
    }
    
    private func resetButtons() {
        blackButton.setTitle("⚫︎", forState: UIControlState.Normal)
        grayButton.setTitle("⚫︎", forState: UIControlState.Normal)
        redButton.setTitle("⚫︎", forState: UIControlState.Normal)
        blueButton.setTitle("⚫︎", forState: UIControlState.Normal)
        greenButton.setTitle("⚫︎", forState: UIControlState.Normal)
        orangeButton.setTitle("⚫︎", forState: UIControlState.Normal)
        brownButton.setTitle("⚫︎", forState: UIControlState.Normal)
        yellowButton.setTitle("⚫︎", forState: UIControlState.Normal)
        whiteButton.setTitle("⚪︎", forState: UIControlState.Normal)
        customColorButton.setTitle("♡", forState: UIControlState.Normal)
        setCustomColorButton()
    }
    
    private func setCustomColorButton() {
        customColorButton.setTitleColor(UIColor(
            red: customColorRedComponent,
            green: customColorGreenComponent,
            blue: customColorBlueComponent,
            alpha: customColorAlphaComponent),
            forState: .Normal)

    }

}


extension DrawingViewController: SettingsViewControllerDelegate {
    func settingsViewControllerFinished(settingsViewController: SettingsViewController) {
        self.brushWidth = settingsViewController.brush
        self.opacity = settingsViewController.opacity
        self.red = settingsViewController.red
        self.green = settingsViewController.green
        self.blue = settingsViewController.blue

        customColorRedComponent = settingsViewController.red
        customColorGreenComponent = settingsViewController.green
        customColorBlueComponent = settingsViewController.blue
        customColorAlphaComponent = settingsViewController.opacity
        
        setCustomColorButton()
    }
}

extension DrawingViewController: BrushSizeViewControllerDelegate {
    func brushSizeViewControllerFinished(brushSizeViewController: BrushSizeViewController) {
        self.brushWidth = brushSizeViewController.brush
    }
}

