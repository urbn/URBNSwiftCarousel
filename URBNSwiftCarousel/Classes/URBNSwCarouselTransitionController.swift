//
//  URBNSwCarouselTransitionController.swift
//  Pods
//
//  Created by Kevin Taniguchi on 4/25/16.
//
//


/**
 Animation controller built to handle transitions between two images in separate view controllers.
 By default, this class supports non-interactive transitions. To enable interactive transitions, register
 a view for them using the registration method provided.
 
 This class implements the UIViewControllerTransitioningDelegate protocol. As a consumer, you only need to implement
 the URBNCarouselTransitioning protocol.
 
 For the time being, this controller only supports transitions between images.
 */


public class URBNSwCarouselTransitionController: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    private weak var context: UIViewControllerContextTransitioning?
    private var transitionView = UIImageView()
    private var originalSelectedCellFrame = CGRectZero
    private var springCompletionSpeed: CGFloat = 0.7
    private var sourceViewController: UIViewController?
    public var presentationController: URBNPresentationController?
    
    // MARK: UIViewControllerAnimatedTransitioning Delegate Methods - Non-Interactive
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
        
        let duration = transitionDuration(transitionContext)
        
        UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: springCompletionSpeed, initialSpringVelocity: 0, options: [], animations: {
            fromView.alpha = 0.0
            toView.alpha = 1.0
            if let vc = topToVC as? URBNSwCarouselTransitioningImageView {
                vc.configureAnimatingTransitionImageView(self.transitionView)
            }
            
            }) { (finished) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
    }
    
    // MARK: UIViewControllerTransitioningDelegate methods
    public func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        presentationController = URBNPresentationController(presentedViewController: presented, presentingViewController: source)
        return presentationController
    }
    
    public func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        sourceViewController = source
        return self
    }
    
    public func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    // MARK: Convenience
    /** This method finds the true view controller for a given context's key - sometimes iOS will pick the rootview controller or navigation controller of a presenting view controller. Override if necessary if you find you are having trouble accessing the correct view controllers as source or destination.
    */
    public func trueContextViewControllerFromContext(transitionContext: UIViewControllerContextTransitioning, key: String) -> UIViewController? {
        guard var vc = transitionContext.viewControllerForKey(key) else { return nil }
        
        if let topVC = vc.navigationController?.topViewController {
            vc = topVC
        }
        else {
            guard let capturedVC = sourceViewController else { return nil }
            vc = capturedVC
        }
        
        return vc
    }

}
