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

    weak var delegate: SettingsViewControllerDelegate?

    var profile: Profile? {
        didSet {
            guard let profile = profile else { return }
            updateUIComponents(with: profile)
        }
    }

    private var selectedImage: UIImage?

    private lazy var spinner: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.color = .black
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private lazy var spinnerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.alpha = 0.6
        view.isHidden = true
        return view
    }()

    private lazy var viewModel: EditProfileViewModel = {
        let vm = EditProfileViewModel()
        return vm
    }()

    private lazy var profilePictureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 60
        imageView.backgroundColor = .darkGray
        imageView.contentMode = .scaleAspectFill
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
        button.addTarget(self, action: #selector(changePhotoButtonTapped), for: .touchUpInside)
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

    private lazy var createdInfo: InfoView = {
        let view = InfoView()
        view.image = UIImage(named: "createdAtIcon")
        view.titleView = "30 Ağustos 2023"
        return view
    }()

    private lazy var roleInfo: InfoView = {
        let view = InfoView()
        view.image = UIImage(named: "roleIcon")
        view.titleView = "Admin"
        return view
    }()

    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        return stackView
    }()

    private lazy var fullNameView: TravioUIView = {
        let view = TravioUIView()
        view.placeholderText = "Enter your new full name"
        view.titleView = "Full Name"
        return view
    }()

    private lazy var emailView: TravioUIView = {
        let view = TravioUIView()
        view.placeholderText = "Enter your new email"
        view.titleView = "Email"
        return view
    }()

    private lazy var saveButton: TravioButton = {
        let button = TravioButton()
        button.setTitle("Save", for: .normal)
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var componentsView: ComponentsView = .init()

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    // MARK: - Private Methods

    private func updateUIComponents(with profile: Profile) {
        let imageUrl = URL(string: profile.ppUrl)
        profilePictureImageView.kf.setImage(with: imageUrl, placeholder: UIImage(named: "imageNotFound"))
        createdInfo.titleView = profile.createdAt.formatISO8601ToCustomFormat()
        roleInfo.titleView = profile.role
        fullNameView.textField.text = profile.fullName
        emailView.textField.text = profile.email
        fullNameLabel.text = profile.fullName
    }

    private func setupView() {
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = AppColor.primary.color

        infoStackView.addArrangedSubviews(createdInfo, roleInfo)

        view.addSubviews(titleLabel,
                         dismissButton,
                         componentsView,
                         spinnerView,
                         spinner)

        componentsView.addSubviews(profilePictureImageView,
                                   fullNameLabel,
                                   changePhotoButton,
                                   infoStackView,
                                   fullNameView,
                                   emailView,
                                   saveButton)

        setupLayout()
    }

    private func setupLayout() {
        spinnerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        spinner.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        componentsView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(36)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12)
            make.leading.equalToSuperview().offset(24)
        }

        dismissButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
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
            make.top.equalTo(changePhotoButton.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }

        roleInfo.snp.makeConstraints { make in
            make.height.equalTo(52)
        }

        createdInfo.snp.makeConstraints { make in
            make.height.equalTo(52)
        }

        infoStackView.snp.makeConstraints { make in
            make.top.equalTo(fullNameLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
        }

        fullNameView.snp.makeConstraints { make in
            make.top.equalTo(infoStackView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(74)
        }

        emailView.snp.makeConstraints { make in
            make.top.equalTo(fullNameView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(74)
        }

        saveButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-24)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(54)
        }
    }

    private func showActivityIndicator() {
        spinnerView.isHidden = false
        spinner.startAnimating()
        view.isUserInteractionEnabled = false
    }

    private func hideActivityIndicator() {
        spinnerView.isHidden = true
        spinner.stopAnimating()
        view.isUserInteractionEnabled = true
    }

    // MARK: - Actions

    @objc func saveButtonTapped() {
        guard let fullName = fullNameView.textField.text,
              let email = emailView.textField.text,
              let ppUrl = profile?.ppUrl else { return }

        let updatedProfile = ProfileInput(fullName: fullName,
                                          email: email,
                                          ppUrl: ppUrl)

        showActivityIndicator()
        if let selectedImage = selectedImage {
            viewModel.saveProfile(image: selectedImage, input: updatedProfile) { [weak self] success in
                if success {
                    self?.hideActivityIndicator()
                    self?.delegate?.didFetchProfile()
                    self?.dismiss(animated: true)
                    self?.delegate?.didShowAlert()
                } else {
                    self?.hideActivityIndicator()
                }
            }
        } else {
            viewModel.saveProfile(image: nil, input: updatedProfile) { [weak self] success in
                if success {
                    self?.hideActivityIndicator()
                    self?.delegate?.didFetchProfile()
                    self?.dismiss(animated: true)
                    self?.delegate?.didShowAlert()
                } else {
                    self?.hideActivityIndicator()
                }
            }
        }
    }

    @objc func dismissButtonTapped() {
        dismiss(animated: true)
    }

    @objc func changePhotoButtonTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
}

// MARK: - Extensions

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            selectedImage = pickedImage
            profilePictureImageView.image = pickedImage
        }

        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
