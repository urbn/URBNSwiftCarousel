//
//  URBNCarouselZoomableCellCollectionViewCell.swift
//  Pods
//
//  Created by Kevin Taniguchi on 4/26/16.
//
//

import UIKit

class URBNCarouselZoomableCell: UICollectionViewCell, UIScrollViewDelegate {
    override var frame: CGRect {
        didSet {
            scrollView.setZoomScale(1.0, animated: true)
            contentView.frame = bounds
            scrollView.frame = contentView.bounds
            imageView.frame = contentView.bounds
            scrollView.contentSize = imageView.bounds.size
        }
    }
    
    let scrollView = UIScrollView()
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        scrollView.frame = bounds
        scrollView.userInteractionEnabled = false
        scrollView.maximumZoomScale = 2.0
        scrollView.minimumZoomScale = 1.0
        scrollView.zoomScale = 1.0
        scrollView.delegate = self
        contentView.addSubview(scrollView)
        
        imageView.contentMode = .ScaleAspectFit
        scrollView.addSubview(imageView)
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        UIView.animateWithDuration(0.2) { 
            view?.center = CGPointMake(scrollView.bounds.size.width / 2 * scale, scrollView.bounds.size.height / 2 * scale)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
