//
//  URBNPresentationController.swift
//  Pods
//
//  Created by Kevin Taniguchi on 4/30/16.
//
//

import UIKit

/**
    This subclass of UIPresentationController manages the UIImageView that zooms in and out between the source and destination view controllers.
    It also handles synchonizaton of the collection views
*/

public class URBNPresentationController: UIPresentationController {
    
    // MARK: Public Variables
    public var maskingNavBarColor: UIColor?
    
    // MARK: Private Variables
    private var transitionView = UIImageView()
    
    private let assertionWarningCarouselTransitioning = "Warning : make sure  all VC's being passed in conform to the URBNSwCarouselTransitioning protocol"
    
    lazy private var navBarCoverView = UIView()
    
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
    
    // MARK: Public Overrides of UIPresentationController's view tracking methods
    override public func presentationTransitionWillBegin() {
        guard let destinationVC = presentedViewController as? URBNSwCarouselTransitioning, containingView = containerView, transitionCoordinator = presentingViewController.transitionCoordinator()
            else {
                assertionFailure(assertionWarningCarouselTransitioning)
                return
        }
        
        var sourceVC: URBNSwCarouselTransitioning
        if let topVC = topFromVC {
            sourceVC = topVC
        }
        else {
            guard let vc = presentingViewController as? URBNSwCarouselTransitioning else {
                assertionFailure(assertionWarningCarouselTransitioning)
                return
            }
            sourceVC = vc
        }
        
        let toView = presentedViewController.view
        
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
    
    override public func presentationTransitionDidEnd(completed: Bool) {
        guard let sourceVC = topFromVC, destinationVC = presentedViewController as? URBNSwCarouselTransitioning, containingView = containerView
            else {
                assertionFailure(assertionWarningCarouselTransitioning)
                return
        }
        exposeTransitionViewtoViewControllersIfNecessary(sourceVC, destinationVC: destinationVC)
        transitionView.removeFromSuperview()
    }
    
    override public func dismissalTransitionWillBegin() {
        guard let sourceVC = presentedViewController as? URBNSwCarouselTransitioning, destinationVC = topFromVC, containingView = containerView, transitionCoordinator = presentingViewController.transitionCoordinator() else {
            assertionFailure(assertionWarningCarouselTransitioning)
            return
        }
        
        synchronizeCollectionViews(sourceVC, destinationVC: destinationVC)
        setUpImageForTransition(sourceVC, destinationVC: destinationVC, containingView: containingView)
        coverNavigationBarIfNecessary(containingView)
        
        transitionCoordinator.animateAlongsideTransition({ (context) in
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
                self.setFinalTransformForImage(sourceVC, destinationVC: destinationVC, containingView: containingView)
                }, completion: { (complete) in
                    if complete {
                        UIView.animateWithDuration(0.2, animations: { 
                            self.navBarCoverView.alpha = 0.0
                        })
                    }
            }   )
            }, completion: nil)
    }
    
    override public func dismissalTransitionDidEnd(completed: Bool) {
        guard let sourceVC = presentedViewController as? URBNSwCarouselTransitioning, destinationVC = topFromVC, containingView = containerView else {
            assertionFailure(assertionWarningCarouselTransitioning)
            return
        }
        exposeTransitionViewtoViewControllersIfNecessary(sourceVC, destinationVC: destinationVC)
        transitionView.removeFromSuperview()
    }
    
    // MARK: Convenience
    /**
    *   These methods handle the image view that is animated during the zoom out / zoom transitions.
    */
    private func setUpImageForTransition(sourceVC: URBNSwCarouselTransitioning, destinationVC: URBNSwCarouselTransitioning, containingView: UIView) {
        let convertedStartingFrame = sourceVC.fromImageFrameForGalleryTransitionWithContainerView(containingView)
        let convertedEndingFrame = destinationVC.toImageFrameForGalleryTransitionWithContainerView(containingView, sourceImageFrame: convertedStartingFrame)
        
        // Set the view's frame to the final dimensions and transform it down to match starting dimensions.
        transitionView = UIImageView(frame: convertedEndingFrame)
        transitionView.contentMode = .ScaleToFill
        transitionView.image = sourceVC.imageForGalleryTransition()
        
        let scaleX = convertedStartingFrame.width / convertedEndingFrame.width
        let scaleY = convertedStartingFrame.height / convertedEndingFrame.height
        
        let transform = CGAffineTransformMakeScale(scaleX, scaleY)
        transitionView.transform = transform
        transitionView.center = CGPointMake(CGRectGetMidX(convertedStartingFrame), CGRectGetMidY(convertedStartingFrame))
        
        containingView.addSubview(transitionView)
    }
    
    private func setFinalTransformForImage(sourceVC: URBNSwCarouselTransitioning, destinationVC: URBNSwCarouselTransitioning, containingView: UIView) {
        let convertedStartingFrame = sourceVC.fromImageFrameForGalleryTransitionWithContainerView(containingView)
        let convertedEndingFrame = destinationVC.toImageFrameForGalleryTransitionWithContainerView(containingView, sourceImageFrame: convertedStartingFrame)
        
        var center = CGPoint()
        var transForm = CGAffineTransform()
  
        transForm = CGAffineTransformIdentity
        center = CGPointMake(CGRectGetMidX(convertedEndingFrame), CGRectGetMidY(convertedEndingFrame))
        
        transitionView.center = center
        transitionView.transform = transForm
    }
    
    /**
    *    This method syncs the cells between collection views by taking in the index path of the cell selected for zooming.  
    *    That index path is sent to the destination collection view which scrolls to that index path.
    */
    private func synchronizeCollectionViews(sourceVC: URBNSwCarouselTransitioning, destinationVC: URBNSwCarouselTransitioning) {
        guard let destSyncVC = destinationVC as? URBNSynchronizingDelegate, sourceSyncVC = sourceVC as? URBNSynchronizingDelegate, path = sourceSyncVC.sourceIndexPath(), cv = destSyncVC.toCollectionView() else {
            assertionFailure(assertionWarningCarouselTransitioning)
            return }
        
        cv.scrollToItemAtIndexPath(path, atScrollPosition: .None, animated: false)
        cv.reloadItemsAtIndexPaths([path])
        if let cell = cv.cellForItemAtIndexPath(path) as? URBNCarouselZoomableCell {
            destSyncVC.updateSourceSelectedCell?(cell)
        }
    }
    
    /**
    *    Sometimes the presentingViewController will be the navigation controller of the presenting view controller.
    *    If the selected collectionViewCell is underneath the navigation bar at the time of animation, upon return it will overlay the navigation bar.  
    *     We get a screen shot of the navigation bar and use it as part of the animation transition so that the animating image view goes behind it.
    */
    private func coverNavigationBarIfNecessary(containingView: UIView) {
        guard let navBar = navBarOfPresentingViewController, nav = presentingViewController as? UINavigationController else {
            assertionFailure(assertionWarningCarouselTransitioning)
            return }
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
    }
    
    /*
     Convenience
    */
    private func exposeTransitionViewtoViewControllersIfNecessary(sourceVC: URBNSwCarouselTransitioning, destinationVC: URBNSwCarouselTransitioning) {
        guard let svc = sourceVC as? URBNSwCarouselTransitioningImageView, dvc = destinationVC as? URBNSwCarouselTransitioningImageView else {
            assertionFailure(assertionWarningCarouselTransitioning)
            return }
        svc.willBeginGalleryTransitionWithImageView(transitionView, isToVC: false)
        dvc.willBeginGalleryTransitionWithImageView(transitionView, isToVC: true)
    }
}
