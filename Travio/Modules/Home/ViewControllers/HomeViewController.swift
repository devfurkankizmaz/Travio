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

    // MARK: - Private Methods

    private func setupView() {
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = AppColor.primary.color

        componentsView.addSubviews(popularPlacesCollectionView, newPlacesCollectionView)
        view.addSubviews(titleImageView, componentsView, componentsView)
        setupLayout()
    }

    private func setupLayout() {
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

        popularPlacesCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(86)
            make.height.equalTo(180)
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
        homeViewModel.fetchNewPlaces { [weak self] _, success in
            if success {
                DispatchQueue.main.async {
                    self?.newPlacesCollectionView.reloadData()
                }
            }
        }
    }

    // MARK: - Public Methods

    // MARK: - Actions Methods
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
        if collectionView == popularPlacesCollectionView {
            return homeViewModel.numberOfPopularPlaces()
        } else if collectionView == newPlacesCollectionView {
            return homeViewModel.numberOfLastPlaces()
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
