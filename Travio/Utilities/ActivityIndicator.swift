//
//  ActivityIndicator.swift
//  Travio
//
//  Created by Furkan Kızmaz on 8.09.2023.
//

import UIKit

final class ActivityIndicator {
    static let shared = ActivityIndicator()
    
    private var blurEffectView: UIVisualEffectView?
    private let activityIndicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        return indicator
    }()
    
    private init() {}
    
    func startAnimating() {
        guard let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }

        let blurEffect = UIBlurEffect(style: .dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView?.frame = keyWindow.frame
        blurEffectView?.alpha = 0.6
        keyWindow.addSubview(blurEffectView!)
        
        activityIndicatorView.center = keyWindow.center
        keyWindow.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
    }
    
    func stopAnimating() {
        blurEffectView?.removeFromSuperview()
        activityIndicatorView.stopAnimating()
        activityIndicatorView.removeFromSuperview()
    }
}
