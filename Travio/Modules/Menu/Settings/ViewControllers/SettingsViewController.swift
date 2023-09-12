//
//  SettingsViewController.swift
//  Travio
//
//  Created by Furkan Kızmaz on 7.09.2023.
//


import Kingfisher
import SnapKit
import UIKit

protocol ProfileUpdateDelegate: AnyObject {
    func updateProfile(name: String, image: UIImage?)
}

class SettingsViewController: UIViewController {

    private lazy var settingsViewModel: SettingsViewModel = {
        let viewModel = SettingsViewModel()
        return viewModel
    }()

    private lazy var componentsView = ComponentsView()

    private lazy var settingsLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.poppinsSemiBold.withSize(36)
        label.text = "Settings"
        label.textColor = .white
        return label
    }()

    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "imageNotFound"))
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 60
        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Bruce Wills"
        label.font = AppFont.poppinsSemiBold.withSize(16)
        label.textColor = AppColor.secondary.color
        return label
    }()

    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.09019607843, green: 0.7529411765, blue: 0.9215686275, alpha: 1), for: .normal)
        button.titleLabel?.font = AppFont.poppinsRegular.withSize(12)
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton()
        let arrowImage = UIImage(named: "logoutIcon")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        button.setImage(arrowImage, for: .normal)
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        
        return button
    }()

    private lazy var settingsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.register(SettingsViewCell.self, forCellWithReuseIdentifier: "settingsCell")
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        getProfile()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
        self.tabBarController?.tabBar.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func getProfile() {
        settingsViewModel.getProfile(callback: { success in
            if success {
                DispatchQueue.main.async {
                    guard let name = self.settingsViewModel.profileInfos?.full_name,
                          let image = self.settingsViewModel.profileInfos?.pp_url else { return }
                    self.nameLabel.text = name
                    self.profileImageView.kf.setImage(with: URL(string: image))
                }
            }
        })
    }
    
    @objc func logoutButtonTapped() {
        let title = "Confirm Logout"
        let message = "Are you sure you want to log out?"
        showConfirmationAlert(title: title, message: message) {
            KeychainHelper.deleteAccessToken()
            let vc = LoginViewController()
            self.navigationController?.setViewControllers([vc], animated: true)
        }
    }
    
    @objc func editButtonTapped() {
        let vc = EditProfileViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.profileUpdateDelegate = self
        self.present(vc, animated: true)
    }

    private func setupView() {
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = AppColor.primary.color
        view.addSubviews(settingsLabel, logoutButton, componentsView)
        componentsView.addSubviews(profileImageView, nameLabel, editButton, settingsCollectionView)
        setupLayout()
    }

    private func setupLayout() {
        settingsLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
            make.leading.equalToSuperview().offset(24)
        }
        logoutButton.snp.makeConstraints { make in
            make.centerY.equalTo(settingsLabel.snp.centerY)
            make.trailing.equalToSuperview().offset(-24)
            make.width.height.equalTo(30)
        }
        componentsView.snp.makeConstraints { make in
            make.top.equalTo(settingsLabel.snp.bottom).offset(54)
            make.leading.trailing.bottom.equalToSuperview()
        }
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.centerX.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(120)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        editButton.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        settingsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(editButton.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-54)
        }
    }
}

extension SettingsViewController: ProfileUpdateDelegate {
    func updateProfile(name: String, image: UIImage?) {
        self.nameLabel.text = name
        if let updatedImage = image {
            self.profileImageView.image = updatedImage
        }
    }
}

extension SettingsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 32, height: 54)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settingsViewModel.settingsParametres.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "settingsCell", for: indexPath) as? SettingsViewCell
        else {
            return UICollectionViewCell()
        }
        
        let model = settingsViewModel.settingsParametres[indexPath.item]
        cell.configure(model: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.item == 0 {
                self.tabBarController?.tabBar.isHidden = true
                let viewController = SecurityViewController()
                navigationController?.pushViewController(viewController, animated: true)
            }
          }
        }
    }
