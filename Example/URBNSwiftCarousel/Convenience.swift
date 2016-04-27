//
//  Convenience.swift
//  URBNSwiftCarousel
//
//  Created by Kevin Taniguchi on 4/26/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

extension UIColor {
    static var colors: [UIColor] {
        return [UIColor.redColor(), UIColor.orangeColor(), UIColor.purpleColor(), UIColor.cyanColor(), UIColor.blueColor(), UIColor.greenColor(), UIColor.yellowColor()]
    }
    
    static func colorForIndex(index: Int) -> UIColor {
        return colors[index]
    }
}

