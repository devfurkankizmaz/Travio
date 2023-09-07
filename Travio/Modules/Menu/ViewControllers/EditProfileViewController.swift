//
//  EditProfileViewController.swift
//  Travio
//
//  Created by Furkan Kızmaz on 7.09.2023.
//

import Kingfisher
import SnapKit
import UIKit

class EditProfileViewController: UIViewController {
    // MARK: - Properties

    private lazy var profilePictureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 60
        imageView.backgroundColor = .darkGray
        imageView.image = UIImage(named: "imageNotFound")
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var fullNameLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.poppinsSemiBold.withSize(24)
        label.textAlignment = .center
        label.text = "John Doe"
        label.textColor = AppColor.secondary.color
        return label
    }()

    private lazy var changePhotoButton: UIButton = {
        let button = UIButton()
        button.setTitle("Change Photo", for: .normal)
        button.titleLabel?.font = AppFont.poppinsRegular.withSize(12)
        // button.addTarget(self, action: #selector(editProfileButtonTapped), for: .touchUpInside)
        let color = UIColor(cgColor: #colorLiteral(red: 0, green: 0.7667202353, blue: 0.9408947229, alpha: 1))
        button.setTitleColor(color, for: .normal)
        return button
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.poppinsSemiBold.withSize(32)
        label.text = "Edit Profile"
        label.textColor = .white
        return label
    }()

    private lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "closeButton"), for: .normal)
        button.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var componentsView: ComponentsView = .init()

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    // MARK: - Private Methods

    private func setupView() {
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = AppColor.primary.color

        view.addSubviews(titleLabel, dismissButton, componentsView)
        componentsView.addSubviews(profilePictureImageView, fullNameLabel, changePhotoButton)

        setupLayout()
    }

    private func setupLayout() {
        componentsView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(36)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
            make.leading.equalToSuperview().offset(24)
        }

        dismissButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.width.height.equalTo(20)
        }

        profilePictureImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(24)
            make.width.height.equalTo(120)
        }

        changePhotoButton.snp.makeConstraints { make in
            make.top.equalTo(profilePictureImageView.snp.bottom)
            make.centerX.equalToSuperview()
        }

        fullNameLabel.snp.makeConstraints { make in
            make.top.equalTo(changePhotoButton.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
    }

    // MARK: - Actions

    @objc func dismissButtonTapped() {
        dismiss(animated: true)
    }
}

// MARK: - Extensions
