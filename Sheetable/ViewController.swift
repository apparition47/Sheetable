//
//  ViewController.swift
//  Sheetable
//
//  Created by Aaron Lee on 2019/07/30.
//  Copyright © 2019 One Fat Giraffe. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let vc = segue.destination as? AnotherViewController {
            vc.setTransitioningDelegate()
        }
    }
    
}
