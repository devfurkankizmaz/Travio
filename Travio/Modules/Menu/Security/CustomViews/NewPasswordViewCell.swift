//
//  NewPasswordViewCell.swift
//  Travio
//
//  Created by Muhammet on 10.09.2023.
//

import UIKit
import SnapKit

class NewPasswordViewCell: UITableViewCell {

    public var identifier = "newPassowrdCell"
    
    public lazy var changePasswordView: TravioUIView = {
        let view = TravioUIView()
        view.placeholderText = ""
        view.titleView = ""
        return view
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        setupView()
    }
    
    public func configure(model: String) {
        
        changePasswordView.titleView = model
    }
    
    private func setupView() {
        contentView.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)
        contentView.addSubviews(changePasswordView)
        setupLayout()
    }
    
    private func setupLayout() {
        
        changePasswordView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-8)
        }
    }
}
