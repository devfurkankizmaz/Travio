import SnapKit
import UIKit

class ListViewController: UIViewController {
    // MARK: - Properties

    var selectedSection: SectionType? {
        didSet {
            titleLabel.text = selectedSection?.title
        }
    }

    var selectedSectionType: SectionType? {
        didSet {
            switch selectedSectionType {
            case .popular:
                fetchPopularPlaces()
            case .new:
                fetchNewPlaces()
            case .visits:
                fetchVisits()
            default:
                break
            }
        }
    }

    private lazy var backButton: UIButton = {
        let button = UIButton()
        let arrowImage = UIImage(named: "back")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        button.setImage(arrowImage, for: .normal)
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var listCollectionView: UICollectionView = {
        var flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 16
        flowLayout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        cv.delegate = self
        cv.dataSource = self
        cv.register(ListViewCell.self, forCellWithReuseIdentifier: "listIdentifier")
        return cv
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.poppinsSemiBold.withSize(32)
        label.text = ""
        label.textColor = .white
        return label
    }()

    private lazy var componentsView = ComponentsView()

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    // MARK: - Private Methods

    func setupView() {
        navigationController?.isNavigationBarHidden = true
        view.addSubviews(componentsView, backButton, titleLabel)
        view.backgroundColor = AppColor.primary.color
        componentsView.addSubviews(listCollectionView)
        setupLayout()
    }

    func setupLayout() {
        listCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

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
    }

    private func fetchPopularPlaces() {
        print("Popular Places Fetching...")
    }

    private func fetchNewPlaces() {
        print("New Places Fetching...")
    }

    private func fetchVisits() {
        print("Visits Fetching...")
    }

    // MARK: - Public Methods

    // MARK: - Actions

    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Extensions

extension ListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.width - 48
        let cellHeight: CGFloat = 90

        return CGSize(width: cellWidth, height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let topInset: CGFloat = 70
        return UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
    }
}

extension ListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listIdentifier", for: indexPath) as? ListViewCell else {
            return UICollectionViewCell()
        }
        return cell
    }
}
