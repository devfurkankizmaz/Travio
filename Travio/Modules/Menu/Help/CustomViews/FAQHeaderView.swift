//
//  FAQHeaderView.swift
//  Travio
//
//  Created by Furkan Kızmaz on 13.09.2023.
//

import SnapKit
import UIKit

class FAQHeaderView: UICollectionReusableView {
    static let identifier = "FAQHeaderView"
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = AppFont.poppinsSemiBold.withSize(24)
        label.textColor = AppColor.primary.color
        label.text = "FAQ"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        addSubview(label)
        
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.bottom.equalToSuperview()
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
