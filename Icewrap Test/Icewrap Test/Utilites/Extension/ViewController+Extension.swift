//
//  ViewController+Extension.swift
//  Icewrap Test
//

import Foundation
import UIKit

extension UIViewController {
    
    static func instantiateFromStoryboard(storyboardName: String = "Main") -> Self {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! Self
    }
    
    private var loadingIndicatorTag: Int { return 999999 }
    
    func showLoadingIndicator() {
        if let _ = view.viewWithTag(loadingIndicatorTag) as? UIActivityIndicatorView {
            return
        }
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.center = view.center
        indicator.color = .black
        indicator.tag = loadingIndicatorTag
        indicator.hidesWhenStopped = true
        view.addSubview(indicator)
        indicator.startAnimating()
    }

    func hideLoadingIndicator() {
        if let indicator = view.viewWithTag(loadingIndicatorTag) as? UIActivityIndicatorView {
            indicator.stopAnimating()
            indicator.removeFromSuperview()
        }
    }
    
    func showAlert(_ title: String? = "IceWrap", message: String, buttonTitle: String = "OK", completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: buttonTitle, style: .default) { _ in
            completion?()
        }
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
}
