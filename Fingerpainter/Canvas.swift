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
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("canvas")
    
    struct PropertyKey {
        static let imageKey = "image"
    }
    
    init?(image: UIImage) {
        self.image = image
        
        super.init()
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let image = aDecoder.decodeObject(forKey: PropertyKey.imageKey) as! UIImage
        
        self.init(image: image)
    }
    
    // MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(image, forKey: PropertyKey.imageKey)
    }
}
