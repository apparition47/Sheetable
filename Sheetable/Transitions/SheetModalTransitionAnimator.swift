//
//  SheetModalTransitionAnimator.swift
//  Genie
//
//  Created by Aaron Lee on 2019/07/26.
//  Copyright © 2019 One Fat Giraffe. All rights reserved.
//

import UIKit

class SheetModalTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    @objc func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let from = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
                from!.view.frame.origin.y = 800
            },
            completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        )
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
}
