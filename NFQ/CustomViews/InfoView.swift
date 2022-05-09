//
//  InfoView.swift
//  NFQ
//
//  Created by Michal Gumny on 07/05/2022.
//

import UIKit
import SnapKit

class InfoView: UIView {
    static let defaultAlpha = 0.95
    static let defaultSideSize = 180

    init(title: String,
         message: String,
         buttonTitle: String) {
        super.init(frame: CGRect.zero)

        backgroundColor = .orange
        alpha = 0.92

        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 2

        setupSubviews(title: title,
                      message: message,
                      buttonTitle: buttonTitle)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupSubviews(title: String,
                       message: String,
                       buttonTitle: String) {
        let titleLabel = UILabel.init(frame: CGRect.zero)
        addSubview(titleLabel)

        titleLabel.text = title
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self).offset(15)
            make.height.greaterThanOrEqualTo(0)
            make.width.greaterThanOrEqualTo(0)
            make.centerX.equalTo(self.snp.centerX)
        }

        let messageLabel = UILabel.init(frame: CGRect.zero)
        messageLabel.text = message
        messageLabel.textColor = .white
        messageLabel.numberOfLines = 0
        messageLabel.font = UIFont.systemFont(ofSize: 14)
        messageLabel.textAlignment = .center
        addSubview(messageLabel)

        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.leading.equalTo(self.snp.leading).offset(15)
            make.trailing.equalTo(self.snp.trailing).offset(-15)
        }

        let button = UIButton.init(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        button.setTitle(buttonTitle, for: .normal)
        button.titleLabel?.textColor = .white
        button.layer.cornerRadius = 5.0
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)

        button.addTarget(self, action: #selector(close), for: .touchUpInside)

        addSubview(button)

        button.snp.makeConstraints { make in
            make.bottom.equalTo(self.snp.bottom).offset(-15)
            make.height.equalTo(44)
            make.width.equalTo(100)
            make.centerX.equalTo(self.snp.centerX)
        }
    }

    @objc func close() {
        UIView.animate(withDuration: 0.4) {
            self.alpha = 0
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
}
