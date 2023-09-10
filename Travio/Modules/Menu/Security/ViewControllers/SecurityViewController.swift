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
    // MARK: - Properties

    private lazy var viewModel: SecurityViewModel = .init()

    private lazy var componentsView: ComponentsView = .init()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.poppinsSemiBold.withSize(32)
        label.text = "Security Settings"
        label.textColor = .white
        return label
    }()

    private lazy var backButton: UIButton = {
        let button = UIButton()
        let arrowImage = UIImage(named: "back")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        button.setImage(arrowImage, for: .normal)
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var securityCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8
        layout.headerReferenceSize = CGSizeMake(self.view.frame.width, 36)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.delegate = self
        cv.showsVerticalScrollIndicator = false
        cv.dataSource = self
        cv.register(SecuritySettingCell.self, forCellWithReuseIdentifier: SecuritySettingCell.identifier)
        cv.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.identifier)
        return cv
    }()

    private lazy var saveButton: TravioButton = {
        let button = TravioButton()
        button.setTitle("Save", for: .normal)
        // button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    // MARK: - Private Methods

    private func setupView() {
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = AppColor.primary.color
        componentsView.addSubviews(securityCollectionView)
        view.addSubviews(backButton,
                         titleLabel,
                         componentsView,
                         saveButton)
        setupLayout()
    }

    private func setupLayout() {
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
            make.leading.equalToSuperview().offset(24)
            make.width.height.equalTo(32)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.top).offset(-6)
            make.leading.equalTo(backButton.snp.trailing).offset(24)
        }
        componentsView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(125)
        }
        securityCollectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(saveButton.snp.top).offset(-24)
            make.top.equalToSuperview().offset(32)
        }
        saveButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-24)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(54)
        }
    }

    // MARK: - Actions

    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Extensions

extension SecurityViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.width - 48
        let cellHeight: CGFloat = 74

        return CGSize(width: cellWidth, height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset: CGFloat = 24
        return UIEdgeInsets(top: 0, left: 0, bottom: inset, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}
}

extension SecurityViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.sections[section].items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SecuritySettingCell.identifier, for: indexPath) as? SecuritySettingCell else {
            return UICollectionViewCell()
        }

        let section = viewModel.sections[indexPath.section]
        let item = section.items[indexPath.row]

        cell.configure(with: item)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.identifier, for: indexPath) as? SectionHeaderView else {
                return UICollectionReusableView()
            }

            let section = viewModel.sections[indexPath.section]
            headerView.configure(with: section.title)

            return headerView
        }

        return UICollectionReusableView()
    }
}
