//
//  HomeViewController.swift
//  Travio
//
//  Created by Furkan Kızmaz on 30.08.2023.
//

import SnapKit
import UIKit

class HomeViewController: UIViewController {
    // MARK: - Properties
    
    private lazy var titleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "home-logo")
        return imageView
    }()
    
    private lazy var componentsView = ComponentsView()

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = AppColor.primary.color
        view.addSubviews(titleImageView, componentsView)
        setupLayout()
    }
    
    private func setupLayout() {
        titleImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(64)
            make.width.equalTo(176)
        }
        
        componentsView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(titleImageView.snp.bottom).offset(32)
        }
    }
    
    // MARK: - Public Methods
    
    // MARK: - Actions Methods
}
