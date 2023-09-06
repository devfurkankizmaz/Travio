//
//  UIStackView+Extension.swift
//  Travio
//
//  Created by Furkan Kızmaz on 6.09.2023.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach {
            self.addArrangedSubview($0)
        }
    }
}
