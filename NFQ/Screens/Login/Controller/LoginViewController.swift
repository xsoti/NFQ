//
//  ViewController.swift
//  NFQ
//
//  Created by Michal Gumny on 03/05/2022.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

protocol LoginViewControllerDelegate: AnyObject {
    func didSuccessfullyLogin()
}

class LoginViewController: UIViewController {
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var logoImageView: UIImageView!

    private var loginViewModel: LoginViewModel
    private var bottomOffsetWithoutKeyboard: CGFloat!
    weak var delegate: LoginViewControllerDelegate?
    private let disposeBag = DisposeBag()

    init(viewModel: LoginViewModel) {
        loginViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        handleKeyboard()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loginViewModel.updateLogo()
    }

    private func setupUI() {
        logoImageView.activityStartAnimating()

        view.backgroundColor = loginViewModel.backgroundColor

        userNameTextField.attributedPlaceholder = loginViewModel.usernamePlaceholder
        userNameTextField.backgroundColor = loginViewModel.textFieldBackgroundColor
        userNameTextField.setLeftPaddingPoints(loginViewModel.textFieldLeftPadding)
        userNameTextField.layer.borderColor = loginViewModel.borderColor
        userNameTextField.layer.borderWidth = loginViewModel.borderWidth

        passwordTextField.attributedPlaceholder = loginViewModel.passwordPlaceholder
        passwordTextField.backgroundColor = loginViewModel.textFieldBackgroundColor
        passwordTextField.setLeftPaddingPoints(loginViewModel.textFieldLeftPadding)
        passwordTextField.layer.borderColor = loginViewModel.borderColor
        passwordTextField.layer.borderWidth = loginViewModel.borderWidth

        submitButton.backgroundColor = loginViewModel.buttonBackgroundColor
        submitButton.setTitleColor(loginViewModel.buttonTitleColor, for: .normal)
        submitButton.layer.cornerRadius = loginViewModel.buttonCornerRadius
        submitButton.layer.borderColor = loginViewModel.borderColor
        submitButton.layer.borderWidth = loginViewModel.borderWidth

        bindViewModel()
    }

    private func bindViewModel() {
        loginViewModel.logoReplaySubject
            .subscribe(onNext: { [weak self] image in
                if let weakSelf = self {
                    weakSelf.logoImageView.activityStopAnimating()
                    UIView.transition(with: weakSelf.logoImageView, duration: 0.3,
                                      options: .transitionCrossDissolve,
                                      animations: {
                        weakSelf.logoImageView.image = image
                    })
                }
            })
            .disposed(by: disposeBag)

        passwordTextField.rx.text
            .orEmpty
            .asDriver()
            .drive(loginViewModel.password)
            .disposed(by: disposeBag)

        userNameTextField.rx.text
            .orEmpty
            .asDriver()
            .drive(loginViewModel.username)
            .disposed(by: disposeBag)

        loginViewModel.enableSubmit
            .bind(to: submitButton.rx.isEnabled)
            .disposed(by: disposeBag)

        handleSubmitButton()
    }

    private func handleSubmitButton() {
        submitButton.rx.tap
            .flatMapLatest { [weak self] _ -> Observable<Bool> in
                if let weakSelf = self {
                    self?.dismissKeyboard()
                    weakSelf.submitButton.activityStartAnimating(color: .white,
                                                                 alignment: .right,
                                                                 style: .medium)
                    return weakSelf.loginViewModel.submit(username: weakSelf.userNameTextField.text!,
                                                          password: weakSelf.passwordTextField.text!)
                } else {
                    throw NFQError.unknownError
                }
            }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                self?.submitButton.activityStopAnimating()
                if result == true {
                    self?.showProfile()
                } else {
                    self?.displayError()
                }
            })
            .disposed(by: disposeBag)
    }

    private func handleKeyboard() {
        hideKeyboardOnTap()

        keyboardHeight()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { height in
                self.adjustViewPosition(for: height)
            })
            .disposed(by: disposeBag)
    }

    private func adjustViewPosition(for keyboardHeight: CGFloat) {
        let offset: CGFloat = 10

        UIView.animate(withDuration: 0.2) {
            self.view.safeAreaLayoutGuide.snp.updateConstraints { make in
                if keyboardHeight == 0 {
                    make.bottom.greaterThanOrEqualTo(self.submitButton.snp.bottom).offset(offset)
                } else {
                    make.bottom.greaterThanOrEqualTo(self.submitButton.snp.bottom).offset(keyboardHeight + offset)
                }
            }
            self.view.layoutIfNeeded()
        }
    }

    private func displayError() {
        let infoView = InfoView(title: Localizable.Login.errorTitle.localized,
                                message: Localizable.Login.errorMessage.localized,
                                buttonTitle: Localizable.Login.buttonTitle.localized)
        infoView.alpha = 0
        view.addSubview(infoView)
        infoView.snp.makeConstraints { make in
            make.width.equalTo(InfoView.defaultSideSize)
            make.height.equalTo(InfoView.defaultSideSize)
            make.centerX.equalTo(logoImageView.snp.centerX)
            make.centerY.equalTo(logoImageView.snp.centerY).offset(40)
        }
        self.view.layoutIfNeeded()

        UIView.animate(withDuration: 0.2) {
            infoView.alpha = InfoView.defaultAlpha
            self.view.layoutIfNeeded()
        }
    }

    private func showProfile() {
        delegate?.didSuccessfullyLogin()
    }
}
