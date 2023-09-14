import Foundation
import Kingfisher
import UIKit

class PlaceViewCell: UICollectionViewCell {
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

    private lazy var gradientView: UIView = {
        let view = UIView()
        return view
    }()

    private lazy var locationImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "location")?.withRenderingMode(.alwaysTemplate)
        imageView.image = image
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
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
        sv.spacing = 6
        return sv
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.poppinsSemiBold.withSize(24)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = .white
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

    private func addShadow() {
        contentView.layer.shadowRadius = 8
        contentView.layer.shadowOpacity = 0.25
        contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
        contentView.layer.shadowColor = AppColor.secondary.color.cgColor
        contentView.layer.masksToBounds = false
    }

    private func setupView() {
        addShadow()
        contentView.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 0.7474273036)
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 16

        backgroundImageView.addSubviews(indicator)
        contentView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner]
        locationStackView.addArrangedSubviews(locationImageView, locationLabel)
        contentView.addSubviews(backgroundImageView, gradientView, titleLabel, locationStackView)
        contentView.sendSubviewToBack(backgroundImageView)
        setupLayout()
        gradientView.applyGradient(type: .dark, view: contentView)
    }

    private func setupLayout() {
        indicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        gradientView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        locationImageView.snp.makeConstraints { make in
            make.width.equalTo(9)
            make.height.equalTo(12)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
            make.bottom.equalTo(locationStackView.snp.top).offset(-8)
        }
        locationStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-16)
        }
    }

    // MARK: - Public Methods

    public func configure(with place: Place) {
        locationLabel.text = place.place
        titleLabel.text = place.title
        imageDownloader?.cancel()
        gradientView.isHidden = true
        backgroundImageView.contentMode = .scaleAspectFill

        guard let urlStr = place.coverImageUrl else {
            backgroundImageView.image = UIImage(named: "failed")
            backgroundImageView.contentMode = .center

            return
        }
        if !urlStr.isValidURL {
            backgroundImageView.image = UIImage(named: "failed")
            backgroundImageView.contentMode = .center

            return
        }

        indicator.startAnimating()

        backgroundImageView.kf.setImage(
            with: URL(string: urlStr),
            completionHandler: { [weak self] result in

                self?.indicator.stopAnimating()
                self?.indicator.removeFromSuperview()
                self?.gradientView.isHidden = false

                switch result {
                case .success:
                    self?.gradientView.isHidden = false
                case .failure:
                    self?.backgroundImageView.image = UIImage(named: "failed")
                    self?.backgroundImageView.contentMode = .center
                    self?.gradientView.isHidden = true
                }
            }
        )
    }

    // MARK: - Actions
}

// MARK: - Extensions
