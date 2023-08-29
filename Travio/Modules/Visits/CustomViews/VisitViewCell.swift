import Foundation
import Kingfisher
import UIKit

class VisitViewCell: UICollectionViewCell {
    // MARK: - Properties

    private var imageDownloader: DownloadTask?

    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        // imageView.alpha = 0.5
        return imageView
    }()

    private lazy var gradientImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "grad")
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
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.poppinsRegular.withSize(24)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()

    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.poppinsRegular.withSize(14)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()

    private lazy var locationStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alpha = 0.6
        sv.spacing = 6
        return sv
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

    private func addShadow() {
        contentView.layer.shadowRadius = 8
        contentView.layer.shadowOpacity = 0.25
        contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
        contentView.layer.shadowColor = AppColor.secondary.color.cgColor
        contentView.layer.masksToBounds = false
    }

    private func setupView() {
        addShadow()
        contentView.backgroundColor = AppColor.background.color
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 16

        backgroundImageView.addSubviews(indicator)
        contentView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner]
        locationStackView.addArrangedSubviews(locationImageView, locationLabel)
        contentView.addSubviews(backgroundImageView, gradientImageView, locationStackView, titleLabel)
        contentView.sendSubviewToBack(backgroundImageView)
        setupLayout()
    }

    private func setupLayout() {
        indicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        gradientImageView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(110)
        }
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        locationImageView.snp.makeConstraints { make in
            make.width.equalTo(10)
            make.height.equalTo(15)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.bottom.equalTo(locationStackView.snp.top)
        }

        locationStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
        }
    }

    // MARK: - Public Methods

    public func configure(with visit: Visit) {
        locationLabel.text = visit.place.place
        titleLabel.text = visit.place.title
        imageDownloader?.cancel()

        guard let urlStr = visit.place.cover_image_url else {
            backgroundImageView.image = UIImage(named: "imageNotFound")
            return
        }
        if !urlStr.isValidURL {
            backgroundImageView.image = UIImage(named: "imageNotFound")
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
                    self.backgroundImageView.image = UIImage(named: "imageNotFound")
                }
            }
        )
    }

    // MARK: - Actions
}

// MARK: - Extensions
