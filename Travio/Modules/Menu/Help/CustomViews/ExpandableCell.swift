//
//  ExpandableCell.swift
//  Travio
//
//  Created by Furkan Kızmaz on 11.09.2023.
//

import UIKit

class ExpandableCell: UICollectionViewCell {
    // MARK: - Properties

    weak var collectionView: UICollectionView?
    static let identifier = "ExpandableCell"
    private var isExpanded = false

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
        label.isHidden = true
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var expandButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(expandButtonTapped), for: .touchUpInside)
        button.setImage(UIImage(named: "expandIcon"), for: .normal)
        return button
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    // MARK: - Private Methods
    
    private func setupViews() {
        backgroundColor = .white
        clipsToBounds = true
        layer.cornerRadius = 16
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner]
        addShadow()
        addSubviews(questionLabel, answerLabel, expandButton)
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
        
        expandButton.snp.makeConstraints { make in
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
        answerLabel.text = item.answer
    }
    
    // MARK: - Actions
    
    @objc func expandButtonTapped() {
        isExpanded.toggle()
        updateLabel()
        collectionView?.performBatchUpdates(nil, completion: nil)
    }

    private func updateLabel() {
        if isExpanded {
            expandButton.setImage(UIImage(named: "expandIcon")?.rotate180Degrees(), for: .normal)
            answerLabel.isHidden = false
        } else {
            expandButton.setImage(UIImage(named: "expandIcon"), for: .normal)
            answerLabel.isHidden = true
        }
    }
}
