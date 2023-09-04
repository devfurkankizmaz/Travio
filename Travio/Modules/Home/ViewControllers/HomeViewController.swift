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
        contentView.addSubviews(popularPlacesCollectionView, newPlacesCollectionView)
        componentsView.addSubviews(scrollView)
        view.addSubviews(titleImageView, componentsView, popularPlacesHeaderView, newPlacesHeaderView)
        setupLayout()
    }

    private func setupLayout() {
        contentView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalTo(newPlacesCollectionView.snp.bottom).offset(100)
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
    @objc func newSeeAllTapped() {
        print("smt")
    }
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
