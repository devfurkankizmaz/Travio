//
//  VisitsViewController.swift
//  Travio
//
//  Created by Furkan Kızmaz on 27.08.2023.
//

import UIKit

protocol VisitsViewControllerDelegate: AnyObject {
    func showDeletionAlert(message: String)
    func reloadView()
}

class VisitsViewController: UIViewController {
    // MARK: - Properties

    private lazy var visitsViewModel: VisitsViewModel = {
        let viewModel = VisitsViewModel()
        return viewModel
    }()

    private lazy var componentsView = ComponentsView()

    private lazy var myVisitsLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.poppinsSemiBold.withSize(36)
        label.text = "My Visits"
        label.textColor = .white
        return label
    }()

    private lazy var visitListCollectionView: UICollectionView = {
        var flowLayout = UICollectionViewFlowLayout()
        // flowLayout.minimumLineSpacing = 16
        flowLayout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        cv.delegate = self
        cv.dataSource = self
        cv.register(PlaceViewCell.self, forCellWithReuseIdentifier: "visitIdentifier")
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchVisits()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchVisits()
    }

    // MARK: - Private Methods

    private func fetchVisits() {
        visitsViewModel.fetchVisits { [weak self] _, success in
            if success {
                DispatchQueue.main.async {
                    self?.visitListCollectionView.reloadData()
                }
            }
        }
    }

    private func setupView() {
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = AppColor.primary.color
        view.addSubviews(myVisitsLabel, componentsView)
        // view.bringSubviewToFront(indicator)
        componentsView.addSubviews(visitListCollectionView)
        setupLayout()
    }

    private func setupLayout() {
        myVisitsLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
            make.leading.equalToSuperview().offset(24)
        }
        componentsView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(128)
            make.leading.trailing.bottom.equalToSuperview()
        }
        visitListCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

extension VisitsViewController: VisitsViewControllerDelegate {
    func showDeletionAlert(message: String) {
        showAlert(title: "success", message: message)
    }

    func reloadView() {
        fetchVisits()
    }
}

extension VisitsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.width - 48
        let cellHeight: CGFloat = 220

        return CGSize(width: cellWidth, height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let topInset: CGFloat = 48
        return UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = DetailsViewController()
        if let visit = visitsViewModel.getAVisit(at: indexPath.row) {
            detailVC.placeId = visit.placeID
            detailVC.visitId = visit.id
            detailVC.delegate = self
            detailVC.visitButtonIsHidden = true
            detailVC.isFromVisit = true
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

extension VisitsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        visitsViewModel.numberOfVisits()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "visitIdentifier", for: indexPath) as? PlaceViewCell else {
            return UICollectionViewCell()
        }

        if let visit = visitsViewModel.getAVisit(at: indexPath.row) {
            cell.configure(with: visit.place)
        }

        return cell
    }
}
