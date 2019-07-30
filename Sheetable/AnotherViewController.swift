//
//  AnotherViewController.swift
//  Sheetable
//
//  Created by Aaron Lee on 2019/07/30.
//  Copyright © 2019 One Fat Giraffe. All rights reserved.
//

import UIKit

class AnotherViewController: UIViewController {
    @IBAction func cancelButtonTap(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension AnotherViewController: Sheetable {
    
}
