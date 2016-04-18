//
//  SwiftDataUtilities.swift
//  SwiftData
//
//  Created by Mike Neill on 10/26/15.
//  Copyright © 2015 Mike's App Shop. All rights reserved.
//

import Foundation

struct SwiftDataUtilities {
    
    static func getApplicationLibraryDirectory() -> NSURL? {
        
        if let path = NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true).last {
            return NSURL.fileURLWithPath(path)
        }
        
        return nil
    }
}