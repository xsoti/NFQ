//
//  AppCoordinator.swift
//  NFQ
//
//  Created by Michal Gumny on 03/05/2022.
//

import UIKit

class AppCoordinator {

    private var window: UIWindow?
    private var navigationController: UINavigationController?
    lazy private var persistenceManager = PersistenceManager()
    lazy private var networkManager = NetworkManager()

    func start(with scene: UIWindowScene) {

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.windowScene = scene

        if persistenceManager.loggedInStatus == false {
            showLoginView()
        } else {
            showLoginView()
            showProfileView()
        }

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    private func showLoginView(animated: Bool = false) {
        let loginViewModel = LoginViewModel(networkManager: networkManager,
                                            persistenceManager: persistenceManager)
        let loginViewController = LoginViewController(viewModel: loginViewModel)
        loginViewController.delegate = self
        navigationController = UINavigationController(rootViewController: loginViewController)
    }

    private func showProfileView(animated: Bool = false) {
        let viewModel = ProfileViewModel(networkManager: networkManager,
                                         persistenceManager: persistenceManager)
        let profileViewController = ProfileViewController(viewModel: viewModel)
        profileViewController.delegate = self

        if !animated {
            navigationController?.pushViewController(profileViewController, animated: false)
        } else {
            UIView.transition(with: (self.navigationController?.view)!,
                              duration: 0.75,
                              options: .transitionFlipFromLeft,
                              animations: {
                self.navigationController?.pushViewController(profileViewController,
                                                              animated: true)
            })
        }
    }
}

extension AppCoordinator: LoginViewControllerDelegate {
    func didSuccessfullyLogin() {
        showProfileView(animated: true)
    }
}

extension AppCoordinator: ProfileViewControllerDelegate {
    func logoutTapped() {
        UIView.transition(with: (self.navigationController?.view)!,
                          duration: 0.75,
                          options: .transitionFlipFromRight,
                          animations: {
            self.navigationController?.popViewController(animated: true)
        })
    }
}
