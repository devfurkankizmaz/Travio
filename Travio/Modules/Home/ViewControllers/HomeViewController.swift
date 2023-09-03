//
//  HomeViewController.swift
//  Travio
//
//  Created by Furkan Kızmaz on 30.08.2023.
//

import SnapKit
import UIKit

class HomeViewController: UIViewController {
    // MARK: - Properties

    private lazy var homeViewModel: HomeViewModel = {
        let viewModel = HomeViewModel()
        return viewModel
    }()

    private lazy var popularPlacesHeaderView: HeaderCustomView = {
        let view = HeaderCustomView()
        view.titleView = "Popular Places"
        view.button.addTarget(self, action: #selector(popularSeeAllTapped), for: .touchUpInside)
        return view
    }()

    private lazy var newPlacesHeaderView: HeaderCustomView = {
        let view = HeaderCustomView()
        view.titleView = "New Places"
        view.button.addTarget(self, action: #selector(newSeeAllTapped), for: .touchUpInside)
        return view
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()

    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()

    private lazy var popularPlacesCollectionView: UICollectionView = {
        var flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 16
        flowLayout.minimumInteritemSpacing = 16
        flowLayout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.delegate = self
        cv.dataSource = self
        cv.register(PlaceViewCell.self, forCellWithReuseIdentifier: "popularIdentifier")
        return cv
    }()

    private lazy var newPlacesCollectionView: UICollectionView = {
        var flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 16
        flowLayout.minimumInteritemSpacing = 16
        flowLayout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.delegate = self
        cv.dataSource = self
        cv.register(PlaceViewCell.self, forCellWithReuseIdentifier: "newIdentifier")
        return cv
    }()

    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce bibendum, ligula vitae laoreet sagittis, erat urna fermentum dui, at aliquam risus libero eget ex. Cras posuere sapien nec risus vulputate, id convallis purus tristique. Proin euismod odio id odio rhoncus bibendum. Sed bibendum, turpis id consectetur bibendum, dolor est finibus libero, ut ultricies neque sapien sit amet odio. Curabitur a auctor nisl. Fusce blandit libero justo, id egestas dui tristique sit amet. Vestibulum id eros justo. Nunc eu ullamcorper nunc, quis malesuada elit. Vestibulum id tortor neque. Fusce vulputate sapien id nisi dapibus fringilla. Duis bibendum lorem ut nibh scelerisque volutpat. Vivamus ultricies metus sit amet bibendum dapibus. Integer eu erat eget nisi malesuada dapibus. Nulla facilisi. Etiam ut quam sit amet mi sollicitudin cursus. Integer convallis orci nec libero bibendum, ut efficitur nunc pellentesque. Maecenas eleifend, sapien id lacinia vulputate, elit tortor feugiat quam, sit amet scelerisque quam ligula vel nunc. Nunc pellentesque, metus non rhoncus interdum, arcu nisi iaculis odio, eu tempus elit quam a velit. Vivamus ut lacus velit. Donec vehicula quam nec bibendum efficitur. Nullam at sapien eget nisl rhoncus cursus. Integer euismod lectus ac odio elementum, a dictum ligula eleifend. Integer euismod ante a ultricies. Integer euismod, ligula ac venenatis laoreet, tortor risus gravida lectus, ut finibus lectus odio sed risus."
        label.textColor = AppColor.secondary.color
        label.numberOfLines = 0
        label.font = AppFont.poppinsRegular.withSize(12)
        return label
    }()

    private lazy var titleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "home-logo")
        return imageView
    }()

    private lazy var componentsView = ComponentsView()

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchPopularPlaces()
        fetchNewPlaces()
    }

    override func viewDidAppear(_ animated: Bool) {
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: contentView.frame.height)
    }

    // MARK: - Private Methods

    private func setupView() {
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = AppColor.primary.color
        scrollView.addSubview(contentView)
        contentView.addSubviews(popularPlacesCollectionView, newPlacesCollectionView, popularPlacesHeaderView, newPlacesHeaderView, label)
        componentsView.addSubviews(scrollView)
        view.addSubviews(titleImageView, componentsView)
        setupLayout()
    }

    private func setupLayout() {
        contentView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalTo(label.snp.bottom).offset(100)
        }

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(componentsView.snp.top)
            make.leading.trailing.bottom.equalToSuperview()
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

        popularPlacesHeaderView.snp.makeConstraints { make in
            make.bottom.equalTo(popularPlacesCollectionView.snp.top).offset(-16)
            make.leading.trailing.equalToSuperview()
        }

        popularPlacesCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(86)
            make.height.equalTo(180)
        }

        newPlacesHeaderView.snp.makeConstraints { make in
            make.bottom.equalTo(newPlacesCollectionView.snp.top).offset(-16)
            make.leading.trailing.equalToSuperview()
        }

        newPlacesCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(popularPlacesCollectionView.snp.bottom).offset(50)
            make.height.equalTo(180)
        }

        label.snp.makeConstraints { make in
            make.top.equalTo(newPlacesCollectionView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
        }
    }

    private func fetchPopularPlaces() {
        homeViewModel.fetchPopularPlaces { [weak self] _, success in
            if success {
                DispatchQueue.main.async {
                    self?.popularPlacesCollectionView.reloadData()
                }
            }
        }
    }

    private func fetchNewPlaces() {
        homeViewModel.fetchNewPlaces { [weak self] message, success in
            if success {
                DispatchQueue.main.async {
                    self?.newPlacesCollectionView.reloadData()
                    print(message)
                }
            }
        }
    }

    // MARK: - Public Methods

    // MARK: - Actions Methods

    @objc func popularSeeAllTapped() {}
    @objc func newSeeAllTapped() {}
}

// MARK: - Extensions

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth: CGFloat = collectionView.bounds.width - 100
        let cellHeight: CGFloat = 180

        return CGSize(width: cellWidth, height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset: CGFloat = 24
        return UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            let maxItemsToShow = 3
            if collectionView == popularPlacesCollectionView {
                return min(maxItemsToShow, homeViewModel.numberOfPopularPlaces())
            } else if collectionView == newPlacesCollectionView {
                return min(maxItemsToShow, homeViewModel.numberOfLastPlaces())
            }
            
            return 0
        }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == popularPlacesCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "popularIdentifier", for: indexPath) as? PlaceViewCell else {
                return UICollectionViewCell()
            }

            if let place = homeViewModel.getAPopularPlace(at: indexPath.row) {
                cell.configure(with: place)
            }

            return cell
        } else if collectionView == newPlacesCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newIdentifier", for: indexPath) as? PlaceViewCell else {
                return UICollectionViewCell()
            }

            if let place = homeViewModel.getALastPlace(at: indexPath.row) {
                cell.configure(with: place)
            }

            return cell
        }
        return UICollectionViewCell()
    }
}
