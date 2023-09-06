//
//  SecuritySettingsViewController.swift
//  Travio
//
//  Created by Muhammet on 1.09.2023.
//

import UIKit
import SnapKit

class SecuritySettingsViewController: UIViewController {
    
    private lazy var securitySettingsViewModel: SecuritySettingsViewModel = {
        let viewModel = SecuritySettingsViewModel()
        return viewModel
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        let arrowImage = UIImage(named: "backgo")?.withTintColor(.white, renderingMode: .alwaysOriginal)
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
        tableView.register(NewPasswordTVC.self, forCellReuseIdentifier: NewPasswordTVC().identifier)
        tableView.register(PrivacyTVC.self, forCellReuseIdentifier: PrivacyTVC().identifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)
        return tableView
    }()
    
    private lazy var saveButton: TravioButton = {
        let button = TravioButton()
        button.setTitle("Save", for: .normal)
       // button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
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

extension SecuritySettingsViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        tableView.deselectRow(at: indexPath, animated: false)
//
//    }
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
    
                guard let cell = tableView.dequeueReusableCell(withIdentifier: NewPasswordTVC().identifier) as? NewPasswordTVC else { return UITableViewCell() }
    
                let data = securitySettingsViewModel.tableViewArray[indexPath.section].index[indexPath.row]
                cell.configure(model: data)
                cell.selectionStyle = .none

                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: PrivacyTVC().identifier) as? PrivacyTVC else { return UITableViewCell() }
    
                let data = securitySettingsViewModel.tableViewArray[indexPath.section].index[indexPath.row]
                cell.configure(model: data)
                cell.selectionStyle = .none
                
                return cell
            }
    }
}
