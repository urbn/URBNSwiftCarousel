//
//  URBNSwCarouselTransitionController.swift
//  Pods
//
//  Created by Kevin Taniguchi on 4/25/16.
//
//

import UIKit

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
    optional func shouldBeginInteractiveTransitionWithView(view: UIView, direction: TranstionDirection) -> Bool
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

    // Required Methods to conform to this protocol
    func imageForGalleryTransition() -> UIImage
    func fromImageFrameForGalleryTransitionWithContainerView(containerView: UIView) -> CGRect
    func toImageFrameForGalleryTransitionWithContainerView(containerView: UIView, sourceImageFrame: CGRect) -> CGRect
}

/**
 Animation controller built to handle transitions between two images in separate view controllers.
 By default, this class supports non-interactive transitions. To enable interactive transitions, register
 a view for them using the registration method provided.
 
 This class implements the UIViewControllerTransitioningDelegate protocol. As a consumer, you only need to implement
 the URBNCarouselTransitioning protocol.
 
 For the time being, this controller only supports transitions between images.
 */


public class URBNSwCarouselTransitionController: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate, UIViewControllerInteractiveTransitioning, UIGestureRecognizerDelegate {
    private(set) var interactive = false
    weak var interactiveDelegate: URBNSwCarouselInteractiveDelegate?
    
    private var viewInteractionBlocks = [UIView: URBNCarouselViewInteractionBeganClosure]()
    private var viewPinchTransitionGestureRecognizers = [UIView: UIPinchGestureRecognizer]()
    private weak var context: UIViewControllerContextTransitioning?
    private var transitionView = UIImageView()
    
    private var originalSelectedCellFrame = CGRectZero
    private var startScale: CGFloat = -1.0
    private var springCompletionSpeed: Double = 0.6
    private var completionSpeed: Double = 0.2
    private var sourceViewController = UIViewController()
    
    // MARK: Set Up and Tear Down
    func restoreTransitionViewToState(state: URBNCarouselTransitionState, context: UIViewControllerContextTransitioning) {
        guard let fromVC = context.viewControllerForKey(UITransitionContextFromViewControllerKey),
            toVC = context.viewControllerForKey(UITransitionContextToViewControllerKey),
            containerView = context.containerView()
            else { return }
        
        guard let topFromVC = trueContextViewControllerFromContext(context, key: UITransitionContextFromViewControllerKey) as? URBNSwCarouselTransitioning, topToVC = trueContextViewControllerFromContext(context, key: UITransitionContextToViewControllerKey) as? URBNSwCarouselTransitioning else {
            print("Warning : make sure  all VC's being passed in conform to the URBNSwCarouselTransitioning protocol")
            return }
        
        let convertedStartingFrame = topFromVC.fromImageFrameForGalleryTransitionWithContainerView(containerView)
        let convertedEndingFrame = topToVC.toImageFrameForGalleryTransitionWithContainerView(containerView, sourceImageFrame: convertedStartingFrame)
        
        var center = CGPoint()
        var transForm = CGAffineTransform()
        
        if state == .Start {
            let scaleX = convertedStartingFrame.size.width / convertedEndingFrame.size.width
            let scaleY = convertedStartingFrame.size.height / convertedEndingFrame.size.height
            transForm = CGAffineTransformMakeScale(scaleX, scaleY)
            center = CGPointMake(CGRectGetMidX(convertedStartingFrame), CGRectGetMidY(convertedStartingFrame));
        }
        else {
            transForm = CGAffineTransformIdentity
            center = CGPointMake(CGRectGetMidX(convertedEndingFrame), CGRectGetMidY(convertedEndingFrame))
        }
        
        transitionView.center = center
        transitionView.transform = transForm
    }

    func finishInteractiveTransition(cancelled: Bool, velocity: CGFloat) {
        guard let transitionContext = context else { return }
        
        guard let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
            toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey),
            containerView = transitionContext.containerView()
            else { return }
        
        let fromView = fromVC.view
        let toView = toVC.view
        
        UIView.animateWithDuration(springCompletionSpeed, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: velocity, options: [], animations: { 
            let state = cancelled == true ? URBNCarouselTransitionState.Start : URBNCarouselTransitionState.End
            self.restoreTransitionViewToState(state, context: transitionContext)
            }) { (finished) in
                guard let ctx = self.context else { return }
                self.finishTransition(withContext: ctx)
                ctx.cancelInteractiveTransition()
                ctx.completeTransition(!cancelled)
        }
        
        UIView.animateWithDuration(completionSpeed) { 
            toView.alpha = cancelled ? 0.0: 1.0
            fromView.alpha = cancelled ? 1.0 : 0.0
        }
    }
    
    func finishTransition(withContext context: UIViewControllerContextTransitioning) {
        guard let fromVC = context.viewControllerForKey(UITransitionContextFromViewControllerKey),
            toVC = context.viewControllerForKey(UITransitionContextToViewControllerKey)
            else { return }
        
        let fromView = fromVC.view
        let toView = toVC.view
        
        guard let topFromVC = trueContextViewControllerFromContext(context, key: UITransitionContextFromViewControllerKey) as? URBNSwCarouselTransitioning, topToVC = trueContextViewControllerFromContext(context, key: UITransitionContextToViewControllerKey) as? URBNSwCarouselTransitioning else {
            print("Warning : make sure  all VC's being passed in conform to the URBNSwCarouselTransitioning protocol")
            return }
        
        topFromVC.didEndGalleryTransitionWithImageView?(transitionView, isToVC: false)
        topToVC.didEndGalleryTransitionWithImageView?(transitionView, isToVC: true)
        
        transitionView.removeFromSuperview()
        startScale = -1
        fromView.alpha = 1
        toView.alpha = 1
        fromVC.view = fromView
        toVC.view = toView
        interactive = false
    }
    
    func trueContextViewControllerFromContext(transitionContext: UIViewControllerContextTransitioning, key: String) -> UIViewController? {
        
        guard var vc = transitionContext.viewControllerForKey(key) else { return nil }
        
        if !vc.conformsToProtocol(URBNSwCarouselTransitioning) {
            vc = sourceViewController
        }
        
        if let topVC = vc.navigationController?.topViewController {
            vc = topVC
        }
        
        return vc
    }
    
    // MARK: UIViewControllerAnimatedTransitioning - Non-Interactive
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
            toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
            else { return }
        
        let fromView = fromVC.view
        let toView = toVC.view
        
        guard let topToVC = trueContextViewControllerFromContext(transitionContext, key: UITransitionContextToViewControllerKey) as? URBNSwCarouselTransitioning else { return }
        
        prepareForTransitionWithContext(transitionContext)
        
        let duration = transitionDuration(transitionContext)
        
        UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
            fromView.alpha = 0.0
            toView.alpha = 1.0
            self.restoreTransitionViewToState(.End, context: transitionContext)
            topToVC.configureAnimatingTransitionImageView?(self.transitionView)
            
            }) { (finished) in
            self.finishTransition(withContext: transitionContext)
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
    }
    
    // MARK: UIViewControllerInteractiveTransitioning
    public func startInteractiveTransition(transitionContext: UIViewControllerContextTransitioning) {
        context = transitionContext
        prepareForTransitionWithContext(transitionContext)
    }
    
    func updateWithPercent(percent: CGFloat) {
        guard let ctx = context else { return }
        ctx.updateInteractiveTransition(percent)
        guard let fromVC = ctx.viewControllerForKey(UITransitionContextFromViewControllerKey),
            toVC = ctx.viewControllerForKey(UITransitionContextToViewControllerKey)
            else { return }
        
        let fromView = fromVC.view
        let toView = toVC.view
        
        fromView.alpha = 1 - percent
        toView.alpha = percent
    }
    
    // MARK: UIViewControllerTransitioningDelegate
    public func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        sourceViewController = source
        return self
    }
    
    public func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    public func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactive == true ? self : nil
    }

    public func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactive == true ? self : nil
    }
    
    func registerInteractiveGestures(withView view: UIView, interactionBeganClosure:(controller: URBNSwCarouselTransitionController, view: UIView) -> Void) {
        if let gestures = view.gestureRecognizers {
            for gesture in gestures {
                view.removeGestureRecognizer(gesture)
            }
        }
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        pan.delegate = self
        view.addGestureRecognizer(pan)
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch))
        pinch.delegate = self
        view.addGestureRecognizer(pinch)
        
        let rotation = UIRotationGestureRecognizer(target: self, action: #selector(handleRotation))
        rotation.delegate = self
        view.addGestureRecognizer(rotation)
        
        viewInteractionBlocks[view] = interactionBeganClosure
        viewPinchTransitionGestureRecognizers[view] = pinch
    }
    
    func handlePinch(pinch: UIPinchGestureRecognizer) {
        guard let view = pinch.view else { return }
        let scale = pinch.scale
        switch pinch.state {
        case .Began:
            let closure = viewInteractionBlocks[view]
            closure?(controller: self, view: view)
        case .Changed:
            if startScale < 0 {
                startScale = scaleForTransForm(transitionView.transform).width
            }
            transitionView.transform = CGAffineTransformScale(transitionView.transform, scale, scale)
            let percent = transitionViewPercentScaledForStartScale(startScale)
            pinch.scale = 1
            updateWithPercent(percent)
        case .Ended, .Cancelled:
            let percent = transitionViewPercentScaledForStartScale(startScale)
            let cancelled = percent < 0.4
            finishInteractiveTransition(cancelled, velocity: pinch.velocity)
        case .Possible, .Failed:
            return
        }
    }

    func handlePan(gesture: UIPanGestureRecognizer) {
        guard let ctx = context, containerView = ctx.containerView() else { return }
        let translation = gesture.translationInView(containerView)
        transitionView.center = CGPointMake(transitionView.center.x + translation.x, transitionView.center.y + translation.y);
        gesture.setTranslation(CGPointZero, inView: containerView)
    }

    func handleRotation(rotate: UIRotationGestureRecognizer) {
        guard let ctx = context else { return }
        let rotation = rotate.rotation
        transitionView.transform = CGAffineTransformRotate(transitionView.transform, rotation)
        rotate.rotation = 0
    }
    
    // MARK: UIGestureRecognizerDelegate
    public func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let view = gestureRecognizer.view else { return false }
        let pinch = viewPinchTransitionGestureRecognizers[view]
        let pinchStarted = pinch?.state != UIGestureRecognizerState.Possible
        let isPinch = gestureRecognizer == pinch
        
        var shouldBeginTransition = true
        if let del = interactiveDelegate where isPinch && !pinchStarted {
            let scale = pinch?.scale
            guard scale != 1 else { return false }
            let direction = scale > 1 ? TranstionDirection.ScaleUp : TranstionDirection.ScaleDown
            shouldBeginTransition = del.shouldBeginInteractiveTransitionWithView!(view, direction: direction)
        }
        
        if isPinch && !pinchStarted && shouldBeginTransition {
            interactive = true
        }
        
        let shouldBegin = shouldBeginTransition || (!isPinch && pinchStarted)
        return shouldBegin
    }
    
    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    // MARK: Convenience
    func prepareForTransitionWithContext(context: UIViewControllerContextTransitioning) {
        guard let fromVC = context.viewControllerForKey(UITransitionContextFromViewControllerKey),
            toVC = context.viewControllerForKey(UITransitionContextToViewControllerKey),
            containerView = context.containerView()
            else { return }
        let fromView = fromVC.view
        let toView = toVC.view
        
        guard let topFromVC = trueContextViewControllerFromContext(context, key: UITransitionContextFromViewControllerKey) as? URBNSwCarouselTransitioning, topToVC = trueContextViewControllerFromContext(context, key: UITransitionContextToViewControllerKey) as? URBNSwCarouselTransitioning else {
            print("Warning : make sure  all VC's being passed in conform to the URBNSwCarouselTransitioning protocol")
            return }
        
        toView.frame = containerView.bounds
        toView.setNeedsLayout()
        toView.layoutIfNeeded()
        
        // create view for animation
        let image = topFromVC.imageForGalleryTransition()
        let convertedStartingFrame = topFromVC.fromImageFrameForGalleryTransitionWithContainerView(containerView)
        let convertedEndingFrame = topToVC.toImageFrameForGalleryTransitionWithContainerView(containerView, sourceImageFrame: convertedStartingFrame)
        
        // Set the view's frame to the final dimensions and transform it down to match starting dimensions.
        transitionView = UIImageView.init(frame: convertedEndingFrame)
        transitionView.contentMode = .ScaleToFill
        transitionView.image = image
        
        let scaleX = convertedStartingFrame.width / convertedEndingFrame.width
        let scaleY = convertedStartingFrame.height / convertedEndingFrame.height
        
        let transform = CGAffineTransformMakeScale(scaleX, scaleY)
        transitionView.transform = transform
        transitionView.center = CGPointMake(CGRectGetMidX(convertedStartingFrame), CGRectGetMidY(convertedStartingFrame))
        
        containerView.addSubview(toView)
        containerView.addSubview(fromView)
        containerView.addSubview(transitionView)
        
        topFromVC.willBeginGalleryTransitionWithImageView?(transitionView, isToVC: false)
        topToVC.willBeginGalleryTransitionWithImageView?(transitionView, isToVC: true)
    }
    
    func transitionViewPercentScaledForStartScale(startScale: CGFloat) -> CGFloat {
        let scale = scaleForTransForm(transitionView.transform)
        let percent = scale.width - startScale / 1 - startScale
        return percent
    }
    
    func scaleForTransForm(transform: CGAffineTransform) -> CGSize {
        let xScale = sqrt(transform.a * transform.a + transform.c * transform.c)
        let yScale = sqrt(transform.b * transform.b + transform.d * transform.d)
        
        return CGSizeMake(xScale, yScale)
    }
}
