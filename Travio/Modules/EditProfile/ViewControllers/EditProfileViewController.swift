//
//  EditProfileViewController.swift
//  Travio
//
//  Created by Muhammet on 6.09.2023.
//

import UIKit
import SnapKit
import Alamofire
import Kingfisher

class EditProfileViewController: UIViewController {
    
    public var selectedImages: [UIImage] = []
    
    weak var profileUpdateDelegate: ProfileUpdateDelegate?
    
    private lazy var editProfileViewModel: EditProfileViewModel = {
        let viewModel = EditProfileViewModel()
        return viewModel
    }()
    
    private lazy var editProfileLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.poppinsSemiBold.withSize(32)
        label.text = "Edit Profile"
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return label
    }()
    
    private lazy var exitButton: UIButton = {
        let button = UIButton()
        let arrowImage = UIImage(named: "exit")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        button.setImage(arrowImage, for: .normal)
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var componentsView = ComponentsView()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "imageNotFound"))
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 60
        return imageView
    }()
    
    private lazy var changeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Change Photo", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.09019607843, green: 0.7529411765, blue: 0.9215686275, alpha: 1), for: .normal)
        button.titleLabel?.font = AppFont.poppinsRegular.withSize(12)
        button.addTarget(self, action: #selector(changeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Bruce Wills"
        label.font = AppFont.poppinsSemiBold.withSize(24)
        label.textColor = AppColor.secondary.color
        return label
    }()
    
    private lazy var dateView: CustomProfileView = {
        let view = CustomProfileView()
        view.leftImageView.image = UIImage(named: "date")
        view.labelView = "30 Agustos 2023"
        return view
    }()
    
    private lazy var roleView: CustomProfileView = {
        let view = CustomProfileView()
        view.leftImageView.image = UIImage(named: "role")
        view.labelView = "Admin"
        return view
    }()
    
    private lazy var fullNameView: TravioUIView = {
        let view = TravioUIView()
        view.placeholderText = "bilge_adam"
        view.titleView = "Full Name"
        return view
    }()

    private lazy var emailView: TravioUIView = {
        let view = TravioUIView()
        view.placeholderText = "bilge_adam"
        view.titleView = "Email"
        return view
    }()
    
    private lazy var saveButton: TravioButton = {
        let button = TravioButton()
        button.setTitle("Save", for: .normal)
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        getProfile()
    }
    
    @objc private func changeButtonTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    @objc private func backButtonTapped(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveButtonTapped() {
        editProfileViewModel.uploadImage(images: selectedImages) { success in
            if success{
                DispatchQueue.main.async { [self] in
                    guard let name = self.fullNameView.textField.text,
                          let email = self.emailView.textField.text,
                          let imageURL =  self.editProfileViewModel.urls.first else { return }
                    let params = ["full_name": name, "email": email, "pp_url": imageURL]
                    self.editProfileViewModel.putEditProfile(name: name, email: email, ppUrl: imageURL)
                    self.profileUpdateDelegate?.updateProfile(name: name, image: self.selectedImages.first)
                    
                }
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    private func getProfile() {
        editProfileViewModel.getProfile(callback: { success in
            if success {
                    guard let name = self.editProfileViewModel.profileInfos?.full_name,
                          let createdData = self.editProfileViewModel.profileInfos?.created_at,
                          let imageURL =  self.editProfileViewModel.profileInfos?.pp_url,
                          let role =  self.editProfileViewModel.profileInfos?.role else { return }
                    self.nameLabel.text = name
                self.dateView.labelView = createdData.formatISO8601ToCustomFormat()
                self.profileImageView.kf.setImage(with: URL(string: imageURL))
                    self.roleView.labelView = role
            }
        })
    }
    
    private func setupView() {
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = AppColor.primary.color
        view.addSubviews(editProfileLabel, exitButton, componentsView)
        componentsView.addSubviews(profileImageView, changeButton, nameLabel, dateView, roleView, fullNameView, emailView, saveButton)
        setupLayout()
    }

    private func setupLayout() {
        editProfileLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.equalToSuperview().offset(24)
        }
        exitButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(20)
            make.width.equalTo(20)
        }
        componentsView.snp.makeConstraints { make in
            make.top.equalTo(editProfileLabel.snp.bottom).offset(67)
            make.leading.trailing.bottom.equalToSuperview()
        }
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.centerX.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(120)
        }
        changeButton.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(7)
            make.centerX.equalToSuperview()
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(changeButton.snp.bottom).offset(7)
            make.centerX.equalToSuperview()
        }
        dateView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(21)
            make.leading.equalToSuperview().offset(24)
            make.width.equalTo(163)
            make.height.equalTo(52)
        }
        roleView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(21)
            make.trailing.equalToSuperview().offset(-24)
            make.width.equalTo(163)
            make.height.equalTo(52)
        }
        fullNameView.snp.makeConstraints { make in
            make.top.equalTo(dateView.snp.bottom).offset(19)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(74)
        }
        emailView.snp.makeConstraints { make in
            make.top.equalTo(fullNameView.snp.bottom).offset(11)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(74)
        }
        saveButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(54)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-18)
        }
    }
}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image =  info[.originalImage] as? UIImage {
        
            let selectedImageIndex = picker.view.tag
            if selectedImageIndex < selectedImages.count {
                selectedImages[selectedImageIndex] = image
            } else {
                selectedImages.append(image)
            }
            profileImageView.image = selectedImages.first
        }

        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
    }
}
