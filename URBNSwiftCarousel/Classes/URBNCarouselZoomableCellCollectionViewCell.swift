//
//  URBNCarouselZoomableCellCollectionViewCell.swift
//  Pods
//
//  Created by Kevin Taniguchi on 4/26/16.
//
//

import UIKit

public class URBNCarouselZoomableCell: UICollectionViewCell, UIScrollViewDelegate {
    public var scrollView: UIScrollView?
    public let imageView = UIImageView()
    
    
    public var index = 0
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        scrollView = UIScrollView(frame: bounds)
        guard let sv = scrollView else { return }
        sv.userInteractionEnabled = false
        sv.maximumZoomScale = 2.0
        sv.minimumZoomScale = 1.0
        sv.zoomScale = 1.0
        sv.delegate = self
        
        scrollView?.setZoomScale(1.0, animated: true)
        contentView.frame = bounds
        scrollView?.frame = contentView.bounds
        imageView.frame = contentView.bounds
        scrollView?.contentSize = imageView.bounds.size
        
        contentView.addSubview(sv)
        
        imageView.contentMode = .ScaleAspectFit
        sv.addSubview(imageView)
    }
    
    // MARL: UIScrollView Delegate
    public func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    public func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        guard let imgView = view else { return }
        UIView.animateWithDuration(0.2) { 
            imgView.center = CGPointMake(scrollView.bounds.size.width / 2 * scale, scrollView.bounds.size.height/2 * scale)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
