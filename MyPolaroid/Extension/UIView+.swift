//
//  UIView+.swift
//  MyPolaroid
//
//  Created by 강석호 on 7/23/24.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach {
            self.addSubview($0)
        }
    }
}
