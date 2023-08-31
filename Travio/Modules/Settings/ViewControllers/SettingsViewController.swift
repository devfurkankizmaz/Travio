//
//  SettingsViewController.swift
//  Travio
//
//  Created by Muhammet on 31.08.2023.
//

import UIKit
import SnapKit

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
        button.setTitleColor(AppColor.primary.color, for: .normal)
        button.titleLabel?.font = AppFont.poppinsRegular.withSize(12)
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var settingsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.scrollDirection = .horizontal
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
    }
    
    @objc func editButtonTapped() {
        
        print("Edit Butonu tıkladı")
    }

    private func setupView() {
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = AppColor.primary.color
        view.addSubviews(settingsLabel, componentsView)
        componentsView.addSubviews(profileImageView, nameLabel, editButton, settingsCollectionView)
        setupLayout()
    }

    private func setupLayout() {
        settingsLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
            make.leading.equalToSuperview().offset(24)
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
            make.bottom.equalToSuperview()
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
}

