import Foundation
import Kingfisher
import UIKit

class ListViewCell: UICollectionViewCell {
    // MARK: - Properties

    private var imageDownloader: DownloadTask?

    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.color = .white
        indicator.style = .medium
        return indicator
    }()

    private lazy var locationImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "location")?.withRenderingMode(.alwaysTemplate)
        imageView.image = image
        imageView.tintColor = AppColor.secondary.color
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.poppinsRegular.withSize(14)
        label.textAlignment = .center
        label.textColor = AppColor.secondary.color
        return label
    }()

    private lazy var locationStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 6
        return sv
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.poppinsSemiBold.withSize(24)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = AppColor.secondary.color
        return label
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
        backgroundImageView.kf.cancelDownloadTask()
        backgroundImageView.image = nil
    }

    // MARK: - Private Methods

    private func setupView() {
        contentView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 16
        backgroundImageView.addSubviews(indicator)
        contentView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner]
        locationStackView.addArrangedSubviews(locationImageView, locationLabel)
        contentView.addSubviews(backgroundImageView, titleLabel, locationStackView)
        contentView.sendSubviewToBack(backgroundImageView)
        setupLayout()
    }

    private func setupLayout() {
        indicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        backgroundImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.width.height.equalTo(90)
        }

        locationImageView.snp.makeConstraints { make in
            make.width.equalTo(9)
            make.height.equalTo(12)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(backgroundImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.top.equalToSuperview().offset(16)
        }
        locationStackView.snp.makeConstraints { make in
            make.leading.equalTo(backgroundImageView.snp.trailing).offset(8)
            make.bottom.equalToSuperview().offset(-16)
        }
    }

    // MARK: - Public Methods

    public func configure(with place: Place) {
        locationLabel.text = place.place
        titleLabel.text = place.title
        imageDownloader?.cancel()

        guard let urlStr = place.cover_image_url else {
            backgroundImageView.image = UIImage(named: "failed")
            return
        }
        if !urlStr.isValidURL {
            backgroundImageView.image = UIImage(named: "failed")
            return
        }

        indicator.startAnimating()

        backgroundImageView.kf.setImage(
            with: URL(string: urlStr),
            completionHandler: { [weak indicator] result in

                indicator?.stopAnimating()
                indicator?.removeFromSuperview()
                switch result {
                case .success:
                    break
                case .failure:
                    self.backgroundImageView.image = UIImage(named: "failed")
                }
            }
        )
    }

    // MARK: - Actions
}

// MARK: - Extensions
