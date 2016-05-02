//
//  URBNPresentationController.swift
//  Pods
//
//  Created by Kevin Taniguchi on 4/30/16.
//
//

import UIKit

class URBNPresentationController: UIPresentationController {
    private var transitionView = UIImageView()
    private let assertionWarning = "Warning : make sure  all VC's being passed in conform to the URBNSwCarouselTransitioning protocol"
    
    private var topFromVC: URBNSwCarouselTransitioning? {
        let nav = presentingViewController as? UINavigationController
        return nav?.topViewController as? URBNSwCarouselTransitioning
    }
    
    override func presentationTransitionWillBegin() {
        guard let sourceVC = topFromVC, destinationVC = presentedViewController as? URBNSwCarouselTransitioning, containingView = containerView, transitionCoordinator = presentingViewController.transitionCoordinator()
            else {
                assertionFailure(assertionWarning)
                return
        }
        
        guard let nav = presentingViewController as? UINavigationController, fromVC = nav.topViewController else { return }
        var toView = presentedViewController.view
        
        toView.frame = containingView.bounds
        toView.setNeedsLayout()
        containingView.addSubview(toView)
        
        setUpImageForTransition(sourceVC, destinationVC: destinationVC, containingView: containingView)
        
        transitionCoordinator.animateAlongsideTransition({ (context ) in
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
        setUpImageForTransition(sourceVC, destinationVC: destinationVC, containingView: containingView)
        
        transitionCoordinator.animateAlongsideTransition({ (contextd) in
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: { 
                self.setFinalTransformForImage(sourceVC, destinationVC: destinationVC, containingView: containingView)
                }, completion: nil)
            }, completion: nil)
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
        
        print(transitionView.frame)
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
}
