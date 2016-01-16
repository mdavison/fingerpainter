//
//  CustomColor.swift
//  Fingerpainter
//
//  Created by Morgan Davison on 12/1/15.
//  Copyright © 2015 Morgan Davison. All rights reserved.
//

import UIKit

class CustomColor: NSObject, NSCoding {

    var color = UIColor.blackColor()
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    //static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("customcolor")
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("custom-color")
    
    struct PropertyKey {
        static let colorKey = "uicolor"
    }

    init?(color: UIColor) {
        self.color = color
        
        super.init()
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let color = aDecoder.decodeObjectForKey(PropertyKey.colorKey) as! UIColor
        
        self.init(color: color)
    }
    
    
    // MARK: NSCoding
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(color, forKey: PropertyKey.colorKey)
    }

}