//
//  UIViewController+.swift
//  MyPolaroid
//
//  Created by 강석호 on 7/28/24.
//

import UIKit

extension UIViewController {

    func showAlert(title: String, message: String, ok: String,  completionHandler: @escaping (UIAlertAction) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let ok = UIAlertAction(title: ok, style: .default, handler: completionHandler)
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
}
