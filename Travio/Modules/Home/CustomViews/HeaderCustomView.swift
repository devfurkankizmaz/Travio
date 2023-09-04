//
//  HeaderCustomView.swift
//  Travio
//
//  Created by Furkan Kızmaz on 2.09.2023.
//

import Foundation
import SnapKit
import UIKit

class HeaderCustomView: UIView {
    var titleView: String = "Default" {
        didSet {
            updateLabel()
        }
    }

    var insets: UIEdgeInsets

    init(insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)) {
        self.insets = insets
        super.init(frame: .zero)
        setupViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updateLabel() {
        label.text = titleView
    }

    private let label: UILabel = {
        let label = UILabel()
        label.textColor = AppColor.secondary.color
        label.font = AppFont.poppinsMedium.withSize(20)
        label.text = "Default"
        return label
    }()

    public var button: UIButton = {
        let button = UIButton()
        button.setTitle("See all", for: .normal)
        button.setTitleColor(AppColor.primary.color, for: .normal)
        button.titleLabel?.font = AppFont.poppinsMedium.withSize(14)
        return button
    }()

    private func setupViews() {
        backgroundColor = .clear
        addSubviews(label, button)
        setupLayouts()
    }

    private func setupLayouts() {
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.centerY.equalToSuperview()
        }

        button.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
    }
}
