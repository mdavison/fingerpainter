//
//  Canvas.swift
//  Fingerpainting
//
//  Created by Morgan Davison on 1/12/16.
//  Copyright © 2016 Morgan Davison. All rights reserved.
//

import UIKit

class Canvas: NSObject, NSCoding {
    
    var image: UIImage?
    
    // MARK: Archiving Paths
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("canvas")
    //let archiveURL = ArchiveURL
    
    struct PropertyKey {
        static let imageKey = "image"
    }
    
    init?(image: UIImage) {
        self.image = image
        
        super.init()
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let image = aDecoder.decodeObjectForKey(PropertyKey.imageKey) as! UIImage
        
        self.init(image: image)
    }
    
    
    // MARK: NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(image, forKey: PropertyKey.imageKey)
    }
    
}