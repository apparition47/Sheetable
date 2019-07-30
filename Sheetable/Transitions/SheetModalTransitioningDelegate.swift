//
//  SheetModalTransitioningDelegate.swift
//  Genie
//
//  Created by Aaron Lee on 2019/07/26.
//  Copyright © 2019 One Fat Giraffe. All rights reserved.
//

import UIKit

class SheetModalTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {

    // MARK: - UIViewControllerTransitioningDelegate
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SheetModalTransitionAnimator()
    }
    
    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?, source: UIViewController
        ) -> UIPresentationController? {
        let presentationController = SheetPresentationController(
            presentedViewController: presented,
            presenting: presenting
        )
        if let sheetable = presented as? Sheetable {
//            presentationController.screenPercentage = sheetable.screenPercentage
            presentationController.heightCoverage = sheetable.height
        }
        return presentationController
    }
}
