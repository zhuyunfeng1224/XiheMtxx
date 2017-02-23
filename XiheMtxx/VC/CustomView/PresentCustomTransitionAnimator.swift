//
//  PresentCustomTransitionAnimator.swift
//  XiheMtxx
//
//  Created by echo on 2017/2/23.
//  Copyright © 2017年 羲和. All rights reserved.
//

import UIKit

class PresentCustomTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewController(forKey: .from)
        let toViewController = transitionContext.viewController(forKey: .to)
        
        let containerView = transitionContext.containerView
        var fromView: UIView!
        var toView: UIView!
        
        if transitionContext.responds(to: #selector(UIViewControllerContextTransitioning.view(forKey:))) {
            fromView = transitionContext.view(forKey: .from)
            toView = transitionContext.view(forKey: .to)
        }
        else {
            fromView = fromViewController?.view
            toView = toViewController?.view
        }
        
        fromView.frame = transitionContext.initialFrame(for: fromViewController!)
        toView.frame = transitionContext.finalFrame(for: toViewController!)
        
//        fromView.alpha = 1.0
//        toView.alpha = 0.0
        
        containerView.addSubview(toView)
        
        let transitionDuration = self.transitionDuration(using: transitionContext)
        UIView.animate(withDuration: transitionDuration, animations: { 
//            fromView.alpha = 0.0
//            toView.alpha = 1.0
        }) { (finished) in
            let wasCancel = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!wasCancel)
        }
    }
    
}
