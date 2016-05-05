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


public class URBNSwCarouselTransitionController: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate, UIGestureRecognizerDelegate {
    private(set) var interactive = false
    private var viewInteractionBlocks = [UIView: URBNCarouselViewInteractionBeganClosure]()
    private var viewPinchTransitionGestureRecognizers = [UIView: UIPinchGestureRecognizer]()
    private weak var context: UIViewControllerContextTransitioning?
    private var transitionView = UIImageView()
    private var originalSelectedCellFrame = CGRectZero
    private var startScale: CGFloat = -1.0
    private var springCompletionSpeed: Double = 0.6
    private var completionSpeed: Double = 0.2
    private var sourceViewController = UIViewController()

    public weak var interactiveDelegate: URBNSwCarouselInteractiveDelegate?

    public func trueContextViewControllerFromContext(transitionContext: UIViewControllerContextTransitioning, key: String) -> UIViewController? {
        
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
        
        let duration = transitionDuration(transitionContext)
        
        UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
            fromView.alpha = 0.0
            toView.alpha = 1.0
            topToVC.configureAnimatingTransitionImageView?(self.transitionView)
            
            }) { (finished) in
            self.startScale = -1
            self.interactive = false
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
    }
    
    // MARK: UIViewControllerTransitioningDelegate
    public func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        return URBNPresentationController(presentedViewController: presented, presentingViewController: source)
    }
    
    public func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        sourceViewController = source
        return self
    }
    
    public func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

}
