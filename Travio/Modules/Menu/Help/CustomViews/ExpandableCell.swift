//
//  ExpandableCell.swift
//  Travio
//
//  Created by Furkan Kızmaz on 11.09.2023.
//

import UIKit

class ExpandableCell: UICollectionViewCell {
    // MARK: - Properties
    
    static let identifier = "ExpandableCell"
    var isExpanded: Bool = false
    var collectionView: UICollectionView?
    var indexPath: IndexPath?

    private lazy var questionLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.poppinsMedium.withSize(14)
        label.textColor = AppColor.secondary.color
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var answerLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.poppinsLight.withSize(10)
        label.textColor = AppColor.secondary.color
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var expandImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "expandIcon")
        return imageView
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Private Methods
    
    private func setupViews() {
        backgroundColor = .white
        clipsToBounds = true
        layer.cornerRadius = 16
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner]
        addShadow()
        addSubviews(questionLabel, answerLabel, expandImageView)
        setupLayout()
    }
    
    private func addShadow() {
        layer.shadowRadius = 8
        layer.shadowOpacity = 0.15
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowColor = AppColor.secondary.color.cgColor
        layer.masksToBounds = false
    }
    
    private func setupLayout() {
        questionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-46)
        }
        
        expandImageView.snp.makeConstraints { make in
            make.centerY.equalTo(questionLabel.snp.centerY)
            make.leading.equalTo(questionLabel.snp.trailing).offset(16)
            make.width.equalTo(16)
            make.height.equalTo(10)
        }
        
        answerLabel.snp.makeConstraints { make in
            make.top.equalTo(questionLabel.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview().offset(-16)
        }
    }

    // MARK: - Cell Configuration
    
    func configure(with item: FAQItem) {
        questionLabel.text = item.question
        answerLabel.text = isExpanded ? item.answer : nil
    }
    
    // MARK: - Actions
    
    @objc func handleTap() {
        isExpanded.toggle()
        print("deneme")
        collectionView?.reloadItems(at: [indexPath!])
    }
}
