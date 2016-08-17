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
    @IBOutlet weak var customColorButton: UIButton! 
    
    @IBOutlet weak var panelButtonsView: UIView!
    @IBOutlet weak var colorsButton: UIButton!
    @IBOutlet weak var brushesButton: UIButton!
    @IBOutlet weak var opacityButton: UIButton!
    
    @IBOutlet weak var colorsView: UIView!
    @IBOutlet weak var brushesView: UIView!
    @IBOutlet weak var opacityView: UIView!
    
    @IBOutlet weak var brushButton1: UIButton!
    @IBOutlet weak var brushButton2: UIButton!
    @IBOutlet weak var brushButton3: UIButton!
    @IBOutlet weak var brushButton4: UIButton!
    @IBOutlet weak var brushButton5: UIButton!
    
    @IBOutlet weak var opacityButton1: UIButton!
    @IBOutlet weak var opacityButton2: UIButton!
    @IBOutlet weak var opacityButton3: UIButton!
    
    
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
    
    func setSelectedBrushIcon(selectedButton: UIButton) {
        resetBrushButtons()
        
        switch selectedButton {
        case brushButton1:
            brushButton1.setImage(UIImage(named: "BrushButton1Selected"), forState: .Normal)
        case brushButton2:
            brushButton2.setImage(UIImage(named: "BrushButton2Selected"), forState: .Normal)
        case brushButton3:
            brushButton3.setImage(UIImage(named: "BrushButton3Selected"), forState: .Normal)
        case brushButton4:
            brushButton4.setImage(UIImage(named: "BrushButton4Selected"), forState: .Normal)
        case brushButton5:
            brushButton5.setImage(UIImage(named: "BrushButton5Selected"), forState: .Normal)
        default:
            break;
        }
    }
    
    func setSelectedOpacityIcon(selectedButton: UIButton) {
        
        switch selectedButton {
        case opacityButton1:
            opacityButton1.setBackgroundImage(UIImage(named: "OpacityIconFilled"), forState: .Normal)
            opacityButton2.setBackgroundImage(UIImage(named: "OpacityIcon"), forState: .Normal)
            opacityButton3.setBackgroundImage(UIImage(named: "OpacityIcon"), forState: .Normal)
        case opacityButton2:
            opacityButton2.setBackgroundImage(UIImage(named: "OpacityIconFilled"), forState: .Normal)
            opacityButton1.setBackgroundImage(UIImage(named: "OpacityIcon"), forState: .Normal)
            opacityButton3.setBackgroundImage(UIImage(named: "OpacityIcon"), forState: .Normal)
        case opacityButton3:
            opacityButton3.setBackgroundImage(UIImage(named: "OpacityIconFilled"), forState: .Normal)
            opacityButton1.setBackgroundImage(UIImage(named: "OpacityIcon"), forState: .Normal)
            opacityButton2.setBackgroundImage(UIImage(named: "OpacityIcon"), forState: .Normal)
        default:
            break;
        }
    }
    
    
    // MARK: - Helper Methods
    
    private func resetBrushButtons() {
        brushButton1.setImage(UIImage(named: "BrushButton1"), forState: .Normal)
        brushButton2.setImage(UIImage(named: "BrushButton2"), forState: .Normal)
        brushButton3.setImage(UIImage(named: "BrushButton3"), forState: .Normal)
        brushButton4.setImage(UIImage(named: "BrushButton4"), forState: .Normal)
        brushButton5.setImage(UIImage(named: "BrushButton5"), forState: .Normal)
    }
}
