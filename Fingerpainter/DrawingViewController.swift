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
    
    @IBOutlet weak var panelButtonsView: UIView!
    @IBOutlet weak var colorsView: UIView!
    @IBOutlet weak var brushesView: UIView!
    @IBOutlet weak var opacityView: UIView!

    @IBOutlet weak var brushButton1: UIButton!
    @IBOutlet weak var brushButton2: UIButton!
    @IBOutlet weak var brushButton3: UIButton!
    
    var lastPoint = CGPoint.zero
    var prevPoint1 = CGPoint.zero
    var prevPoint2 = CGPoint.zero
    var brushWidth: CGFloat = 10.0
    var opacity: CGFloat = 1.0
    var swiped = false
    var customColor: CustomColor?
    var color = UIColor.blackColor()
    var canvasObject: Canvas?
    
    // Prevent touch events being captured if color wheel is open
    var canvasIsActive = true
    
    var activityController: UIActivityViewController?

    let colors = [
        UIColor.blackColor(),
        UIColor.lightGrayColor(),
        UIColor.redColor(),
        UIColor(red: 0, green: CGFloat(128.0/255.0), blue: CGFloat(1.0), alpha: 1.0), // Blue
        UIColor(red: 0, green: CGFloat(128.0/255.0), blue: 0, alpha: 1.0), // Green
        UIColor(red: CGFloat(1.0), green: CGFloat(128.0/255.0), blue: 0, alpha: 1.0), // Orange
        UIColor(red: CGFloat(128.0/255.0), green: CGFloat(64.0/255.0), blue: 0, alpha: 1.0), // Brown
        UIColor(red: CGFloat(1.0), green: CGFloat(1.0), blue: CGFloat(102.0/255.0), alpha: 1.0), // Yellow
        UIColor(red: CGFloat(1.0), green: CGFloat(1.0), blue: CGFloat(1.0), alpha: 1.0) // White
    ]
    
    struct Storyboard {
        static let BrushSizeSegueIdentifier = "ShowBrushSize"
        static let OpacitySegueIdentifier = "ShowOpacity"
        static let ColorSegueIdentifier = "ShowColor"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCustomColor()
        setCustomColorButton()
        loadCanvasObject()
        
        // Set selected color button
        toggleButton(blackButton)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Don't want to capture touch events on canvas if color wheel is open
        if canvasIsActive {
            swiped = false
            let touch = touches.first! as UITouch
            prevPoint1 = touch.previousLocationInView(canvas)
            prevPoint2 = touch.previousLocationInView(canvas)
            lastPoint = touch.locationInView(canvas)

        }
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if canvasIsActive {
            swiped = true
            let touch = touches.first! as UITouch
            let currentPoint = touch.locationInView(canvas)
            
            prevPoint2 = prevPoint1
            prevPoint1 = touch.previousLocationInView(canvas)
            
            drawLineTo(currentPoint)
            
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if canvasIsActive {
            if !swiped {
                // draw a single point
                drawLineFrom(lastPoint, toPoint: lastPoint)
            }
            
            // Merge tempCanvas into canvas
            UIGraphicsBeginImageContext(canvas.frame.size)
            canvas.image?.drawInRect(CGRect(x: 0, y: 0, width: canvas.frame.size.width, height: canvas.frame.size.height), blendMode: CGBlendMode.Normal, alpha: 1.0)
            tempCanvas.image?.drawInRect(CGRect(x: 0, y: 0, width: tempCanvas.frame.size.width, height: tempCanvas.frame.size.height), blendMode: CGBlendMode.Normal, alpha: opacity)
            // Tried to keep it from getting distorted when device orientation changed but can't get it right
            //canvas.contentMode = .ScaleAspectFit
            canvas.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            tempCanvas.image = nil
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let identifier = segue.identifier ?? ""
        let popoverPresentationController = segue.destinationViewController.popoverPresentationController
        popoverPresentationController!.delegate = self
        
        // Hack to prevent other buttons on toolbar from being tapped while a popover is open
        //  http://stackoverflow.com/questions/34010692/warning-attempt-to-present-viewcontroller-on-viewcontroller-which-is-already-pr
        delay(0.1) {
            popoverPresentationController?.passthroughViews = nil
        }
        
        switch identifier {
        case Storyboard.BrushSizeSegueIdentifier:
            if let brushSizeViewController = popoverPresentationController?.presentedViewController as? BrushSizeViewController {
                brushSizeViewController.brush = brushWidth
                brushSizeViewController.opacity = opacity
                brushSizeViewController.color = color
            }
        case Storyboard.OpacitySegueIdentifier:
            if let opacityViewController = popoverPresentationController?.presentedViewController as? OpacityViewController {
                opacityViewController.opacity = opacity
                opacityViewController.color = color
            }
        case Storyboard.ColorSegueIdentifier:
            if let colorWheelViewController = popoverPresentationController?.presentedViewController as? ColorWheelViewController {
                // Prevent touch events from being captured on canvas while choosing color
                canvasIsActive = false
                colorWheelViewController.selectedColor = customColor?.color
            }
        default:
            break
        }
    }
    
    
    // MARK: - UIPopoverPresentationControllerDelegate
    
    func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController) {
        if let brushSizeViewController = popoverPresentationController.presentedViewController as? BrushSizeViewController {
            brushSizeViewControllerFinished(brushSizeViewController)
        } else if let opacityViewController = popoverPresentationController.presentedViewController as? OpacityViewController {
            opacityViewControllerFinished(opacityViewController)
        } else if let colorWheelViewController = popoverPresentationController.presentedViewController as? ColorWheelViewController {
            canvasIsActive = true
            if colorWheelViewController.didSelectNewColor {
                toggleButton(customColorButton)
                colorWheelViewControllerFinished(colorWheelViewController)
            }
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    
    // MARK: - Actions
    
    @IBAction func clearImage(sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Clear Canvas", message: "Are you sure you want to clear the canvas?", preferredStyle: .Alert)
        let clearAction = UIAlertAction(title: "Clear", style: .Destructive) { (alert: UIAlertAction!) -> Void in
            self.canvas.image = nil
            self.tempCanvas.image = nil 
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (alert: UIAlertAction!) -> Void in
            //print("You pressed Cancel")
        }
        
        alert.addAction(clearAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert, animated: true, completion:nil)
    }
    
    @IBAction func colorChanged(sender: AnyObject) {
        var index = sender.tag ?? 0
        
        // No color chosen: black
        if index < 0 || index >= colors.count {
            index = 0
        }

        color = colors[index]
        
        if let button = sender as? UIButton {
            toggleButton(button)
        }
    }
    
    @IBAction func customColorSelected(sender: UIButton) {
        if let customColor = customColor {
            color = customColor.color
        }
        
        toggleButton(sender)
    }
    
    @IBAction func save(sender: AnyObject) {
        let image = saveCanvasAsImage()
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(DrawingViewController.image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        
        if let error = error {
            print(error.domain)
            alert.title = "Error"
            alert.message = "Unable to save image. Please check permissions for this app in Settings."
        } else {
            alert.title = "Saved"
            alert.message = "Image was saved to Photos"
        }
        
        alert.addAction(defaultAction)
        presentViewController(alert, animated: true, completion:nil)
    }
    
    func saveCanvas() {
        let image = saveCanvasAsImage()
        if let co = Canvas(image: image) {
            NSKeyedArchiver.archiveRootObject(co, toFile: Canvas.ArchiveURL.path!)
        } else {
            print("Failed to save canvas...")
        }
    }
    
    @IBAction func showBrushes(sender: UIButton) {
        UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseOut, animations: { [weak self] in
            self?.colorsView.alpha = 0.0
            self?.opacityView.alpha = 0.0
            }) { (finished) in
                // fade in the brushes
                UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseIn, animations: {
                    self.brushesView.alpha = 1.0
                    }, completion: nil)
        }
    }
    
    @IBAction func showColors(sender: UIButton) {
        UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseOut, animations: { [weak self] in
            self?.brushesView.alpha = 0.0
            self?.opacityView.alpha = 0.0
        }) { (finished) in
            // fade in the brushes
            UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseIn, animations: {
                self.colorsView.alpha = 1.0
                }, completion: nil)
        }
    }
    
    @IBAction func showOpacity(sender: UIButton) {
        UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseOut, animations: { [weak self] in
            self?.colorsView.alpha = 0.0
            self?.brushesView.alpha = 0.0
        }) { (finished) in
            // fade in the brushes
            UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseIn, animations: {
                self.opacityView.alpha = 1.0
                }, completion: nil)
        }
    }
    
    
    @IBAction func changeBrushSize1(sender: UIButton) {
        brushWidth = 1.0
    }
    
    @IBAction func changeBrushSize2(sender: UIButton) {
        brushWidth = 10.0
    }
    
    @IBAction func changeBrushSize3(sender: UIButton) {
        brushWidth = 80.0
    }
    
    @IBAction func changeOpacity1(sender: UIButton) {
        opacity = 0.1
    }
    
    @IBAction func changeOpacity2(sender: UIButton) {
        opacity = 0.5
    }
    
    @IBAction func changeOpacity3(sender: UIButton) {
        opacity = 1.0
    }
    
    
    // MARK: - Private Methods
    
    // This method results in more jagged line
    // Used for single point
    private func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        UIGraphicsBeginImageContext(canvas.frame.size)
        let context = UIGraphicsGetCurrentContext()
        tempCanvas.image?.drawInRect(CGRect(x: 0, y: 0, width: canvas.frame.size.width, height: canvas.frame.size.height))
        
        CGContextMoveToPoint(context, fromPoint.x, fromPoint.y)
        CGContextAddLineToPoint(context, toPoint.x, toPoint.y)
        
        CGContextSetLineCap(context, CGLineCap.Round)
        CGContextSetLineWidth(context, brushWidth)
        CGContextSetStrokeColorWithColor(context, color.CGColor)
        CGContextSetBlendMode(context, CGBlendMode.Normal)
        
        CGContextStrokePath(context)
        
        tempCanvas.image = UIGraphicsGetImageFromCurrentImageContext()
        tempCanvas.alpha = opacity
        UIGraphicsEndImageContext()
    }
    
    // This method results in a smoother line
    private func drawLineTo(point: CGPoint) {
        UIGraphicsBeginImageContext(canvas.frame.size)
        let context = UIGraphicsGetCurrentContext()
        tempCanvas.image?.drawInRect(CGRect(x: 0, y: 0, width: canvas.frame.size.width, height: canvas.frame.size.height))
        
        let mid1 = CGPointMake((prevPoint1.x + prevPoint2.x)*0.5, (prevPoint1.y + prevPoint2.y)*0.5)
        let mid2 = CGPointMake((point.x + prevPoint1.x)*0.5, (point.y + prevPoint1.y)*0.5)
        
        CGContextMoveToPoint(context, mid1.x, mid1.y)
        CGContextAddQuadCurveToPoint(context, prevPoint1.x, prevPoint1.y, mid2.x, mid2.y)
        
        CGContextSetLineCap(context, CGLineCap.Round)
        CGContextSetLineWidth(context, brushWidth)
        CGContextSetStrokeColorWithColor(context, color.CGColor)
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
        if let customColor = customColor {
            customColorButton.setTitleColor(customColor.color, forState: .Normal)
        }
    }
    
    private func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    private func loadCustomColor() {
        if let cc = NSKeyedUnarchiver.unarchiveObjectWithFile(CustomColor.ArchiveURL.path!) as? CustomColor {
            customColor = cc
        } else {
            customColor = CustomColor(color: color)
        }
    }
    
    private func loadCanvasObject() {
        if let savedCanvas = NSKeyedUnarchiver.unarchiveObjectWithFile(Canvas.ArchiveURL.path!) as? Canvas {
            canvas.image = savedCanvas.image
            tempCanvas.image = savedCanvas.image
        }
    }
    
    private func saveCanvasAsImage() -> UIImage {
        UIGraphicsBeginImageContext(canvas.bounds.size)
        canvas.image?.drawInRect(CGRect(x: 0, y: 0, width: canvas.frame.size.width, height: canvas.frame.size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }

}


extension DrawingViewController: BrushSizeViewControllerDelegate {
    func brushSizeViewControllerFinished(brushSizeViewController: BrushSizeViewController) {
        self.brushWidth = brushSizeViewController.brush
    }
}

extension DrawingViewController: OpacityViewControllerDelegate {
    func opacityViewControllerFinished(opacityViewController: OpacityViewController) {
        self.opacity = opacityViewController.opacity
    }
}

extension DrawingViewController: ColorWheelViewControllerDelegate {
    func colorWheelViewControllerFinished(colorWheelViewController: ColorWheelViewController) {
        if let selectedColor = colorWheelViewController.selectedColor {
            color = selectedColor
            
            if let customColor = customColor {
                customColor.color = selectedColor
            } else {
                customColor = CustomColor(color: selectedColor)
            }
            
            // Save custom color
            let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(customColor!, toFile: CustomColor.ArchiveURL.path!)
            if !isSuccessfulSave {
                print("Failed to save custom color...")
            }
            
            setCustomColorButton()
        }
    }
}

