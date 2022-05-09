//
//  UIView+Extensions.swift
//  NFQ
//
//  Created by Michal Gumny on 07/05/2022.
//

import UIKit
import SnapKit

extension UIView {

    enum ActivityAlignment {
        case right
        case center
    }

    func activityStartAnimating(color: UIColor = .gray,
                                alignment: ActivityAlignment = .center,
                                style: UIActivityIndicatorView.Style = .large) {
        var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicator = UIActivityIndicatorView(style: style)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = color
        activityIndicator.startAnimating()

        addSubview(activityIndicator)

        if alignment == .center {
            activityIndicator.snp.makeConstraints { make in
                make.center.equalTo(self)
            }
        } else {
            activityIndicator.snp.makeConstraints { make in
                make.centerY.equalTo(self)
                make.trailing.equalTo(self.snp.trailing).offset(-15)
            }
        }
    }

    func activityStopAnimating() {
        for view in subviews {
            if let activityView = view as? UIActivityIndicatorView {
                activityView.removeFromSuperview()
            }
        }
    }
}
