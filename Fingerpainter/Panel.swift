//
//  Panel.swift
//  Fingerpainting
//
//  Created by Morgan Davison on 8/8/16.
//  Copyright © 2016 Morgan Davison. All rights reserved.
//

import UIKit

class Panel: UIView {
    
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var orangeButton: UIButton!
    @IBOutlet weak var yellowButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var purpleButton: UIButton!
    @IBOutlet weak var brownButton: UIButton!
    @IBOutlet weak var blackButton: UIButton!
    @IBOutlet weak var grayButton: UIButton!
    @IBOutlet weak var whiteButton: UIButton!
    
    @IBOutlet weak var panelButtonsView: UIView!
    @IBOutlet weak var colorsButton: UIButton!
    @IBOutlet weak var brushesButton: UIButton!
    @IBOutlet weak var opacityButton: UIButton!
    
    @IBOutlet weak var colorsView: UIView!
    @IBOutlet weak var brushesView: UIView!
    @IBOutlet weak var opacityView: UIView!

    
    func setSelectedPanelIcon(selectedButton: UIButton) {
        switch selectedButton {
        case colorsButton:
            colorsButton.setImage(UIImage(named: "ColorIconFilled"), forState: .Normal)
            brushesButton.setImage(UIImage(named: "BrushIcon"), forState: .Normal)
            opacityButton.setImage(UIImage(named: "OpacityIcon"), forState: .Normal)
        case brushesButton:
            brushesButton.setImage(UIImage(named: "BrushIconFilled"), forState: .Normal)
            colorsButton.setImage(UIImage(named: "ColorIcon"), forState: .Normal)
            opacityButton.setImage(UIImage(named: "OpacityIcon"), forState: .Normal)
        case opacityButton:
            opacityButton.setImage(UIImage(named: "OpacityIconFilled"), forState: .Normal)
            brushesButton.setImage(UIImage(named: "BrushIcon"), forState: .Normal)
            colorsButton.setImage(UIImage(named: "ColorIcon"), forState: .Normal)
        default:
            brushesButton.setImage(UIImage(named: "BrushIcon"), forState: .Normal)
            colorsButton.setImage(UIImage(named: "ColorIcon"), forState: .Normal)
            opacityButton.setImage(UIImage(named: "OpacityIcon"), forState: .Normal)
        }
    }
}
