import Foundation
import Kingfisher
import UIKit

class SettingsViewCell: UICollectionViewCell {
    private lazy var bView: UIView = {
            let view = UIView()
           view.backgroundColor = .white
           view.layer.cornerRadius = 16
           view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner]
           return view
        }()
    
    private let leftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppFont.poppinsLight.withSize(14)
        label.textColor = AppColor.secondary.color
        return label
    }()

    private let rightImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "settingsArrow"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        addSubview(bView)
        bView.addSubviews(leftImageView, label, rightImageView)
        setupLayouts()
        contentView.clipsToBounds = false
        addShadow()
    }
    
    func addShadow() {
        layer.shadowRadius = 8
        layer.shadowOpacity = 0.15
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowColor = AppColor.secondary.color.cgColor
        layer.masksToBounds = false
    }
    
    func setupLayouts() {
        
        bView.snp.makeConstraints { make in
                  make.leading.top.equalToSuperview()
                  make.trailing.bottom.equalToSuperview()
              }
      
              leftImageView.snp.makeConstraints { make in
                  make.centerY.equalToSuperview()
                  make.leading.equalToSuperview().offset(17)
                  make.height.width.equalTo(20)
              }
      
              label.snp.makeConstraints { make in
                  make.centerY.equalToSuperview()
                  make.leading.equalTo(leftImageView.snp.trailing).offset(9)
              }
      
              rightImageView.snp.makeConstraints { make in
                  make.centerY.equalToSuperview()
                  make.trailing.equalToSuperview().offset(-17)
                  make.height.equalTo(15.5)
                  make.width.equalTo(10.5)
              }
    }
    
    func configure(model: SettingsModel) {
        leftImageView.image = UIImage(named: model.leftImage)
        label.text = model.text
    }
}
