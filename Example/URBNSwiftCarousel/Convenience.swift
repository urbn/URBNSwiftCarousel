//
//  Convenience.swift
//  URBNSwiftCarousel
//
//  Created by Kevin Taniguchi on 4/26/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import QuartzCore

extension UIColor {
    static var colors: [UIColor] {
        return [UIColor.redColor(), UIColor.orangeColor(), UIColor.purpleColor(), UIColor.cyanColor(), UIColor.blueColor(), UIColor.greenColor(), UIColor.yellowColor()]
    }
    
    static func colorForIndex(index: Int) -> UIColor {
        return colors[index]
    }
}

extension UIImage {
    static func imageFromView(view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
        view.layer.renderInContext(ctx)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    static func testingImages() -> [UIImage] {
        var data = [UIImage]()
        for index in 0...6 {
            let lbl = UILabel()
            lbl.font = UIFont(name: "Avenir", size: 120)
            lbl.text = "\(index)"
            lbl.backgroundColor = UIColor.colors[index]
            lbl.sizeToFit()
            if let image = UIImage.imageFromView(lbl) {
                data.append(image)
            }
        }
        
        return data
    }
}
