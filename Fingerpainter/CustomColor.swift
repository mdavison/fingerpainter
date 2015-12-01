//
//  CustomColor.swift
//  Fingerpainter
//
//  Created by Morgan Davison on 12/1/15.
//  Copyright © 2015 Morgan Davison. All rights reserved.
//

import UIKit

class CustomColor: NSObject, NSCoding {
    
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("customcolor")
    
    struct PropertyKey {
        static let redKey = "red"
        static let greenKey = "green"
        static let blueKey = "blue"
    }
    
    init?(red: CGFloat, green: CGFloat, blue: CGFloat) {
        self.red = red
        self.green = green
        self.blue = blue
        
        super.init()
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let red = aDecoder.decodeObjectForKey(PropertyKey.redKey) as! CGFloat
        let green = aDecoder.decodeObjectForKey(PropertyKey.greenKey) as! CGFloat
        let blue = aDecoder.decodeObjectForKey(PropertyKey.blueKey) as! CGFloat
        
        self.init(red: red, green: green, blue: blue)
    }
    
    
    // MARK: NSCoding
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(red, forKey: PropertyKey.redKey)
        aCoder.encodeObject(green, forKey: PropertyKey.greenKey)
        aCoder.encodeObject(blue, forKey: PropertyKey.blueKey)
    }

}