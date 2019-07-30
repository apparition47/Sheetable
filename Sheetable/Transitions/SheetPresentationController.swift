//
//  SheetPresentationController.swift
//  Genie
//
//  Created by Aaron Lee on 2019/07/26.
//  Copyright © 2019 One Fat Giraffe. All rights reserved.
//

import UIKit

private let globalScaleFactor: CGFloat = 0.9

private enum SheetModalState {
    case adjustedOnce
    case normal
}


class SheetPresentationController: UIPresentationController {
    private let panGestureRecognizer = UIPanGestureRecognizer()
    private let tapGestureRecognizer = UITapGestureRecognizer()
    private var direction: CGFloat = 0
    private var state: SheetModalState = .normal
    
    var screenPercentage: CGFloat = 0.8
    var heightCoverage: CGFloat?
    
    private var closeImageView: UIImageView?
    private var blurEffectView: UIVisualEffectView? {
        return presentingViewController.view.subviews.first {$0 is UIVisualEffectView} as? UIVisualEffectView
    }
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        tapGestureRecognizer.cancelsTouchesInView = false
        
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        panGestureRecognizer.addTarget(self, action: #selector(onPan(pan:)))
        presentedViewController.view.addGestureRecognizer(panGestureRecognizer)
        presentedViewController.view.layer.cornerRadius = 12
        presentedViewController.view.layer.masksToBounds = true
    }
    
    @objc func closeIfTappedOutside() {
        let tappedOutsidePresentedView = tapGestureRecognizer.location(in: presentedViewController.view).y < 0
        if tappedOutsidePresentedView {
            presentedViewController.dismiss(animated: true)
        }
    }
    
    @objc func onPan(pan: UIPanGestureRecognizer) {
        let endPoint = pan.translation(in: pan.view?.superview)
        switch pan.state {
        case .began:
            presentedView!.frame.size.height = containerView!.frame.height
        case .changed:
            let velocity = pan.velocity(in: pan.view?.superview)
            switch state {
            case .normal:
                if let heightCoverage = heightCoverage {
                    presentedView!.frame.origin.y = max(endPoint.y + containerView!.frame.height - heightCoverage, (containerView!.frame.height - heightCoverage) * 0.95)
                    setCloseImageViewFrame(yPos: presentedView!.frame.origin.y)
                } else {
                    presentedView!.frame.origin.y = endPoint.y + containerView!.frame.height * (1 - screenPercentage)
                }
            case .adjustedOnce:
                presentedView!.frame.origin.y = endPoint.y
            }
            direction = velocity.y
            
            // animate bg
            let scaleFactor = globalScaleFactor + 1/(UIScreen.main.bounds.height/endPoint.y) * (1-globalScaleFactor)
            blurEffectView?.alpha = scaleFactor
            closeImageView?.alpha = scaleFactor
        case .ended:
            if direction < 0 {
                changeScale(to: .normal)
            } else {
                if state == .adjustedOnce {
                    changeScale(to: .normal)
                } else {
                    presentedViewController.dismiss(animated: true)
                }
            }
        default: break
        }
    }
    
    // MARK: - UIPresentationController
    override var frameOfPresentedViewInContainerView: CGRect {
        if let heightCoverage = heightCoverage {
            return CGRect(
                x: 0, y: containerView!.bounds.height - heightCoverage,
                width: containerView!.bounds.width, height: heightCoverage
            )
        } else {
            return CGRect(
                x: 0, y: containerView!.bounds.height * (1 - screenPercentage),
                width: containerView!.bounds.width, height: containerView!.bounds.height * screenPercentage
            )
        }
    }
    
    override func presentationTransitionWillBegin() {
        tapGestureRecognizer.addTarget(self, action: #selector(closeIfTappedOutside))
        containerView?.addGestureRecognizer(tapGestureRecognizer)
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0
        blurEffectView.frame = presentingViewController.view.frame
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        presentingViewController.view.addSubview(blurEffectView)
        
        if let heightCoverage = heightCoverage {
            closeImageView = UIImageView(image: UIImage(named: "Close"))
            containerView?.addSubview(closeImageView!)
            closeImageView!.alpha = 0
            setCloseImageViewFrame(yPos: presentingViewController.view.frame.maxY - heightCoverage)
        }
        
        guard let coordinator = presentingViewController.transitionCoordinator else { return }
        presentingViewController.view.layer.masksToBounds = true
        coordinator.animate(alongsideTransition: { [unowned self] _ in
            self.blurEffectView?.alpha = globalScaleFactor
            self.closeImageView?.alpha = globalScaleFactor
        })
    }
    
    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentingViewController.transitionCoordinator else { return }
        self.presentingViewController.view.layer.masksToBounds = false
        coordinator.animate(alongsideTransition: { [unowned self] _ in
            self.blurEffectView?.alpha = 0
            self.closeImageView?.alpha = 0
        })
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)
        if completed {
            blurEffectView?.removeFromSuperview()
            closeImageView?.removeFromSuperview()
        }
    }
    
    // MARK: - Helpers
    private func setCloseImageViewFrame(yPos: CGFloat) {
        let imageWidth: CGFloat = 16
        let padding: CGFloat = 18
        closeImageView?.frame = CGRect(
            x: padding,
            y: yPos - imageWidth - padding,
            width: imageWidth,
            height: imageWidth
        )
    }
    
    private func changeScale(to state: SheetModalState) {
        blurEffectView?.alpha = globalScaleFactor
        closeImageView?.alpha = globalScaleFactor
        
        guard let presentedView = presentedView, let containerView = self.containerView else { return }
        UIView.animate(
            withDuration: 0.8,
            delay: 0,
            usingSpringWithDamping: 0.9,
            initialSpringVelocity: 0.6,
            options: .curveEaseInOut,
            animations: {
                let containerFrame = containerView.frame
                if let heightCoverage = self.heightCoverage {
                    presentedView.frame = CGRect(
                        origin: CGPoint(x: 0, y: containerFrame.height - heightCoverage),
                        size: CGSize(width: containerFrame.width, height: heightCoverage)
                    )
                } else {
                    presentedView.frame = CGRect(
                        origin: CGPoint(
                            x: 0,
                            y: containerFrame.height * (1 - self.screenPercentage)
                        ),
                        size: CGSize(
                            width: containerFrame.width,
                            height: containerFrame.height * self.screenPercentage
                        )
                    )
                }
                
                self.setCloseImageViewFrame(yPos: presentedView.frame.origin.y)
            },
            completion: { [weak self] _ in
                self?.state = state
            }
        )
    }
}
