//
//  DrawingViewController.swift
//  Fingerpainter
//
//  Created by Morgan Davison on 11/23/15.
//  Copyright © 2015 Morgan Davison. All rights reserved.
//

import UIKit

class DrawingViewController: UIViewController {
    
    @IBOutlet weak var canvas: UIImageView!
    @IBOutlet weak var tempCanvas: UIImageView!
    @IBOutlet weak var panelContainer: UIView!
    
    var lastPoint = CGPoint.zero
    var prevPoint1 = CGPoint.zero
    var prevPoint2 = CGPoint.zero
    var brushWidth: CGFloat = 10.0
    var opacity: CGFloat = 1.0
    var swiped = false
    var customColor: CustomColor?
    var color = UIColor.black
    var canvasObject: Canvas?
    var panel: Panel?
    var panelIsOpen = true {
        didSet {
            setPanelShadowOpacity()
        }
    }
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
    
    struct Storyboard {
        static let BrushSizeSegueIdentifier = "ShowBrushSize"
        static let OpacitySegueIdentifier = "ShowOpacity"
        static let ColorSegueIdentifier = "ShowColor"
        static let ColorWheelSegueIdentifier = "ShowColorWheel"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load panel
//        panel = NSBundle.mainBundle().loadNibNamed("Panel", owner: self, options: nil).first as? Panel
//        if let panel = panel {
//
//            panelContainer.addSubview(panel)
//
//            panel.translatesAutoresizingMaskIntoConstraints = false
//
//            // Pin to the leading, trailing, and bottom anchors of panelContainer
//            panel.leadingAnchor.constraintEqualToAnchor(panelContainer.leadingAnchor).active = true
//            panel.trailingAnchor.constraintEqualToAnchor(panelContainer.trailingAnchor).active = true
//            panel.bottomAnchor.constraintEqualToAnchor(panelContainer.bottomAnchor).active = true
//
//            setPanelShadowOpacity()
//
//            panel.setSelectedBrushIcon(panel.brushButton3)
//            panel.setSelectedOpacityIcon(panel.opacityButton3)
//        }
        panel = Bundle.main.loadNibNamed("Panel", owner: self, options: nil)?.first as? Panel
        
        if let panel = panel {
            panelContainer.addSubview(panel)
            
            panel.translatesAutoresizingMaskIntoConstraints = false
            
            // Pin to the leading, trailing, and bottom anchors of panelContainer
            panel.leadingAnchor.constraint(equalTo: panelContainer.leadingAnchor).isActive = true
            panel.trailingAnchor.constraint(equalTo: panelContainer.trailingAnchor).isActive = true
            panel.bottomAnchor.constraint(equalTo: panelContainer.bottomAnchor).isActive = true
            
            setPanelShadowOpacity()
            
            panel.setSelectedBrushIcon(selectedButton: panel.brushButton3)
        }
        
        loadCustomColor()
        setCustomColorButton()
        loadCanvasObject()
        
        // Set selected color button
        //toggleButton(panel!.blackButton)
        toggleButton(button: panel!.blackButton)
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
        
        print("Received memory warning!")
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: nil, completion: { [weak self] (_) in
            self?.viewDidLayoutSubviews()
        })
    }
    
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        swiped = false
//        let touch = touches.first! as UITouch
//        prevPoint1 = touch.previousLocationInView(canvas)
//        prevPoint2 = touch.previousLocationInView(canvas)
//        lastPoint = touch.locationInView(canvas)
//    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = false;
        let touch = touches.first! as UITouch
        prevPoint1 = touch.previousLocation(in: canvas)
        prevPoint2 = touch.previousLocation(in: canvas)
        lastPoint = touch.location(in: canvas)
    }
    
//    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        swiped = true
//        let touch = touches.first! as UITouch
//        let currentPoint = touch.locationInView(canvas)
//
//        prevPoint2 = prevPoint1
//        prevPoint1 = touch.previousLocationInView(canvas)
//
//        drawLineTo(currentPoint)
//
//        lastPoint = currentPoint
//    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = true;
        let touch = touches.first! as UITouch
        let currentPoint = touch.location(in: canvas)
        
        prevPoint2 = prevPoint1
        prevPoint1 = touch.previousLocation(in: canvas)
        
        drawLineTo(point: currentPoint)
        
        lastPoint = currentPoint
    }
    
//    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        if !swiped {
//            // draw a single point
//            drawLineFrom(lastPoint, toPoint: lastPoint)
//        }
//
//        // Merge tempCanvas into canvas
//        UIGraphicsBeginImageContext(canvas.frame.size)
//        canvas.image?.drawInRect(CGRect(x: 0, y: 0, width: canvas.frame.size.width, height: canvas.frame.size.height), blendMode: CGBlendMode.Normal, alpha: 1.0)
//        tempCanvas.image?.drawInRect(CGRect(x: 0, y: 0, width: tempCanvas.frame.size.width, height: tempCanvas.frame.size.height), blendMode: CGBlendMode.Normal, alpha: opacity)
//        // Tried to keep it from getting distorted when device orientation changed but can't get it right
//        //canvas.contentMode = .ScaleAspectFit
//        canvas.image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//
//        tempCanvas.image = nil
//    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !swiped {
            // draw a single point
            drawLineFrom(fromPoint: lastPoint, toPoint: lastPoint)
        }
        
        // Merge tempCanvas into canvas
        UIGraphicsBeginImageContext(canvas.frame.size)
        canvas.image?.draw(in: CGRect(x: 0, y: 0, width: canvas.frame.size.width, height: canvas.frame.size.height), blendMode: CGBlendMode.normal, alpha: 1.0)
        tempCanvas.image?.draw(in: CGRect(x: 0, y: 0, width: tempCanvas.frame.size.width, height: tempCanvas.frame.size.height), blendMode: CGBlendMode.normal, alpha: opacity)
        
        canvas.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        tempCanvas.image = nil
    }
    
    
    // MARK: - Navigation
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == Storyboard.ColorWheelSegueIdentifier {
//            if let navigationController = segue.destinationViewController as? UINavigationController,
//                colorWheelViewController = navigationController.topViewController as? ColorWheelViewController {
//
//                colorWheelViewController.delegate = self
//                colorWheelViewController.selectedColor = customColor?.color
//            }
//        }
//    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.ColorWheelSegueIdentifier {
            if let navigationController = segue.destination as? UINavigationController, let colorWheelViewController = navigationController.topViewController as? ColorWheelViewController {
                colorWheelViewController.delegate = self
                colorWheelViewController.selectedColor = customColor?.color
            }
        }
    }
    

    
    // MARK: - Actions
    
    @IBAction func clearCanvas(_ sender: UIButton) {
//        let alert = UIAlertController(title: "Clear Canvas", message: "Are you sure you want to clear the canvas?", preferredStyle: .Alert)
//        let clearAction = UIAlertAction(title: "Clear", style: .Destructive) { (alert: UIAlertAction!) -> Void in
//            self.canvas.image = nil
//            self.tempCanvas.image = nil
//        }
//        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (alert: UIAlertAction!) -> Void in
//            //print("You pressed Cancel")
//        }
//
//        alert.addAction(clearAction)
//        alert.addAction(cancelAction)
//
//        presentViewController(alert, animated: true, completion:nil)
        
        let alert = UIAlertController(title: "Clear Canvas", message: "Are you sure you want to clear the canvas?", preferredStyle: .alert)
        let clearAction = UIAlertAction(title: "Clear", style: .destructive) { (alert: UIAlertAction) -> Void in
            self.canvas.image = nil
            self.tempCanvas.image = nil
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (alert: UIAlertAction!) -> Void in
            //print("you pressed Cancel")
        }
        
        alert.addAction(clearAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func colorChanged(_ sender: UIButton) {
//        var index = sender.tag ?? 0
//
//        // No color chosen: black
//        if index < 0 || index >= colors.count {
//            index = 0
//        }
//
//        color = colors[index]
//
//        if let button = sender as? UIButton {
//            toggleButton(button)
//        }
        
        var index = sender.tag
        
        // No color chosen: black
        if index < 0 || index >= colors.count {
            index = 0
        }
        
        color = colors[index]
        
        toggleButton(button: sender)
        
    }
    
    @IBAction func customColorSelected(_ sender: UIButton) {
        if let customColor = customColor {
            color = customColor.color
        }
        
        toggleButton(button: sender)
    }
    
    @IBAction func save(_ sender: UIButton) {
//        let image = saveCanvasAsImage()
//
//        UIImageWriteToSavedPhotosAlbum(image, self, #selector(DrawingViewController.image(_:didFinishSavingWithError:contextInfo:)), nil)
        
        if let image = saveCanvasAsImage() {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(DrawingViewController.image(image:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    
//    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
//        let alert = UIAlertController(title: "", message: "", preferredStyle: .Alert)
//        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
//
//        if let error = error {
//            print(error.domain)
//            alert.title = "Error"
//            alert.message = "Unable to save image. Please check permissions for this app in Settings."
//        } else {
//            alert.title = "Saved"
//            alert.message = "Image was saved to Photos"
//        }
//
//        alert.addAction(defaultAction)
//        presentViewController(alert, animated: true, completion:nil)
//    }
    @objc func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafeRawPointer) {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        if let error = error {
            print(error.domain)
            alert.title = "Error"
            alert.message = "Unable to save image. Please check permissions for this app in Settings."
        } else {
            alert.title = "Saved"
            alert.message = "Image was saved to Photos"
        }
        
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    
//    func saveCanvas() {
//        let image = saveCanvasAsImage()
//        if let co = Canvas(image: image) {
//            NSKeyedArchiver.archiveRootObject(co, toFile: Canvas.ArchiveURL.path!)
//        } else {
//            print("Failed to save canvas...")
//        }
//    }
    func saveCanvas() {
        if let image = saveCanvasAsImage(), let co = Canvas(image: image) {
            NSKeyedArchiver.archiveRootObject(co, toFile: Canvas.ArchiveURL.path)
        } else {
            print("Failed to save canvas")
        }
    }
    
    @IBAction func showBrushes(_ sender: UIButton) {
//        // Change icon
//        panel?.setSelectedPanelIcon(sender)
//
//        UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseOut, animations: { [weak self] in
//            // Fade out other panels
//            self?.panel?.colorsView.alpha = 0.0
//            self?.panel?.opacityView.alpha = 0.0
//            }) { [weak self] (finished) in
//                // Fade in the brushes
//                UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseIn, animations: { [weak self] in
//                    self?.panel?.brushesView.alpha = 1.0
//                    }, completion: nil)
//        }
        
        // Change icon
        panel?.setSelectedPanelIcon(selectedButton: sender)
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: { [weak self] in
            // Fade out other panels
            self?.panel?.colorsView.alpha = 0.0
            self?.panel?.opacityView.alpha = 0.0
        }) { [weak self] (finished) in
            // Fade in the brushes
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: { [weak self] in
                self?.panel?.brushesView.alpha = 1.0
                }, completion: nil)
        }
    }
    
    @IBAction func showColors(_ sender: UIButton) {
//        // Change icon
//        panel?.setSelectedPanelIcon(sender)
//
//        UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseOut, animations: { [weak self] in
//            self?.panel?.brushesView.alpha = 0.0
//            self?.panel?.opacityView.alpha = 0.0
//        }) { (finished) in
//            // fade in the brushes
//            UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseIn, animations: { [weak self] in
//                self?.panel?.colorsView.alpha = 1.0
//                }, completion: nil)
//        }
        
        // Change icon
        panel?.setSelectedPanelIcon(selectedButton: sender)
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: { [weak self] in
            self?.panel?.brushesView.alpha = 0.0
            self?.panel?.opacityView.alpha = 0.0
        }) { (finished) in
            // fade in the brushes
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: { [weak self] in
                self?.panel?.colorsView.alpha = 1.0
                }, completion: nil)
        }
    }
    
    @IBAction func showOpacity(_ sender: UIButton) {
//        // Change icon
//        panel?.setSelectedPanelIcon(sender)
//
//        UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseOut, animations: { [weak self] in
//            self?.panel?.colorsView.alpha = 0.0
//            self?.panel?.brushesView.alpha = 0.0
//        }) { (finished) in
//            // fade in the brushes
//            UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseIn, animations: { [weak self] in
//                self?.panel?.opacityView.alpha = 1.0
//                }, completion: nil)
//        }
        
        // Change icon
        panel?.setSelectedPanelIcon(selectedButton: sender)
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: { [weak self] in
            self?.panel?.colorsView.alpha = 0.0
            self?.panel?.brushesView.alpha = 0.0
        }) { (finished) in
            // fade in the brushes
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: { [weak self] in
                self?.panel?.opacityView.alpha = 1.0
                }, completion: nil)
        }
    }
    
    
    @IBAction func changeBrushSize(_ sender: UIButton) {
        if let identifier = sender.accessibilityIdentifier {
            panel?.setSelectedBrushIcon(selectedButton: sender)
            
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
            panel?.setSelectedOpacityIcon(selectedButton: sender)
            
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
    
    @IBAction func hidePanel(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: { [weak self] in
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
    
    @IBAction func showPanel(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: { [weak self] in
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
    
    @IBAction func showColorWheel(_ sender: UIButton) {
        performSegue(withIdentifier: Storyboard.ColorWheelSegueIdentifier, sender: sender)
    }
    
    
    
    // MARK: - Private Methods
    
    // This method results in more jagged line
    // Used for single point
//    private func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
//        UIGraphicsBeginImageContext(canvas.frame.size)
//        let context = UIGraphicsGetCurrentContext()
//        tempCanvas.image?.drawInRect(CGRect(x: 0, y: 0, width: canvas.frame.size.width, height: canvas.frame.size.height))
//
//        CGContextMoveToPoint(context, fromPoint.x, fromPoint.y)
//        CGContextAddLineToPoint(context, toPoint.x, toPoint.y)
//
//        CGContextSetLineCap(context, CGLineCap.Round)
//        CGContextSetLineWidth(context, brushWidth)
//        CGContextSetStrokeColorWithColor(context, color.CGColor)
//        CGContextSetBlendMode(context, CGBlendMode.Normal)
//
//        CGContextStrokePath(context)
//
//        tempCanvas.image = UIGraphicsGetImageFromCurrentImageContext()
//        tempCanvas.alpha = opacity
//        UIGraphicsEndImageContext()
//    }
    private func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        UIGraphicsBeginImageContext(canvas.frame.size)
        let context = UIGraphicsGetCurrentContext()
        tempCanvas.image?.draw(in: CGRect(x: 0, y: 0, width: canvas.frame.size.width, height: canvas.frame.size.height))
        
        context?.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
        context?.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))
        
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(brushWidth)
        context?.setStrokeColor(color.cgColor)
        context?.setBlendMode(CGBlendMode.normal)
        
        context?.strokePath()
        
        tempCanvas.image = UIGraphicsGetImageFromCurrentImageContext()
        tempCanvas.alpha = opacity
        UIGraphicsEndImageContext()
    }
    
    // This method results in a smoother line
//    private func drawLineTo(point: CGPoint) {
//        UIGraphicsBeginImageContext(canvas.frame.size)
//        let context = UIGraphicsGetCurrentContext()
//        tempCanvas.image?.drawInRect(CGRect(x: 0, y: 0, width: canvas.frame.size.width, height: canvas.frame.size.height))
//
//        let mid1 = CGPointMake((prevPoint1.x + prevPoint2.x)*0.5, (prevPoint1.y + prevPoint2.y)*0.5)
//        let mid2 = CGPointMake((point.x + prevPoint1.x)*0.5, (point.y + prevPoint1.y)*0.5)
//
//        CGContextMoveToPoint(context, mid1.x, mid1.y)
//        CGContextAddQuadCurveToPoint(context, prevPoint1.x, prevPoint1.y, mid2.x, mid2.y)
//
//        CGContextSetLineCap(context, CGLineCap.Round)
//        CGContextSetLineWidth(context, brushWidth)
//        CGContextSetStrokeColorWithColor(context, color.CGColor)
//        CGContextSetBlendMode(context, CGBlendMode.Normal)
//
//        CGContextStrokePath(context)
//
//        tempCanvas.image = UIGraphicsGetImageFromCurrentImageContext()
//        tempCanvas.alpha = opacity
//        UIGraphicsEndImageContext()
//    }
    private func drawLineTo(point: CGPoint) {
        UIGraphicsBeginImageContext(canvas.frame.size)
        let context = UIGraphicsGetCurrentContext()
        tempCanvas.image?.draw(in: CGRect(x: 0, y: 0, width: canvas.frame.size.width, height: canvas.frame.size.height))
        
        let mid1 = CGPoint(x: (prevPoint1.x + prevPoint2.x)*0.5, y: (prevPoint1.y + prevPoint2.y)*0.5)
        let mid2 = CGPoint(x: (point.x + prevPoint1.x)*0.5, y: (point.y + prevPoint1.y)*0.5)
        
        context?.move(to: CGPoint(x: mid1.x, y: mid1.y))
        context?.addQuadCurve(to: CGPoint(x: prevPoint1.x, y: prevPoint1.y), control: CGPoint(x: mid2.x, y: mid2.y))
        
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(brushWidth)
        context?.setStrokeColor(color.cgColor)
        context?.setBlendMode(CGBlendMode.normal)
        
        context?.strokePath()
        
        tempCanvas.image = UIGraphicsGetImageFromCurrentImageContext()
        tempCanvas.alpha = opacity
        UIGraphicsEndImageContext()
    }
    
//    private func toggleButton(button: UIButton) {
//        resetButtons()
//        if button == panel!.customColorButton {
//            panel!.customColorButton.setTitle("★", forState: UIControlState.Normal)
//        } else {
//            button.setTitle("◉", forState: UIControlState.Normal)
//        }
//    }
    private func toggleButton(button: UIButton) {
        resetButtons()
        if button == panel!.customColorButton {
            panel!.customColorButton.setTitle("★", for: UIControlState.normal)
        } else {
            button.setTitle("◉", for: UIControlState.normal)
        }
    }
    
//    private func resetButtons() {
//        panel!.blackButton.setTitle("⚫︎", forState: UIControlState.Normal)
//        panel!.grayButton.setTitle("⚫︎", forState: UIControlState.Normal)
//        panel!.redButton.setTitle("⚫︎", forState: UIControlState.Normal)
//        panel!.blueButton.setTitle("⚫︎", forState: UIControlState.Normal)
//        panel!.greenButton.setTitle("⚫︎", forState: UIControlState.Normal)
//        panel!.orangeButton.setTitle("⚫︎", forState: UIControlState.Normal)
//        panel!.brownButton.setTitle("⚫︎", forState: UIControlState.Normal)
//        panel!.yellowButton.setTitle("⚫︎", forState: UIControlState.Normal)
//        panel!.whiteButton.setTitle("⚫︎", forState: UIControlState.Normal)
//        panel!.purpleButton.setTitle("⚫︎", forState: UIControlState.Normal)
//        panel!.customColorButton.setTitle("☆", forState: UIControlState.Normal)
//        setCustomColorButton()
//    }
    private func resetButtons() {
        panel!.blackButton.setTitle("⚫︎", for: UIControlState.normal)
        panel!.grayButton.setTitle("⚫︎", for: UIControlState.normal)
        panel!.redButton.setTitle("⚫︎", for: UIControlState.normal)
        panel!.blueButton.setTitle("⚫︎", for: UIControlState.normal)
        panel!.greenButton.setTitle("⚫︎", for: UIControlState.normal)
        panel!.orangeButton.setTitle("⚫︎", for: UIControlState.normal)
        panel!.brownButton.setTitle("⚫︎", for: UIControlState.normal)
        panel!.yellowButton.setTitle("⚫︎", for: UIControlState.normal)
        panel!.whiteButton.setTitle("⚫︎", for: UIControlState.normal)
        panel!.purpleButton.setTitle("⚫︎", for: UIControlState.normal)
        panel!.customColorButton.setTitle("☆", for: UIControlState.normal)
        
        setCustomColorButton()
    }
    
//    private func setCustomColorButton() {
//        if let customColor = customColor {
//            panel!.customColorButton.setTitleColor(customColor.color, forState: .Normal)
//        }
//    }
    private func setCustomColorButton() {
        if let customColor = customColor {
            panel!.customColorButton.setTitleColor(customColor.color, for: .normal)
        }
    }
    
//    private func delay(delay:Double, closure:()->()) {
//        dispatch_after(
//            dispatch_time(
//                DISPATCH_TIME_NOW,
//                Int64(delay * Double(NSEC_PER_SEC))
//            ),
//            dispatch_get_main_queue(), closure)
//    }
    
//    private func loadCustomColor() {
//        if let cc = NSKeyedUnarchiver.unarchiveObjectWithFile(CustomColor.ArchiveURL.path!) as? CustomColor {
//            customColor = cc
//        } else {
//            customColor = CustomColor(color: color)
//        }
//    }
    private func loadCustomColor() {
        if let cc = NSKeyedUnarchiver.unarchiveObject(withFile: CustomColor.ArchiveURL.path) as? CustomColor {
            customColor = cc
        } else {
            customColor = CustomColor(color: color)
        }
    }
    
//    private func loadCanvasObject() {
//        if let savedCanvas = NSKeyedUnarchiver.unarchiveObjectWithFile(Canvas.ArchiveURL.path!) as? Canvas {
//            canvas.image = savedCanvas.image
//            tempCanvas.image = savedCanvas.image
//        }
//    }
    private func loadCanvasObject() {
        if let savedCanvas = NSKeyedUnarchiver.unarchiveObject(withFile: Canvas.ArchiveURL.path) as? Canvas {
            canvas.image = savedCanvas.image
            tempCanvas.image = savedCanvas.image
        }
    }
    
//    private func saveCanvasAsImage() -> UIImage {
//        UIGraphicsBeginImageContext(canvas.bounds.size)
//        canvas.image?.drawInRect(CGRect(x: 0, y: 0, width: canvas.frame.size.width, height: canvas.frame.size.height))
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//
//        return image
//    }
    private func saveCanvasAsImage() -> UIImage? {
        UIGraphicsBeginImageContext(canvas.bounds.size)
        canvas.image?.draw(in: CGRect(x: 0, y: 0, width: canvas.frame.size.width, height: canvas.frame.size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    private func setPanelShadowOpacity() {
        if panelIsOpen {
            panel?.layer.shadowOpacity = 0.8
        } else {
            panel?.layer.shadowOpacity = 0.0
        }
    }

}



//extension DrawingViewController: ColorWheelViewControllerDelegate {
//    func colorWheelViewControllerFinished(colorWheelViewController: ColorWheelViewController) {
//        if let selectedColor = colorWheelViewController.selectedColor {
//            color = selectedColor
//
//            if let customColor = customColor {
//                customColor.color = selectedColor
//            } else {
//                customColor = CustomColor(color: selectedColor)
//            }
//
//            // Save custom color
//            let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(customColor!, toFile: CustomColor.ArchiveURL.path!)
//            if !isSuccessfulSave {
//                print("Failed to save custom color...")
//            }
//
//            setCustomColorButton()
//
//            toggleButton(button: panel!.customColorButton)
//        }
//    }
//}
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
            let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(customColor!, toFile: CustomColor.ArchiveURL.path)
            if !isSuccessfulSave {
                print("Failed to save custom color...")
            }
            
            setCustomColorButton()
            
            toggleButton(button: panel!.customColorButton)
        }
    }
}

