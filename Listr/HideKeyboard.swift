//
//  HideKeyboard.swift
//  Listr
//
//  Created by Hesham Saleh on 1/31/17.
//  Copyright © 2017 Hesham Saleh. All rights reserved.
//

import UIKit

//Keyboard dismissal extension.
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
