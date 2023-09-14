//
//  SecuritySettingsViewController.swift
//  Travio
//
//  Created by Furkan Kızmaz on 7.09.2023.
//

import Kingfisher
import SnapKit
import UIKit
import AVFoundation
import Photos
import CoreLocation

enum PermissionType: Int {
    case camera
    case photoLibrary
    case location

    static func permissionType(for indexPath: IndexPath) -> PermissionType {
        switch indexPath.row {
        case 0:
            return .camera
        case 1:
            return .photoLibrary
        case 2:
            return .location
        default:
            return .camera
        }
    }
}

class SecurityViewController: UIViewController, CLLocationManagerDelegate {

    private let locationManager = CLLocationManager()
    private var cameraPermissionGranted = false
    private var photoLibraryPermissionGranted = false
    private var locationPermissionGranted = false
    private var locationPermissionRequested = false

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
        observePermissionChanges()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
            if cameraAuthorizationStatus == .authorized {
                enableCameraToggle()
                cameraPermissionGranted = true
            }
            let photoLibraryAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
            if photoLibraryAuthorizationStatus == .authorized {
                enablePhotoLibraryToggle()
                photoLibraryPermissionGranted = true
            }
            let locationAuthorizationStatus = CLLocationManager.authorizationStatus()
            if locationAuthorizationStatus == .authorizedAlways || locationAuthorizationStatus == .authorizedWhenInUse {
                enableLocationToggle()
                locationPermissionGranted = true
                requestLocationPermission()
            }
        }
    
    private func observePermissionChanges() {
        NotificationCenter.default.addObserver(self, selector: #selector(requestCameraPermission), name: .AVCaptureDeviceWasConnected, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(requestPhotoLibraryPermission), name: .init("photoLibraryPermissionDidChange"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(requestLocationPermission), name: .init("locationPermissionDidChange"), object: nil)

    }

    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    func performPasswordChange(newPassword: String) {
        if newPassword.isEmpty {
            print("Şifre boş olamaz.")
        } else {
            securitySettingsViewModel.changePasswordInfos = ChangePassword(new_password: newPassword)
            securitySettingsViewModel.putChangePassword(change_password: newPassword)
        }
    }

    @objc func saveButtonTapped() {
        guard let changePasswordSection = securitySettingsViewModel.tableViewArray.first(where: { $0.type == "Change Password" }),
              let newPasswordIndex = changePasswordSection.index.firstIndex(of: "New Password"),
              let newPasswordConfirmIndex = changePasswordSection.index.firstIndex(of: "New Password Confirm"),
              let newPasswordCell = tableView.cellForRow(at: IndexPath(row: newPasswordIndex, section: 0)) as? NewPasswordViewCell,
              let newPasswordConfirmCell = tableView.cellForRow(at: IndexPath(row: newPasswordConfirmIndex, section: 0)) as? NewPasswordViewCell else {
            return
        }
        let newPassword = newPasswordCell.changePasswordView.textField.text ?? ""
        let newPasswordConfirm = newPasswordConfirmCell.changePasswordView.textField.text ?? ""
        performPasswordChange(newPassword: newPassword)
    }

    @objc private func toggleButtonTapped(_ sender: UISwitch) {
        let permissionType = PermissionType(rawValue: sender.tag) ?? .camera

        switch permissionType {
        case .camera:
            if sender.isOn {
                requestCameraPermission()
            } else {
                resetCameraPermission()
            }
        case .photoLibrary:
            if sender.isOn {
                if photoLibraryPermissionGranted {
                    enablePhotoLibraryToggle()
                } else {
                    requestPhotoLibraryPermission()
                }
            } else {
                openPhotoLibrarySettings()
            }
        case .location:
            if sender.isOn {
                if locationPermissionGranted {
                    enableLocationToggle()
                } else {
                    requestLocationPermission()
                }
            } else {
                openLocationSettings()
            }
        }
    }

    private func requestPermission(for permissionType: PermissionType) {
        switch permissionType {
        case .camera:
            requestCameraPermission()
        case .photoLibrary:
            requestPhotoLibraryPermission()
        case .location:
            requestLocationPermission()
        }
    }

    private func resetPermission(for permissionType: PermissionType) {
        switch permissionType {
        case .camera:
            resetCameraPermission()
        case .photoLibrary:
            resetPhotoLibraryPermission()
        case .location:
            resetLocationPermission()
        }
    }

    private func enableCameraToggle() {
        if let cameraCell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? PrivacyViewCell {
            cameraCell.toggle.isOn = true
        }
    }

    private func enablePhotoLibraryToggle() {
        if let photoLibraryCell = tableView.cellForRow(at: IndexPath(row: 1, section: 1)) as? PrivacyViewCell {
            photoLibraryCell.toggle.isOn = true
        }
    }

    private func enableLocationToggle() {
        if let locationCell = tableView.cellForRow(at: IndexPath(row: 2, section: 1)) as? PrivacyViewCell {
            locationCell.toggle.isOn = true
        }
    }

    @objc private func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            if !granted {
                DispatchQueue.main.async {
                    self?.openAppSettings()
                }
            }
        }
    }

    @objc private func requestPhotoLibraryPermission() {
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            if status == .denied || status == .restricted {
                DispatchQueue.main.async {
                    self?.openPhotoLibrarySettings()
                }
            } else if status == .authorized {
                self?.enablePhotoLibraryToggle()
                self?.photoLibraryPermissionGranted = true
                NotificationCenter.default.post(name: .init("photoLibraryPermissionDidChange"), object: nil)
            }
        }
    }

    @objc private func requestLocationPermission() {
        if !locationPermissionRequested {
            locationPermissionRequested = true

            if CLLocationManager.locationServicesEnabled() {
                switch CLLocationManager.authorizationStatus() {
                case .authorizedAlways, .authorizedWhenInUse:
                    enableLocationToggle()
                    locationPermissionGranted = true
                case .notDetermined:
                    DispatchQueue.global(qos: .background).async {
                        self.locationManager.delegate = self
                        self.locationManager.requestWhenInUseAuthorization()
                    }
                default:
                    openAppSettings()
                }
            } else {
                openAppSettings()
            }
        }
    }
    
    private func openPhotoLibrarySettings() {
        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsURL, options: [:]) { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }

    private func openLocationSettings() {
        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsURL, options: [:]) { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }

    private func resetCameraPermission() {
        if cameraPermissionGranted {
            AVCaptureDevice.requestAccess(for: .video) { [weak self] _ in
                DispatchQueue.main.async {
                    self?.openAppSettings()
                }
            }
        } else {
            openAppSettings()
        }
    }

    private func resetPhotoLibraryPermission() {
        if photoLibraryPermissionGranted {
            PHPhotoLibrary.requestAuthorization { [weak self] status in
                if status == .denied || status == .restricted {
                    DispatchQueue.main.async {
                        self?.openPhotoLibrarySettings()
                    }
                } else if status == .authorized {
                    //self?.disablePhotoLibraryToggle()
                    self?.photoLibraryPermissionGranted = false
                }
            }
        } else {
            openPhotoLibrarySettings()
        }
    }

    private func resetLocationPermission() {
        if locationPermissionGranted {
            let locationManager = CLLocationManager()
            locationManager.requestWhenInUseAuthorization()
        } else {
            openAppSettings()
        }
    }

    private func openAppSettings() {
        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsURL, options: [:]) { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }

    private func setupView() {
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = AppColor.primary.color
        view.addSubviews(backButton, securitySettingsLabel, componentsView)
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
        let permissionType: PermissionType

        if section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NewPasswordViewCell().identifier) as? NewPasswordViewCell else { return UITableViewCell() }
            let data = securitySettingsViewModel.tableViewArray[indexPath.section].index[indexPath.row]
            cell.configure(model: data)
            cell.selectionStyle = .none
            return cell
        } else {
            permissionType = PermissionType.permissionType(for: indexPath)
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PrivacyViewCell().identifier) as? PrivacyViewCell else { return UITableViewCell() }
            let data = securitySettingsViewModel.tableViewArray[indexPath.section].index[indexPath.row]
            cell.configure(model: data, permissionType: permissionType)
            cell.selectionStyle = .none
            cell.toggle.tag = permissionType.rawValue // Hücrenin tag'ını izin türüne ayarlayın
            cell.toggle.addTarget(self, action: #selector(toggleButtonTapped), for: .valueChanged)
            return cell
        }
    }
}
