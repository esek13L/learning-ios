//
//  UIAnimatable.swift
//  core
//
//  Created by Esekiel Surbakti on 06/06/21.
//

import Foundation
import MBProgressHUD

public protocol UIAnimatable where Self: UIViewController {
    func showLoadingAnimation()
    func hideLoadingAnimation()
}

public extension UIAnimatable {
    
    func showLoadingAnimation() {
        DispatchQueue.main.async {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        
    }
    
    func hideLoadingAnimation() {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
}
