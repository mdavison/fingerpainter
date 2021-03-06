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
            colorsButton.setImage(UIImage(named: "ColorIconFilled"), for: .normal)
            brushesButton.setImage(UIImage(named: "BrushIcon"), for: .normal)
            opacityButton.setImage(UIImage(named: "OpacityIcon"), for: .normal)
        case brushesButton:
            brushesButton.setImage(UIImage(named: "BrushIconFilled"), for: .normal)
            colorsButton.setImage(UIImage(named: "ColorIcon"), for: .normal)
            opacityButton.setImage(UIImage(named: "OpacityIcon"), for: .normal)
        case opacityButton:
            opacityButton.setImage(UIImage(named: "OpacityIconFilled"), for: .normal)
            brushesButton.setImage(UIImage(named: "BrushIcon"), for: .normal)
            colorsButton.setImage(UIImage(named: "ColorIcon"), for: .normal)
        default:
            brushesButton.setImage(UIImage(named: "BrushIcon"), for: .normal)
            colorsButton.setImage(UIImage(named: "ColorIcon"), for: .normal)
            opacityButton.setImage(UIImage(named: "OpacityIcon"), for: .normal)
        }
    }
    
    func setSelectedBrushIcon(selectedButton: UIButton) {
        resetBrushButtons()
        
        switch selectedButton {
        case brushButton1:
            brushButton1.setImage(UIImage(named: "BrushButton1Selected"), for: .normal)
        case brushButton2:
            brushButton2.setImage(UIImage(named: "BrushButton2Selected"), for: .normal)
        case brushButton3:
            brushButton3.setImage(UIImage(named: "BrushButton3Selected"), for: .normal)
        case brushButton4:
            brushButton4.setImage(UIImage(named: "BrushButton4Selected"), for: .normal)
        case brushButton5:
            brushButton5.setImage(UIImage(named: "BrushButton5Selected"), for: .normal)
        default:
            break;
        }
    }
    
    func setSelectedOpacityIcon(selectedButton: UIButton) {
        
        switch selectedButton {
        case opacityButton1:
            opacityButton1.setBackgroundImage(UIImage(named: "OpacityIconFilled"), for: .normal)
            opacityButton2.setBackgroundImage(UIImage(named: "OpacityIcon"), for: .normal)
            opacityButton3.setBackgroundImage(UIImage(named: "OpacityIcon"), for: .normal)
        case opacityButton2:
            opacityButton2.setBackgroundImage(UIImage(named: "OpacityIconFilled"), for: .normal)
            opacityButton1.setBackgroundImage(UIImage(named: "OpacityIcon"), for: .normal)
            opacityButton3.setBackgroundImage(UIImage(named: "OpacityIcon"), for: .normal)
        case opacityButton3:
            opacityButton3.setBackgroundImage(UIImage(named: "OpacityIconFilled"), for: .normal)
            opacityButton1.setBackgroundImage(UIImage(named: "OpacityIcon"), for: .normal)
            opacityButton2.setBackgroundImage(UIImage(named: "OpacityIcon"), for: .normal)
        default:
            break;
        }
    }
    
    
    // MARK: - Helper Methods
    
    private func resetBrushButtons() {
        brushButton1.setImage(UIImage(named: "BrushButton1"), for: .normal)
        brushButton2.setImage(UIImage(named: "BrushButton2"), for: .normal)
        brushButton3.setImage(UIImage(named: "BrushButton3"), for: .normal)
        brushButton4.setImage(UIImage(named: "BrushButton4"), for: .normal)
        brushButton5.setImage(UIImage(named: "BrushButton5"), for: .normal)
    }
}
