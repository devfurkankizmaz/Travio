import Foundation
import Kingfisher
import UIKit

class SettingsViewCell: UICollectionViewCell {
    private lazy var bView: UIView = {
            let view = UIView()
           view.backgroundColor = .white
            view.layer.cornerRadius = 16
            view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner]
            view.layer.shadowColor = UIColor.black.cgColor
            view.layer.shadowOffset = CGSize(width: 0, height: 0)
           view.layer.shadowOpacity = 0.15
            view.layer.shadowRadius = 4
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
        label.textColor = #colorLiteral(red: 0.2392156863, green: 0.2392156863, blue: 0.2392156863, alpha: 1)
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
        
    }

    private func setupView() {
        addSubview(bView)
        bView.addSubviews(leftImageView, label, rightImageView)
        setupLayouts()
    }
    
    func setupLayouts() {
        
        bView.snp.makeConstraints { make in
                  make.leading.top.equalToSuperview().offset(2)
                  make.trailing.bottom.equalToSuperview().offset(-2)
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
