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

    private lazy var mainCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 50
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: "MainCell")
        return collectionView
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
        fetchVisits()
    }

    // MARK: - Private Methods

    private func setupView() {
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = AppColor.primary.color

        componentsView.addSubviews(mainCollectionView)
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

        mainCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    private func fetchPopularPlaces() {
        homeViewModel.fetchPopularPlaces { [weak self] _, success in
            if success {
                DispatchQueue.main.async {
                    self?.mainCollectionView.reloadData()
                }
            }
        }
    }

    private func fetchVisits() {
        homeViewModel.fetchVisits { [weak self] _, success in
            if success {
                DispatchQueue.main.async {
                    self?.mainCollectionView.reloadData()
                }
            }
        }
    }

    private func fetchNewPlaces() {
        homeViewModel.fetchNewPlaces { [weak self] _, success in
            if success {
                DispatchQueue.main.async {
                    self?.mainCollectionView.reloadData()
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
        let cellWidth: CGFloat = collectionView.bounds.width
        let cellHeight: CGFloat = 180

        return CGSize(width: cellWidth, height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        // let inset: CGFloat = 24
        return UIEdgeInsets(top: 86, left: 0, bottom: 0, right: 0)
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCell", for: indexPath) as! MainCollectionViewCell

        if indexPath.row == 0 {
            cell.configure(with: homeViewModel.getAllPopularPlaces())
        } else if indexPath.row == 1 {
            cell.configure(with: homeViewModel.getAllLastPlaces())
        } else if indexPath.row == 2 {
            cell.configure(with: homeViewModel.getAllVisits())
        }

        return cell
    }
}
