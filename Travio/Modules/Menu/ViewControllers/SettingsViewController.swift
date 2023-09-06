import SnapKit
import UIKit

class SettingsViewController: UIViewController {
    // MARK: - Properties

    private lazy var viewModel: SettingsViewModel = .init()

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
        label.font = AppFont.poppinsSemiBold.withSize(16)
        label.textAlignment = .center
        label.text = "John Doe"
        label.textColor = AppColor.secondary.color
        return label
    }()

    private lazy var editProfileButton: UIButton = {
        let button = UIButton()
        button.setTitle("Edit Profile", for: .normal)
        button.titleLabel?.font = AppFont.poppinsMedium.withSize(12)
        // button.addTarget(self, action: #selector(editProfileButtonTapped), for: .touchUpInside)
        let color = UIColor(cgColor: #colorLiteral(red: 0, green: 0.7667202353, blue: 0.9408947229, alpha: 1))
        button.setTitleColor(color, for: .normal)
        return button
    }()

    private lazy var settingsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.delegate = self
        cv.showsVerticalScrollIndicator = false
        cv.dataSource = self
        cv.register(SettingsViewCell.self, forCellWithReuseIdentifier: SettingsViewCell.identifier)
        return cv
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.poppinsSemiBold.withSize(32)
        label.text = "Settings"
        label.textColor = .white
        return label
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

        view.addSubviews(titleLabel, componentsView)
        componentsView.addSubviews(settingsCollectionView, profilePictureImageView, fullNameLabel, editProfileButton)

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
            make.leading.equalToSuperview().offset(20)
        }

        profilePictureImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(24)
            make.width.height.equalTo(120)
        }

        fullNameLabel.snp.makeConstraints { make in
            make.top.equalTo(profilePictureImageView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }

        editProfileButton.snp.makeConstraints { make in
            make.top.equalTo(fullNameLabel.snp.bottom)
            make.centerX.equalToSuperview()
        }

        settingsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(editProfileButton.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    // MARK: - Actions
}

// MARK: - Extensions

extension SettingsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.width - 32
        let cellHeight: CGFloat = 54

        return CGSize(width: cellWidth, height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset: CGFloat = 12
        return UIEdgeInsets(top: inset, left: 0, bottom: inset, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}
}

extension SettingsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SettingsViewCell.identifier, for: indexPath) as? SettingsViewCell else {
            return UICollectionViewCell()
        }

        let item = viewModel.item(at: indexPath.row)
        cell.configure(with: item)

        return cell
    }
}
