//
//  ProfileViewController.swift
//  NFQ
//
//  Created by Michal Gumny on 03/05/2022.
//

import UIKit
import RxSwift
import RxCocoa

protocol ProfileViewControllerDelegate: AnyObject {
    func logoutTapped()
}

class ProfileViewController: UIViewController {
    private let profileViewModel: ProfileViewModel!
    weak var delegate: ProfileViewControllerDelegate?

    init(viewModel: ProfileViewModel) {
        profileViewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: Localizable.Profile.logout.localized,
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(logoutTapped))
        navigationItem.rightBarButtonItem?.tintColor = profileViewModel.textColor
        view.backgroundColor = profileViewModel.backgroundColor
    }

    private func setupUI() {
        let isPortrait = view.frame.size.height > view.frame.size.width ? true : false
        let profileView = ProfileView(viewModel: profileViewModel, isPortrait: isPortrait)
        view.addSubview(profileView)

        profileView.snp.makeConstraints { make in
            make.top.equalTo(self.view.snp.topMargin)
            make.leading.equalTo(self.view.snp.leading)
            make.trailing.equalTo(self.view.snp.trailing)
            make.bottom.equalTo(self.view.snp.bottomMargin)
        }
    }

    @objc func logoutTapped() {
        profileViewModel.logout()
        delegate?.logoutTapped()
    }
}
