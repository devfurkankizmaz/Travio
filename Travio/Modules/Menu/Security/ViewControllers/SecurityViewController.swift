//
//  SecuritySettingsViewController.swift
//  Travio
//
//  Created by Furkan Kızmaz on 7.09.2023.
//

import Kingfisher
import SnapKit
import UIKit

class SecurityViewController: UIViewController {
    
    private lazy var securitySettingsViewModel: SecurityViewModel = {
        let viewModel = SecurityViewModel()
        return viewModel
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        let arrowImage = UIImage(named: "back_go")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        button.setImage(arrowImage, for: .normal)
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var securitySettingsLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.poppinsSemiBold.withSize(32)
        label.textAlignment = .center
        label.text = "Security Settings"
        label.textColor = .white
        return label
    }()

    private lazy var componentsView = ComponentsView()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NewPasswordViewCell.self, forCellReuseIdentifier: NewPasswordViewCell().identifier)
        tableView.register(PrivacyViewCell.self, forCellReuseIdentifier: PrivacyViewCell().identifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)
        return tableView
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
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    func performPasswordChange(newPassword: String) {
        // Yeni şifrelerin geçerliliğini ve uyuşup uyuşmadığını kontrol edin
        if newPassword.isEmpty {
            print("Şifre boş olamaz.")
        } else {
            // Şifre değiştirme işlemini çağırın
            securitySettingsViewModel.changePasswordInfos = ChangePassword(new_password: newPassword)
            securitySettingsViewModel.putChangePassword(change_password: newPassword)
        }
    }
    
    @objc func saveButtonTapped() {
        // İlgili indeksleri önceden alın
        guard let changePasswordSection = securitySettingsViewModel.tableViewArray.first(where: { $0.type == "Change Password" }),
              let newPasswordIndex = changePasswordSection.index.firstIndex(of: "New Password"),
              let newPasswordConfirmIndex = changePasswordSection.index.firstIndex(of: "New Password Confirm"),
              let newPasswordCell = tableView.cellForRow(at: IndexPath(row: newPasswordIndex, section: 0)) as? NewPasswordViewCell,
              let newPasswordConfirmCell = tableView.cellForRow(at: IndexPath(row: newPasswordConfirmIndex, section: 0)) as? NewPasswordViewCell else {
            // Hata durumunda çık
            return
        }

        // TextField değerlerini alın
        let newPassword = newPasswordCell.changePasswordView.textField.text ?? ""
        let newPasswordConfirm = newPasswordConfirmCell.changePasswordView.textField.text ?? ""

        // Şifre değiştirme işlemini çağırın
        performPasswordChange(newPassword: newPassword)
        
    }

    private func setupView() {
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = AppColor.primary.color
        view.addSubviews(backButton ,securitySettingsLabel ,componentsView)
        componentsView.addSubviews(tableView, saveButton)
        setupLayout()
    }

    private func setupLayout() {
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
            make.leading.equalToSuperview().offset(24)
            make.width.height.equalTo(32)
        }
        securitySettingsLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.centerX.equalToSuperview()
        }
        componentsView.snp.makeConstraints { make in
            make.top.equalTo(securitySettingsLabel.snp.bottom).offset(58)
            make.leading.trailing.bottom.equalToSuperview()
        }
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(44)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(saveButton.snp.top).offset(-20)
        }
        saveButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(54)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-18)
        }
    }
}

extension SecurityViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        
        let label = UILabel()
        label.text = securitySettingsViewModel.tableViewArray[section].type
        label.textColor = #colorLiteral(red: 0.2196078431, green: 0.6784313725, blue: 0.662745098, alpha: 1)
        label.font = AppFont.poppinsSemiBold.withSize(16)
        headerView.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.leading.equalTo(headerView.snp.leading).offset(16)
            make.centerY.equalToSuperview()
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return securitySettingsViewModel.tableViewArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return securitySettingsViewModel.tableViewArray[section].index.count

    }
    
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
              let section = indexPath.section
    
            if section == 0 {
    
                guard let cell = tableView.dequeueReusableCell(withIdentifier: NewPasswordViewCell().identifier) as? NewPasswordViewCell else { return UITableViewCell() }
    
                let data = securitySettingsViewModel.tableViewArray[indexPath.section].index[indexPath.row]
                cell.configure(model: data)
                cell.selectionStyle = .none

                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: PrivacyViewCell().identifier) as? PrivacyViewCell else { return UITableViewCell() }
    
                let data = securitySettingsViewModel.tableViewArray[indexPath.section].index[indexPath.row]
                cell.configure(model: data)
                cell.selectionStyle = .none
                
                return cell
            }
    }
}
