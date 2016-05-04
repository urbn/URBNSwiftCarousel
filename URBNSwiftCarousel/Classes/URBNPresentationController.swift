//
//  URBNPresentationController.swift
//  Pods
//
//  Created by Kevin Taniguchi on 4/30/16.
//
//

import UIKit

class URBNPresentationController: UIPresentationController {
    public var maskingNavBarColor: UIColor?
    
    private var transitionView = UIImageView()
    private let assertionWarning = "Warning : make sure  all VC's being passed in conform to the URBNSwCarouselTransitioning protocol"
    
    private var topFromVC: URBNSwCarouselTransitioning? {
        let nav = presentingViewController as? UINavigationController
        return nav?.topViewController as? URBNSwCarouselTransitioning
    }
    
    private var navBarOfPresentingViewController: UIView? {
        guard let nav = presentingViewController as? UINavigationController else { return nil }
        let snapShotOfNavbar = nav.navigationBar.snapshotViewAfterScreenUpdates(true)
        snapShotOfNavbar.translatesAutoresizingMaskIntoConstraints = false
        return snapShotOfNavbar
    }
    
    lazy private var navBarCoverView = UIView()
    
    override func presentationTransitionWillBegin() {
        guard let destinationVC = presentedViewController as? URBNSwCarouselTransitioning, containingView = containerView, transitionCoordinator = presentingViewController.transitionCoordinator()
            else {
                assertionFailure(assertionWarning)
                return
        }
        
        var sourceVC: URBNSwCarouselTransitioning
        if let topVC = topFromVC {
            sourceVC = topVC
        }
        else {
            guard let vc = presentingViewController as? URBNSwCarouselTransitioning else {
                assertionFailure(assertionWarning)
                return
            }
            sourceVC = vc
        }
        
        guard let nav = presentingViewController as? UINavigationController, fromVC = nav.topViewController else { return }
        var toView = presentedViewController.view
        
        toView.frame = containingView.bounds
        toView.setNeedsLayout()
        containingView.addSubview(toView)
        
        setUpImageForTransition(sourceVC, destinationVC: destinationVC, containingView: containingView)
        synchronizeCollectionViews(sourceVC, destinationVC: destinationVC)
        
        transitionCoordinator.animateAlongsideTransition({ (context) in
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: { 
            self.setFinalTransformForImage(sourceVC, destinationVC: destinationVC, containingView: containingView)
                }, completion: nil)
            }, completion: nil)
    }
    
    override func presentationTransitionDidEnd(completed: Bool) {
        guard let sourceVC = topFromVC, destinationVC = presentedViewController as? URBNSwCarouselTransitioning, containingView = containerView
            else {
                assertionFailure(assertionWarning)
                return
        }
        fireDelegatesAndReset(sourceVC, destinationVC: destinationVC, containingView: containingView)
    }
    
    override func dismissalTransitionWillBegin() {
        guard let sourceVC = presentedViewController as? URBNSwCarouselTransitioning, destinationVC = topFromVC, containingView = containerView, transitionCoordinator = presentingViewController.transitionCoordinator() else {
            assertionFailure(assertionWarning)
            return
        }
        
        synchronizeCollectionViews(sourceVC, destinationVC: destinationVC)
        setUpImageForTransition(sourceVC, destinationVC: destinationVC, containingView: containingView)
        
        if let navBar = navBarOfPresentingViewController, nav = presentingViewController as? UINavigationController {
            let rect = nav.view.convertRect(nav.navigationBar.frame, toView: nil)
            if let color = maskingNavBarColor {
                navBar.backgroundColor = color
            }
            else {
                navBar.backgroundColor = UIColor.whiteColor()
            }
            navBar.frame = rect
            navBarCoverView.addSubview(navBar)
            navBarCoverView.translatesAutoresizingMaskIntoConstraints = false
            containingView.addSubview(navBarCoverView)
            navBarCoverView.backgroundColor = UIColor.whiteColor()
            NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[cover]|", options: [], metrics: nil, views: ["cover": navBarCoverView]))
            navBarCoverView.topAnchor.constraintEqualToAnchor(containingView.topAnchor).active = true
            navBarCoverView.heightAnchor.constraintEqualToConstant(20 + rect.height).active = true
//            NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("", options: [], metrics: nil, views: ["bar": navBar]))
        }
        
        transitionCoordinator.animateAlongsideTransition({ (context) in
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
                self.setFinalTransformForImage(sourceVC, destinationVC: destinationVC, containingView: containingView)
                }, completion: nil)
            }, completion: nil)
        
        // TODO if cover view, animate it to 0.0 alpha
    }
    
    override func dismissalTransitionDidEnd(completed: Bool) {
        guard let sourceVC = presentedViewController as? URBNSwCarouselTransitioning, destinationVC = topFromVC, containingView = containerView, transitionCoordinator = presentingViewController.transitionCoordinator() else {
            assertionFailure(assertionWarning)
            return
        }
        fireDelegatesAndReset(sourceVC, destinationVC: destinationVC, containingView: containingView)
    }
    
    // MARK: Convenience
    func setUpImageForTransition(sourceVC: URBNSwCarouselTransitioning, destinationVC: URBNSwCarouselTransitioning, containingView: UIView) {
        let convertedStartingFrame = sourceVC.fromImageFrameForGalleryTransitionWithContainerView(containingView)
        let convertedEndingFrame = destinationVC.toImageFrameForGalleryTransitionWithContainerView(containingView, sourceImageFrame: convertedStartingFrame)
        
        // Set the view's frame to the final dimensions and transform it down to match starting dimensions.
        transitionView = UIImageView(frame: convertedEndingFrame)
        transitionView.contentMode = .ScaleToFill
        transitionView.image = sourceVC.imageForGalleryTransition()
        transitionView.layer.borderWidth = 10.0
        transitionView.layer.borderColor = UIColor.greenColor().CGColor
        
        let scaleX = convertedStartingFrame.width / convertedEndingFrame.width
        let scaleY = convertedStartingFrame.height / convertedEndingFrame.height
        
        let transform = CGAffineTransformMakeScale(scaleX, scaleY)
        transitionView.transform = transform
        transitionView.center = CGPointMake(CGRectGetMidX(convertedStartingFrame), CGRectGetMidY(convertedStartingFrame))
        
        containingView.addSubview(transitionView)
        
        sourceVC.willBeginGalleryTransitionWithImageView?(transitionView, isToVC: false)
        destinationVC.willBeginGalleryTransitionWithImageView?(transitionView, isToVC: true)
    }
    
    func setFinalTransformForImage(sourceVC: URBNSwCarouselTransitioning, destinationVC: URBNSwCarouselTransitioning, containingView: UIView) {
        let convertedStartingFrame = sourceVC.fromImageFrameForGalleryTransitionWithContainerView(containingView)
        let convertedEndingFrame = destinationVC.toImageFrameForGalleryTransitionWithContainerView(containingView, sourceImageFrame: convertedStartingFrame)
        
        var center = CGPoint()
        var transForm = CGAffineTransform()
  
        transForm = CGAffineTransformIdentity
        center = CGPointMake(CGRectGetMidX(convertedEndingFrame), CGRectGetMidY(convertedEndingFrame))
        
        transitionView.center = center
        transitionView.transform = transForm
    }
    
    func fireDelegatesAndReset(sourceVC: URBNSwCarouselTransitioning, destinationVC: URBNSwCarouselTransitioning, containingView: UIView) {
        sourceVC.didEndGalleryTransitionWithImageView?(transitionView, isToVC: false)
        destinationVC.didEndGalleryTransitionWithImageView?(transitionView, isToVC: true)
        transitionView.removeFromSuperview()
    }
    
    func synchronizeCollectionViews(sourceVC: URBNSwCarouselTransitioning, destinationVC: URBNSwCarouselTransitioning) {
        guard let destSyncVC = destinationVC as? URBNSynchronizingDelegate, sourceSyncVC = sourceVC as? URBNSynchronizingDelegate, path = sourceSyncVC.sourceIndexPath(), cv = destSyncVC.toCollectionView() else { return }
        
        cv.scrollToItemAtIndexPath(path, atScrollPosition: .None, animated: false)
        cv.reloadItemsAtIndexPaths([path])
        if let cell = cv.cellForItemAtIndexPath(path) as? URBNCarouselZoomableCell {
            destSyncVC.updateSourceSelectedCell?(cell)
        }
    }
}
