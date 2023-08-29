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
        // imageView.alpha = 0.5
        return imageView
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
        contentView.addSubviews(galleryImageView)
        setupLayout()
    }

    private func setupLayout() {
        galleryImageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.snp.edges)
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
