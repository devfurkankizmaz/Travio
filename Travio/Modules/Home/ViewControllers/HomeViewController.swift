//
//  HomeViewController.swift
//  Travio
//
//  Created by Furkan Kızmaz on 30.08.2023.
//

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
        setupLayout()
    }
    
    private func setupLayout() {
        
    }
    
    // MARK: - Public Methods
    
    // MARK: - Actions Methods
}
