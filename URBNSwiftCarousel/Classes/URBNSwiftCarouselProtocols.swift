//
//  URBNSwiftCarouselProtocols.swift
//  Pods
//
//  Created by Kevin Taniguchi on 4/28/16.
//
//

import Foundation

typealias URBNCarouselViewInteractionBeganClosure = (controller: URBNSwCarouselTransitionController, view: UIView) -> Void

@objc public enum TranstionDirection: Int {
    case scaleUp = 0
    case scaleDown
}

@objc public enum URBNCarouselTransitionState: Int {
    case start = 0
    case end
}

@objc public protocol URBNSynchronizingDelegate {
    optional func updateSourceSelectedCell(cell: URBNCarouselZoomableCell)
    
    func sourceIndexPath() -> NSIndexPath?
    func toCollectionView() -> UICollectionView?
}

/*
 Required protocol your source and destination view controllers must adapt to implement the zoom out / zoom in view controller transition animation
 */
@objc public protocol URBNSwCarouselTransitioning {
    
    // Required Methods
    /*
     Detailed explanations can be found in the example project.
    */
    func imageForGalleryTransition() -> UIImage
    
    func fromImageFrameForGalleryTransitionWithContainerView(containerView: UIView) -> CGRect
    
    func toImageFrameForGalleryTransitionWithContainerView(containerView: UIView, sourceImageFrame: CGRect) -> CGRect
}

/*
 Optional Helper protocol you can adopt to adjust the image view being animated
*/

@objc public protocol URBNSwCarouselTransitioningImageView {
    func willBeginGalleryTransitionWithImageView(imageView: UIImageView, isToVC: Bool)
    func didEndGalleryTransitionWithImageView(imageView: UIImageView, isToVC: Bool)
    func configureAnimatingTransitionImageView(imageView: UIImageView)
}
