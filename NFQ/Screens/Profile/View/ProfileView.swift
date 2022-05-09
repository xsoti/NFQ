//
//  ProfileView.swift
//  NFQ
//
//  Created by Michal Gumny on 08/05/2022.
//

import UIKit
import SnapKit
import RxSwift

class ProfileView: UIView {

    enum NFQInterfaceOrientation {
        case landscape
        case portrait
    }

    private let nameLabel = UILabel()
    private let addressLabel = UILabel()
    private let phoneLabel = UILabel()
    private let profileImageView = UIImageView()
    private let disposeBag = DisposeBag()

    private var deviceOrientation: NFQInterfaceOrientation {
        return self.frame.size.width > self.frame.size.height ? .landscape : .portrait
    }
    private var displayiedOrientation: NFQInterfaceOrientation!

    init(viewModel: ProfileViewModel,
         isPortrait: Bool) {
        super.init(frame: CGRect.zero)

        setupUI(viewModel: viewModel,
                isPortrait: isPortrait)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI(viewModel: ProfileViewModel,
                         isPortrait: Bool) {
        addSubview(nameLabel)
        addSubview(addressLabel)
        addSubview(phoneLabel)
        addSubview(profileImageView)

        profileImageView.activityStartAnimating()

        nameLabel.textAlignment = viewModel.textAlignment
        nameLabel.textColor = viewModel.textColor
        addressLabel.textAlignment = viewModel.textAlignment
        addressLabel.textColor = viewModel.textColor
        phoneLabel.textAlignment = viewModel.textAlignment
        phoneLabel.textColor = viewModel.textColor

        backgroundColor = viewModel.backgroundColor

        if isPortrait {
            setupPortraitOrientation()
        } else {
            setupLandscapeOrientation()
        }

        bindViewModel(viewModel)
    }

    private func bindViewModel(_ profileViewModel: ProfileViewModel) {
        profileViewModel.name
            .bind(to: nameLabel.rx.text)
            .disposed(by: disposeBag)

        profileViewModel.address
            .bind(to: addressLabel.rx.text)
            .disposed(by: disposeBag)

        profileViewModel.phone
            .bind(to: phoneLabel.rx.text)
            .disposed(by: disposeBag)

        profileViewModel.logoReplaySubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] image in
                if let weakSelf = self {
                    weakSelf.profileImageView.activityStopAnimating()
                    UIView.transition(with: weakSelf.profileImageView, duration: 0.3,
                                      options: .transitionCrossDissolve,
                                      animations: {
                        weakSelf.profileImageView.image = image
                    })
                }
            })
            .disposed(by: disposeBag)

        profileViewModel.orientationDidChange
            .subscribe(onNext: { [weak self] in
                if self?.displayiedOrientation != self?.deviceOrientation {
                    self?.updateViewConstraints()
                }
            })
            .disposed(by: disposeBag)
    }

    private func updateViewConstraints() {
        if deviceOrientation == .portrait {
            displayiedOrientation = .portrait
            setupPortraitOrientation()
        } else {
            displayiedOrientation = .landscape
            setupLandscapeOrientation()
        }
    }

    private func clearConstrains() {
        profileImageView.snp.removeConstraints()
        nameLabel.snp.removeConstraints()
        addressLabel.snp.removeConstraints()
        phoneLabel.snp.removeConstraints()
    }

    private func setupPortraitOrientation() {
        clearConstrains()

        profileImageView.snp.remakeConstraints { make in
            make.top.equalTo(self).offset(20)
            make.leading.equalTo(self).offset(30)
            make.trailing.equalTo(self).offset(-30)
            make.height.equalTo(profileImageView.snp.width)
            make.centerX.equalTo(self)
        }

        nameLabel.snp.remakeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(45)
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
            make.height.greaterThanOrEqualTo(0)
        }

        addressLabel.snp.remakeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(20)
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
            make.height.greaterThanOrEqualTo(0)
        }

        phoneLabel.snp.remakeConstraints { make in
            make.top.equalTo(addressLabel.snp.bottom).offset(20)
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
            make.height.greaterThanOrEqualTo(0)
        }
    }

    private func setupLandscapeOrientation() {
        clearConstrains()

        profileImageView.snp.remakeConstraints { make in
            make.centerY.equalTo(self.snp.centerY)
            make.height.equalTo(self.snp.height).multipliedBy(0.85)
            make.width.equalTo(self.snp.height).multipliedBy(0.85)
            make.leading.equalTo(self.snp.leadingMargin).offset(20)
        }

        nameLabel.snp.remakeConstraints { make in
            make.bottom.equalTo(addressLabel.snp.top).offset(-15)
            make.centerX.equalTo(self.snp.centerX).offset(170)
            make.trailing.equalTo(self)
            make.height.greaterThanOrEqualTo(0)
        }

        addressLabel.snp.remakeConstraints { make in
            make.centerY.equalTo(profileImageView.snp.centerY)
            make.leading.equalTo(nameLabel.snp.leading)
            make.trailing.equalTo(self)
            make.height.greaterThanOrEqualTo(0)
        }

        phoneLabel.snp.remakeConstraints { make in
            make.top.equalTo(addressLabel.snp.bottom).offset(15)
            make.leading.equalTo(nameLabel.snp.leading)
            make.trailing.equalTo(self)
            make.height.greaterThanOrEqualTo(0)
        }
    }
}
