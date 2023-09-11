//
//  CustomProfileView.swift
//  Travio
//
//  Created by Muhammet on 10.09.2023.
//

import Foundation
import UIKit

class CustomProfileView: UIView {
    var labelView: String = "Default" {
        didSet {
            updateLabel()
        }
    }

    private func updateLabel() {
        label.text = labelView
    }

    private let label: UILabel = {
        let label = UILabel()
        label.textColor = AppColor.secondary.color
        label.font = AppFont.poppinsMedium.withSize(12)
        label.text = "Default"
        return label
    }()
    
    public let leftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

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

    private func setupViews() {
        backgroundColor = .white
        clipsToBounds = true
        layer.cornerRadius = 16
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner]
        addShadow()
        addSubviews(label, leftImageView)
        setupConstraints()
    }

    func addShadow() {
        layer.shadowRadius = 8
        layer.shadowOpacity = 0.15
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowColor = AppColor.secondary.color.cgColor
        layer.masksToBounds = false
    }

    private func setupConstraints() {
        leftImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(12)
            make.width.equalTo(20)
        }
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalTo(leftImageView.snp.leading).offset(32)
        }
    }
}

