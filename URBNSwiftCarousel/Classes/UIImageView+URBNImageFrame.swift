//
//  UIImageView+URBNImageFrame.swift
//  Pods
//
//  Created by Kevin Taniguchi on 4/26/16.
//
//

public extension UIImageView {
    static func urbn_aspectFitSizeForImageSize(imageSize: CGSize, rect: CGRect) -> CGSize {
        let hfactor = imageSize.width / rect.width
        let vfactor = imageSize.height / rect.height
        
        let factor = fmax(hfactor, vfactor)
        
        let newW = imageSize.width / factor
        let newH = imageSize.height / factor
        
        return CGSizeMake(newW, newH)
    }
    
    func urbn_imageFrame() -> CGRect {
        guard let img = image else { return CGRectZero }
        let imgSize = img.size
        let frameSize = frame.size
        
        var resultFrame = CGRectZero
        
        let imageSmallerThanFrame = imgSize.width < frameSize.width && imgSize.height < frameSize.height
        
        if imageSmallerThanFrame == true {
            resultFrame.size = imgSize
        }
        else {
            let widthRatio = imgSize.width / frameSize.width
            let heightRatio = imgSize.height / frameSize.height
            let maxRatio = max(widthRatio, heightRatio)
            
            resultFrame.size = CGSizeMake(round(imgSize.width / maxRatio), round(imgSize.height / maxRatio))
        }
        
        resultFrame.origin = CGPointMake(round(center.x - resultFrame.size.width / 2), round(center.y - resultFrame.size.height / 2))
        return resultFrame
    }
}
