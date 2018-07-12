//
//  CustomColor.swift
//  Fingerpainter
//
//  Created by Morgan Davison on 12/1/15.
//  Copyright © 2015 Morgan Davison. All rights reserved.
//

import UIKit

class CustomColor: NSObject, NSCoding {

    var color = UIColor.black
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("custom-color")
    
    struct PropertyKey {
        static let colorKey = "uicolor"
    }
    
    init?(color: UIColor) {
        self.color = color
        
        super.init()
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let color = aDecoder.decodeObject(forKey: PropertyKey.colorKey) as! UIColor
        
        self.init(color: color)
    }
    
    // MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(color, forKey: PropertyKey.colorKey)
    }
}
