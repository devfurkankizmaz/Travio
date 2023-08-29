//
//  DetailsViewController.swift
//  Travio
//
//  Created by Furkan Kızmaz on 26.08.2023.
//

import MapKit
import UIKit

class DetailsViewController: UIViewController {
    // MARK: - Properties

    var placeId: String?
    var visitButtonIsHidden = true

    private lazy var detailsViewModel: DetailsViewModel = {
        let vm = DetailsViewModel()
        return vm
    }()

    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return mapView
    }()

    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .black
        // pageControl.addTarget(self, action: #selector(pageControlValueChanged), for: .valueChanged)
        pageControl.pageIndicatorTintColor = UIColor(white: 1, alpha: 0.5)
        pageControl.backgroundStyle = .prominent
        return pageControl
    }()

    private lazy var galleryCollectionView: UICollectionView = {
        var flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.backgroundColor = AppColor.background.color
        cv.delegate = self
        cv.dataSource = self
        cv.isDirectionalLockEnabled = true
        cv.isPagingEnabled = true
        cv.backgroundView = UIImageView(image: UIImage(named: "imageNotFound"))
        cv.register(GalleryViewCell.self, forCellWithReuseIdentifier: "galleryIdentifier")
        return cv
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()

    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()

    private lazy var backButton: UIButton = {
        let button = UIButton()
        let arrowImage = UIImage(named: "backbutton")
        button.setImage(arrowImage, for: .normal)
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var mapUIView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner]
        return view
    }()

    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.text = "İstanbul"
        label.font = AppFont.poppinsSemiBold.withSize(30)
        label.textColor = AppColor.secondary.color
        return label
    }()

    private lazy var visitDateLabel: UILabel = {
        let label = UILabel()
        label.text = "24 Nisan 2023"
        label.font = AppFont.poppinsRegular.withSize(14)
        label.textColor = AppColor.secondary.color
        return label
    }()

    private lazy var creatorLabel: UILabel = {
        let label = UILabel()
        label.text = "added by @furkankizmaz"
        label.font = AppFont.poppinsRegular.withSize(10)
        label.textColor = #colorLiteral(red: 0.6642268896, green: 0.6642268896, blue: 0.6642268896, alpha: 1)
        return label
    }()

    private lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 4
        sv.alignment = .leading
        return sv
    }()

    private lazy var gradientImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "gradientwhite")
        return imageView
    }()

    private lazy var visitButton: UIButton = {
        let button = UIButton()
        button.isHidden = visitButtonIsHidden
        button.setImage(UIImage(named: "visitButton"), for: .normal)
        return button
    }()

    private lazy var descLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.poppinsRegular.withSize(12)
        label.numberOfLines = 0
        label.textColor = AppColor.secondary.color
        return label
    }()

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        setupView()
        fetchPlace()
        fetchGallery()
    }

    override func viewDidAppear(_ animated: Bool) {
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: contentView.frame.height)
    }

    // MARK: - Private Methods

    private func updateUIWithData() {
        let customFormattedDate = detailsViewModel.place?.created_at.formatISO8601ToCustomFormat()
        locationLabel.text = detailsViewModel.place?.place
        descLabel.text = detailsViewModel.place?.description
        visitDateLabel.text = customFormattedDate
        creatorLabel.text = "added by@\(detailsViewModel.place?.creator ?? "anonymous")"
    }

    private func setupMapLocation() {
        guard let place = detailsViewModel.place else { return }
        let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(place.latitude), longitude: CLLocationDegrees(place.longitude))

        let annotation = CustomAnnotation(coordinate: coordinate)
        annotation.title = place.title

        mapView.addAnnotation(annotation)

        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 3000, longitudinalMeters: 3000)
        mapView.setRegion(region, animated: true)
    }

    private func fetchPlace() {
        guard let id = placeId else { return }
        detailsViewModel.fetchPlace(with: id, callback: { [weak self] success in
            if success {
                DispatchQueue.main.async {
                    self?.updateUIWithData()
                    self?.setupMapLocation()
                }
            }
        })
    }

    private func fetchGallery() {
        guard let id = placeId else { return }
        detailsViewModel.fetchGallery(with: id, callback: { [weak self] success in
            if success {
                DispatchQueue.main.async {
                    self?.galleryCollectionView.reloadData()
                    self?.pageControl.numberOfPages = self?.detailsViewModel.numberOfImages() ?? 0
                }
            }
        })
    }

    private func setupView() {
        navigationController?.isNavigationBarHidden = true
        stackView.addArrangedSubviews(locationLabel, visitDateLabel, creatorLabel)
        mapUIView.addSubview(mapView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(stackView, mapUIView, descLabel, visitButton)

        view.addSubviews(galleryCollectionView, gradientImageView, backButton, pageControl, scrollView)
        view.backgroundColor = AppColor.background.color
        setupLayout()
    }

    private func setupLayout() {
        galleryCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-30)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(300)
        }

        gradientImageView.snp.makeConstraints { make in
            make.leading.equalTo(galleryCollectionView.snp.leading)
            make.trailing.equalTo(galleryCollectionView.snp.trailing)
            make.bottom.equalTo(galleryCollectionView.snp.bottom)
            make.height.equalTo(120)
        }

        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(gradientImageView.snp.bottom).offset(-10)
        }

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(galleryCollectionView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }

        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
            make.leading.equalToSuperview().offset(24)
            make.width.height.equalTo(40)
        }

        contentView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalTo(descLabel.snp.bottom).offset(100)
        }

        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.equalToSuperview().offset(24)
        }

        visitButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(mapUIView.snp.top).offset(-20)
            make.width.height.equalTo(50)
        }

        mapUIView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(220)
        }

        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        descLabel.snp.makeConstraints { make in
            make.top.equalTo(mapUIView.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
    }

    // MARK: - Public Methods

    // MARK: - Actions

    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Extensions

extension DetailsViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is CustomAnnotation == false {
            return nil
        }

        let senderAnnotation = annotation as! CustomAnnotation

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "CustomAnnotation")

        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: senderAnnotation, reuseIdentifier: "CustomAnnotation")
            annotationView!.canShowCallout = true
        }
        let pinImage = UIImage(named: "myCustomMark")

        annotationView!.image = pinImage

        return annotationView
    }
}

extension DetailsViewController: UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.width
        let cellHeight = collectionView.frame.height

        return CGSize(width: cellWidth, height: cellHeight)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: galleryCollectionView.contentOffset, size: galleryCollectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)

        if let indexPath = galleryCollectionView.indexPathForItem(at: visiblePoint) {
            pageControl.currentPage = indexPath.item
        }
    }
}

extension DetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        detailsViewModel.numberOfImages()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "galleryIdentifier", for: indexPath) as? GalleryViewCell else {
            return UICollectionViewCell()
        }

        if let galleryImage = detailsViewModel.getAnImage(at: indexPath.row) {
            cell.configure(with: galleryImage)
        }

        return cell
    }
}