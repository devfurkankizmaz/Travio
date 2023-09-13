//
//  CustomVisitCell.swift
//  Travio
//
//  Created by Furkan Kızmaz on 19.08.2023.
//

import Foundation
import Kingfisher
import UIKit

class GalleryViewCell: UICollectionViewCell {
    // MARK: - Properties

    private var imageDownloader: DownloadTask?

    private lazy var galleryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "failed")
        return imageView
    }()

    private lazy var gradientView: UIView = {
        let view = UIView()
        return view
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        galleryImageView.kf.cancelDownloadTask()
        galleryImageView.image = nil
    }

    // MARK: - Private Methods

    private func setupView() {
        contentView.addSubviews(galleryImageView, gradientView)
        setupLayout()
        gradientView.applyGradient(type: .light, view: contentView)
    }

    private func setupLayout() {
        galleryImageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.snp.edges)
        }

        gradientView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: - Public Methods

    public func configure(with image: Image) {
        imageDownloader?.cancel()
        let url = image.imageURL
        if !url.isValidURL {
            galleryImageView.image = UIImage(named: "failed")
            return
        }

        galleryImageView.kf.setImage(
            with: URL(string: url),
            completionHandler: { [weak self] result in
                switch result {
                case .success:
                    break
                case .failure:
                    self?.galleryImageView.image = UIImage(named: "failed")
                }
            }
        )
    }

    // MARK: - Actions
}

// MARK: - Extensions
