//
//  URBNPresentationController.swift
//  Pods
//
//  Created by Kevin Taniguchi on 4/30/16.
//
//

import UIKit

class URBNPresentationController: UIPresentationController {
    override func presentationTransitionWillBegin() {
//        print("$$$$$$$$$$$$$")
//        print("source \(presentingViewController)")
//        print("destination \(presentedViewController)")
//        print("container \(containerView)")
//        print("$$$$$$$$$$$$$\n")
    }
    
    override func presentationTransitionDidEnd(completed: Bool) {
//        print("&&&&&&&&&&")
//        print("source \(presentingViewController)")
//        print("destination \(presentedViewController)")
//        print("container \(containerView)")
//        print("&&&&&&&&&&\n")
    }
    
    override func dismissalTransitionWillBegin() {
//        print("**********")
//        print("source \(presentingViewController)")
//        print("destination \(presentedViewController)")
//        print("container \(containerView)")
//        print("**********\n")
    }
    
    override func dismissalTransitionDidEnd(completed: Bool) {
//        print("**********")
//        print("source \(presentingViewController)")
//        print("destination \(presentedViewController)")
//        print("container \(containerView)")
//        print("**********\n")
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
    }
}
