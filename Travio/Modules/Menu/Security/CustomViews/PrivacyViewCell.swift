//
//  PrivacyViewCell.swift
//  Travio
//
//  Created by Muhammet on 10.09.2023.
//

import UIKit
import AVFoundation
import Photos
import CoreLocation
import SnapKit

class PrivacyViewCell: UITableViewCell {

    public var identifier = "privacyCell"
    
    private lazy var privacyView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
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
    
    public lazy var toggle:UISwitch = {
        let s = UISwitch()

        s.isOn = false
        s.onTintColor = .green
        return s
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        privacyView.roundCorners(corners: [.topLeft, .topRight, .bottomLeft], radius: 16)
    }
    
    public func configure(model: String, permissionType: PermissionType) {
        privacyLabel.text = model
        
    }

    private func setupView() {
        contentView.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)
        contentView.addSubviews(privacyView)
        privacyView.addSubviews(privacyLabel, toggle)
        setupLayout()
        addShadow()
    }
    
    private func addShadow() {
            layer.shadowRadius = 8
            layer.shadowOpacity = 0.15
            layer.shadowOffset = CGSize(width: 0, height: 0)
            layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.15)
            layer.masksToBounds = false
        }
    
    private func setupLayout() {
        
        privacyView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-8)
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
