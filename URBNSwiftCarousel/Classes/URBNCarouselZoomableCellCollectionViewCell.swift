//
//  URBNCarouselZoomableCellCollectionViewCell.swift
//  Pods
//
//  Created by Kevin Taniguchi on 4/26/16.
//
//

import UIKit

public class URBNCarouselZoomableCell: UICollectionViewCell, UIScrollViewDelegate {
    public let scrollView = UIScrollView()
    public let imageView = UIImageView()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        scrollView.userInteractionEnabled = false
        scrollView.maximumZoomScale = 2.0
        scrollView.minimumZoomScale = 1.0
        scrollView.zoomScale = 1.0
        scrollView.delegate = self
        
        scrollView.setZoomScale(1.0, animated: true)
        contentView.frame = bounds
        scrollView.frame = contentView.bounds
        imageView.frame = contentView.bounds
        scrollView.contentSize = imageView.bounds.size
        
        contentView.addSubview(scrollView)
        
        imageView.contentMode = .ScaleAspectFit
        scrollView.addSubview(imageView)
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
