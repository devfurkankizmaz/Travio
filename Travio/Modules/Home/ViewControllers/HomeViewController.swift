import SnapKit
import UIKit

enum SectionType: Int, CaseIterable {
    case popular = 0
    case new
    case visits

    var title: String {
        switch self {
        case .popular:
            return "Popular Places"
        case .new:
            return "New Places"
        case .visits:
            return "Your Visits"
        }
    }
}

class HomeViewController: UIViewController {
    // MARK: - Properties

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

    private lazy var homeViewModel: HomeViewModel = {
        let viewModel = HomeViewModel()
        return viewModel
    }()

    private lazy var mainCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 50
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: MainCollectionViewCell.identifier)
        return collectionView
    }()

    private lazy var titleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "home-logo")
        return imageView
    }()

    private lazy var componentsView: ComponentsView = .init()

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchContent()
    }

    // MARK: - Private Methods

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

    private func setupView() {
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = AppColor.primary.color

        view.addSubviews(titleImageView, componentsView, spinnerView, spinner)
        componentsView.addSubviews(mainCollectionView)

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

        titleImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(64)
            make.width.equalTo(176)
        }

        componentsView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(titleImageView.snp.bottom).offset(32)
        }

        mainCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    private func fetchContent() {
        let dispatchGroup = DispatchGroup()
        let contentFetchers = [
            homeViewModel.fetchPopularPlaces,
            homeViewModel.fetchNewPlaces,
            homeViewModel.fetchVisits
        ]

        showActivityIndicator()

        contentFetchers.forEach { contentFetcher in
            dispatchGroup.enter()
            contentFetcher { [weak self] confirm in
                if confirm {
                    DispatchQueue.main.async {
                        self?.mainCollectionView.reloadData()
                    }
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.hideActivityIndicator()
        }
    }
}

// MARK: - Extensions

extension HomeViewController: MainCollectionViewCellDelegate {
    func didSelectPlace(_ place: Place) {
        let detailVC = DetailsViewController()
        detailVC.placeId = place.id
        detailVC.visitButtonIsHidden = false
        detailVC.isFromVisit = false
        navigationController?.pushViewController(detailVC, animated: true)
    }

    func didTapSeeAllButton(in cell: MainCollectionViewCell) {
        let sectionIndex = cell.seeAllButton.tag
        guard let sectionType = SectionType(rawValue: sectionIndex) else {
            return
        }

        let listVC = ListViewController()
        listVC.selectedSection = sectionType
        listVC.selectedSectionType = sectionType

        navigationController?.pushViewController(listVC, animated: true)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth: CGFloat = collectionView.bounds.width
        let cellHeight: CGFloat = 180
        return CGSize(width: cellWidth, height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset: CGFloat = 86
        return UIEdgeInsets(top: inset, left: 0, bottom: inset, right: 0)
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SectionType.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.identifier, for: indexPath) as? MainCollectionViewCell else {
            return UICollectionViewCell()
        }

        let section = SectionType.allCases[indexPath.row]
        let title = section.title
        let data = homeViewModel.getPlacesForSection(section)

        cell.configure(with: data, title: title)
        cell.delegate = self
        cell.seeAllButton.tag = indexPath.row
        cell.contentView.isUserInteractionEnabled = true

        return cell
    }
}
