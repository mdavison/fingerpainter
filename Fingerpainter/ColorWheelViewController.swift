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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        view.setNeedsDisplay()
        super.view.setNeedsDisplay()
        preferredContentSizeDidChange(forChildContentContainer: self)
    }
    
    
    // MARK: - Actions
    
    @IBAction func handleTapGesture(_ sender: UITapGestureRecognizer) {
        let point = sender.location(in: colorWheel)
        
        if colorWheel.colorAtPoint(point: point) != UIColor.clear {
            selectedColor = colorWheel.colorAtPoint(point: point)
            didSelectNewColor = true
            drawPreview()
        }
    }
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        delegate?.colorWheelViewControllerFinished(colorWheelViewController: self)
        
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Private methods
    
    private func drawPreview() {
        var color = UIColor.lightGray
        if let selectedColor = selectedColor {
            color = selectedColor
        }
        
        // Brush Width
        let radius = CGFloat(50.0)
        let offset = radius - 10 // Need to offset to center
        
        UIGraphicsBeginImageContext(colorPreview.frame.size)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(radius)
        context?.setStrokeColor(color.cgColor)
        context?.move(to: CGPoint(x: offset, y: offset))
        context?.addLine(to: CGPoint(x: offset, y: offset))
        context?.strokePath()
        
        colorPreview.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }

}
