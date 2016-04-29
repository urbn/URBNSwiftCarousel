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
    case ScaleUp = 0
    case ScaleDown
}

@objc public enum URBNCarouselTransitionState: Int {
    case Start = 0
    case End
}

@objc public protocol URBNSwCarouselInteractiveDelegate {
    func shouldBeginInteractiveTransitionWithView(view: UIView, direction: TranstionDirection) -> Bool
}

@objc public protocol URBNSynchronizingDelegate {
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
    func imageForGalleryTransition() -> UIImage
    func fromImageFrameForGalleryTransitionWithContainerView(containerView: UIView) -> CGRect
    func toImageFrameForGalleryTransitionWithContainerView(containerView: UIView, sourceImageFrame: CGRect) -> CGRect
}
