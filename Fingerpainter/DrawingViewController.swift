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
    @IBOutlet weak var customColorButton: UIButton!
    @IBOutlet weak var panelContainer: UIView!
    
    var lastPoint = CGPoint.zero
    var prevPoint1 = CGPoint.zero
    var prevPoint2 = CGPoint.zero
    var brushWidth: CGFloat = 10.0
    var opacity: CGFloat = 1.0
    var swiped = false
    var customColor: CustomColor?
    var color = UIColor.blackColor()
    var canvasObject: Canvas?
    var panel: Panel?
    var panelIsOpen = true {
        didSet {
            setShadowOpacity()
        }
    }
    
    // Prevent touch events being captured if color wheel is open
    var canvasIsActive = true
    
    var activityController: UIActivityViewController?

    let colors = [
        Colors.Red,
        Colors.Orange,
        Colors.Yellow,
        Colors.Green,
        Colors.Blue,
        Colors.Purple,
        Colors.Brown,
        Colors.Black,
        Colors.Gray,
        Colors.White
    ]
    
    struct Colors {
        static let Red = UIColor(red: 1.0, green: 68.0/255.0, blue: 61.0/255.0, alpha: 1.0)
        static let Orange = UIColor(red: 1.0, green: 132.0/255.0, blue: 70.0/255.0, alpha: 1.0)
        static let Yellow = UIColor(red: 1.0, green: 230.0/255.0, blue: 89.0/255.0, alpha: 1.0)
        static let Green = UIColor(red: 149.0/255.0, green: 1.0, blue: 123.0/255.0, alpha: 1.0)
        static let Blue = UIColor(red: 81.0/255.0, green: 172.0/255.0, blue: 1.0, alpha: 1.0)
        static let Purple = UIColor(red: 167.0/255.0, green: 85.0/255.0, blue: 1.0, alpha: 1.0)
        static let Brown = UIColor(red: 128.0/255.0, green: 63.0/255.0, blue: 21.0/255.0, alpha: 1.0)
        static let Black = UIColor.blackColor()
        static let Gray = UIColor(red: 128.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1.0)
        static let White = UIColor.whiteColor()
        
    }
    
    struct Storyboard {
        static let BrushSizeSegueIdentifier = "ShowBrushSize"
        static let OpacitySegueIdentifier = "ShowOpacity"
        static let ColorSegueIdentifier = "ShowColor"
        static let ColorWheelSegueIdentifier = "ShowColorWheel"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load panel
        panel = NSBundle.mainBundle().loadNibNamed("Panel", owner: self, options: nil).first as? Panel
        if let panel = panel {
            
            panelContainer.addSubview(panel)
            
            panel.translatesAutoresizingMaskIntoConstraints = false

            // Pin to the leading, trailing, and bottom anchors of panelContainer
            panel.leadingAnchor.constraintEqualToAnchor(panelContainer.leadingAnchor).active = true
            panel.trailingAnchor.constraintEqualToAnchor(panelContainer.trailingAnchor).active = true
            panel.bottomAnchor.constraintEqualToAnchor(panelContainer.bottomAnchor).active = true
            
            setShadowOpacity()
        }
        
        loadCustomColor()
        setCustomColorButton()
        loadCanvasObject()
        
        // Set selected color button
        toggleButton(panel!.blackButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if panelIsOpen == true {
            // Show panel
            panelContainer.frame = CGRect(
                x: 0.0,
                y: view.bounds.height - panelContainer.frame.size.height,
                width: panelContainer.frame.size.width,
                height: panelContainer.frame.size.height)
        } else {
            // Hide panel
            panelContainer.frame = CGRect(
                x: 0.0,
                y: view.bounds.height,
                width: panelContainer.frame.size.width,
                height: panelContainer.frame.size.height)
        }
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
        if segue.identifier == Storyboard.ColorWheelSegueIdentifier {
            if let navigationController = segue.destinationViewController as? UINavigationController,
                colorWheelViewController = navigationController.topViewController as? ColorWheelViewController {
                
                colorWheelViewController.delegate = self
            }
        }
    }
    
    
    // MARK: - UIPopoverPresentationControllerDelegate
    
    func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController) {
        if let colorWheelViewController = popoverPresentationController.presentedViewController as? ColorWheelViewController {
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
    
    // This is the clear button in the panel, not the toolbar
    @IBAction func clearCanvas(sender: UIButton) {
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
        // Change icon
        panel?.setSelectedPanelIcon(sender)
        
        UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseOut, animations: { [weak self] in
            // Fade out other panels
            self?.panel?.colorsView.alpha = 0.0
            self?.panel?.opacityView.alpha = 0.0
            }) { [weak self] (finished) in
                // Fade in the brushes
                UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseIn, animations: { [weak self] in
                    self?.panel?.brushesView.alpha = 1.0
                    }, completion: nil)
        }
    }
    
    @IBAction func showColors(sender: UIButton) {
        // Change icon
        panel?.setSelectedPanelIcon(sender)
        
        UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseOut, animations: { [weak self] in
            self?.panel?.brushesView.alpha = 0.0
            self?.panel?.opacityView.alpha = 0.0
        }) { (finished) in
            // fade in the brushes
            UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseIn, animations: { [weak self] in
                self?.panel?.colorsView.alpha = 1.0
                }, completion: nil)
        }
    }
    
    @IBAction func showOpacity(sender: UIButton) {
        // Change icon
        panel?.setSelectedPanelIcon(sender)
        
        UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseOut, animations: { [weak self] in
            self?.panel?.colorsView.alpha = 0.0
            self?.panel?.brushesView.alpha = 0.0
        }) { (finished) in
            // fade in the brushes
            UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseIn, animations: { [weak self] in
                self?.panel?.opacityView.alpha = 1.0
                }, completion: nil)
        }
    }
    
    
    @IBAction func changeBrushSize(sender: UIButton) {
        if let identifier = sender.accessibilityIdentifier {
            switch identifier {
            case "1":
                brushWidth = 1.0
            case "2":
                brushWidth = 10.0
            case "3":
                brushWidth = 30.0
            case "4":
                brushWidth = 60.0
            case "5":
                brushWidth = 90.0
            default:
                brushWidth = 10.0
            }
        }
    }
    
    @IBAction func changeOpacity(sender: UIButton) {
        if let identifier = sender.accessibilityIdentifier {
            switch identifier {
            case "1":
                opacity = 0.1
            case "2":
                opacity = 0.5
            case "3":
                opacity = 1.0
            default:
                opacity = 1.0
            }
        }
    }
    
    @IBAction func hidePanel(sender: AnyObject) {
        UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseInOut, animations: { [weak self] in
            if self != nil {
                self!.panelContainer.frame = CGRect(
                    x: 0.0,
                    y: self!.view.bounds.height,
                    width: self!.panelContainer.frame.size.width,
                    height: self!.panelContainer.frame.size.height)
            }
            
            }) { [weak self] (completed) in
                if self != nil {
                    self!.panelIsOpen = false
                }
            }
    }
    
    @IBAction func showPanel(sender: UIButton) {
        UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseInOut, animations: { [weak self] in
            if self != nil {
                self!.panelContainer.frame = CGRect(
                    x: 0.0,
                    y: self!.view.bounds.height - self!.panelContainer.frame.size.height,
                    width: self!.panelContainer.frame.size.width,
                    height: self!.panelContainer.frame.size.height)
            }
            
        }) { [weak self] (completed) in
            if self != nil {
                self!.panelIsOpen = true 
            }
        }
    }
    
    @IBAction func showColorWheel(sender: UIButton) {
        performSegueWithIdentifier(Storyboard.ColorWheelSegueIdentifier, sender: sender)
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
        if button == customColorButton {
            button.setTitle("♥︎", forState: UIControlState.Normal)
        } else {
            button.setTitle("◉", forState: UIControlState.Normal)
        }
    }
    
    private func resetButtons() {
        panel!.blackButton.setTitle("⚫︎", forState: UIControlState.Normal)
        panel!.grayButton.setTitle("⚫︎", forState: UIControlState.Normal)
        panel!.redButton.setTitle("⚫︎", forState: UIControlState.Normal)
        panel!.blueButton.setTitle("⚫︎", forState: UIControlState.Normal)
        panel!.greenButton.setTitle("⚫︎", forState: UIControlState.Normal)
        panel!.orangeButton.setTitle("⚫︎", forState: UIControlState.Normal)
        panel!.brownButton.setTitle("⚫︎", forState: UIControlState.Normal)
        panel!.yellowButton.setTitle("⚫︎", forState: UIControlState.Normal)
        panel!.whiteButton.setTitle("⚫︎", forState: UIControlState.Normal)
        panel!.purpleButton.setTitle("⚫︎", forState: UIControlState.Normal)
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
    
    private func setShadowOpacity() {
        if panelIsOpen {
            panel?.layer.shadowOpacity = 0.8
        } else {
            panel?.layer.shadowOpacity = 0.0
        }
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

