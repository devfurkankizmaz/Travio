//
//  PrivacyViewCell.swift
//  Travio
//
//  Created by Muhammet on 10.09.2023.
//

import UIKit

class PrivacyViewCell: UITableViewCell {

    public var identifier = "privacyCell"
    
    private lazy var privacyView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return view
    }()
    
    private lazy var privacyLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.poppinsMedium.withSize(14)
        label.textAlignment = .center
        label.text = ""
        label.textColor = #colorLiteral(red: 0.2392156863, green: 0.2392156863, blue: 0.2392156863, alpha: 1)
        return label
    }()
    
    private lazy var toggle:UISwitch = {
        let s = UISwitch()

        s.isOn = false
        s.onTintColor = .green
        return s
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
        privacyView.roundCorners(corners: [.topLeft, .topRight, .bottomLeft], radius: 16)
        self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0))
    }
    
    public func configure(model: String) {
        privacyLabel.text = model
        
    }

    private func setupView() {
        contentView.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)
        contentView.addSubviews(privacyView)
        privacyView.addSubviews(privacyLabel, toggle)
        setupLayout()
    }
    
    private func setupLayout() {
        
        privacyView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(74)
        }
        privacyLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        toggle.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
    }
}
