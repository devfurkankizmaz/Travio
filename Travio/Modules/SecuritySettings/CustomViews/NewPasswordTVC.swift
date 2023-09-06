//
//  NewPasswordTVC.swift
//  Travio
//
//  Created by Muhammet on 3.09.2023.
//

import UIKit
import SnapKit

class NewPasswordTVC: UITableViewCell {

    public var identifier = "newPassowrdCell"
    
    private lazy var changePasswordView: TravioUIView = {
        let view = TravioUIView()
        view.placeholderText = ""
        view.titleView = ""
        return view
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0))
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
            make.height.equalTo(74)
        }
    }
}
