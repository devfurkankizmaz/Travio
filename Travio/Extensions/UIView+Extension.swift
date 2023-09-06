//
//  UIView+Extension.swift
//  Travio
//
//  Created by Furkan Kızmaz on 6.09.2023.
//

import UIKit

extension UIView {
    func addSubviews(_ view: UIView...) {
        view.forEach { v in
            self.addSubview(v)
        }
    }
}
