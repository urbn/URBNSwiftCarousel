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

@objc public protocol URBNSwCarouselInteractiveDelegate {
    func shouldBeginInteractiveTransitionWithView(view: UIView, direction: TranstionDirection) -> Bool
}

@objc public protocol URBNSynchronizingDelegate {
    optional func updateSourceSelectedCell(cell: URBNCarouselZoomableCell)
    
    func sourceIndexPath() -> NSIndexPath?
    func toCollectionView() -> UICollectionView?
}

/*
 This is the protocol your source and destination view controllers must adapt to implement the zoom out / zoom in view controller transition animation
 */
@objc public protocol URBNSwCarouselTransitioning {
    
    optional func shouldBeginInteractiveTransitionWithDirection(direction: TranstionDirection) -> Bool
    optional func willBeginGalleryTransitionWithImageView(imageView: UIImageView, isToVC: Bool)
    optional func didEndGalleryTransitionWithImageView(imageView: UIImageView, isToVC: Bool)
    // Called inside the animation block of a non-interactive transition.
    optional func configureAnimatingTransitionImageView(imageView: UIImageView)
    
    // Required Methods
    /*
     This method gets the image that is used in the imageView that is zoomed in and out
    */
    func imageForGalleryTransition() -> UIImage
    
    func fromImageFrameForGalleryTransitionWithContainerView(containerView: UIView) -> CGRect
    
    func toImageFrameForGalleryTransitionWithContainerView(containerView: UIView, sourceImageFrame: CGRect) -> CGRect
}
