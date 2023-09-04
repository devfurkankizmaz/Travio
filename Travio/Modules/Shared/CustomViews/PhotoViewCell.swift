//
//  CustomVisitCell.swift
//  Travio
//
//  Created by Furkan Kızmaz on 19.08.2023.
//

import Foundation
import Kingfisher
import UIKit

class PhotoViewCell: UICollectionViewCell {
    // MARK: - Properties

    weak var delegate: PhotoCellDelegate?
    var collectionViewIndexPath: IndexPath?
    private var imageDownloader: DownloadTask?

    private lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "addPhoto")
        return imageView
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var removeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.tintColor = .red
        button.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)
        return button
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

    // MARK: - Private Methods

    private func addShadow() {
        contentView.layer.shadowRadius = 8
        contentView.layer.shadowOpacity = 0.25
        contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
        contentView.layer.shadowColor = AppColor.secondary.color.cgColor
        contentView.layer.masksToBounds = false
    }

    private func setupView() {
        contentView.backgroundColor = .white
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 16
        contentView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner]
        imageView.layer.cornerRadius = 16
        imageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner]
        contentView.addSubviews(photoImageView, imageView, removeButton)
        addShadow()
        setupLayout()
    }

    private func setupLayout() {
        photoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(60)
        }

        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        removeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.width.height.equalTo(32)
        }
    }

    // MARK: - Public Methods

    func configure(image: UIImage?) {
        if let image = image {
            imageView.image = image
            imageView.isHidden = false
            removeButton.isHidden = false
        } else {
            imageView.isHidden = true
            removeButton.isHidden = true
        }
    }

    // MARK: - Actions

    @objc private func removeButtonTapped() {
        if let indexPath = collectionViewIndexPath {
            delegate?.photoCellDidTapRemoveButton(at: indexPath)
        }
    }
}

// MARK: - Extensions
