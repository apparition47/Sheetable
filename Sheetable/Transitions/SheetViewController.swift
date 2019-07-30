//
//  SheetViewController.swift
//  Genie
//
//  Created by Aaron Lee on 2019/07/26.
//  Copyright © 2019 One Fat Giraffe. All rights reserved.
//

import UIKit

private var sheetableDelegatePtr: UInt8 = 0

protocol Sheetable: AnyObject {
    var height: CGFloat { get }
    func setTransitioningDelegate()
}

extension Sheetable where Self: UIViewController {
    var customTransitioningDelegate: SheetModalTransitioningDelegate? {
        get {
            return objc_getAssociatedObject(self, &sheetableDelegatePtr) as? SheetModalTransitioningDelegate
        }
        set {
            objc_setAssociatedObject(self, &sheetableDelegatePtr, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var height: CGFloat {
        get {
            return 300
        }
    }
    
    func setTransitioningDelegate() {
        customTransitioningDelegate = SheetModalTransitioningDelegate()
        transitioningDelegate = customTransitioningDelegate
        modalPresentationStyle = .custom
    }
}
