//
//  LoginViewModel.swift
//  NFQ
//
//  Created by Michal Gumny on 05/05/2022.
//

import UIKit
import RxSwift

class LoginViewModel: ViewModel {

    var enableSubmit: Observable<Bool>!
    let username =  BehaviorSubject<String>(value: "")
    let password =  BehaviorSubject<String>(value: "")
    let isNotRegistering = BehaviorSubject<Bool>(value: true)
    let usernamePlaceholder = NSAttributedString(string: Localizable.Login.username.localized,
                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    let passwordPlaceholder = NSAttributedString(string: Localizable.Login.password.localized,
                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    let textFieldBackgroundColor = UIColor.orange
    let borderColor = UIColor.white.cgColor
    let borderWidth = 2.0
    let textFieldLeftPadding = 5.0
    let buttonBackgroundColor = UIColor.orange
    let buttonTitleColor = UIColor.white
    let buttonCornerRadius = 5.0
    private let minPasswordLenght = 3

    override func start() {
        let fieldsAreValid = BehaviorSubject.combineLatest(username,
                                                           password) { [weak self] in
            return $0.isValidEmail && $1.count > self?.minPasswordLenght ?? 0
        }

        enableSubmit = BehaviorSubject.combineLatest(fieldsAreValid, isNotRegistering) {
            return $0 && $1
        }
    }

    func updateLogo() {
        networkManager.fetchLogo()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] imageData in
                if let image = UIImage(data: imageData) {
                    self?.logoReplaySubject.onNext(image)
                }
            })
            .disposed(by: disposeBag)
    }

    func submit(username: String,
                password: String) -> Observable<Bool> {
        isNotRegistering.onNext(false)
        return networkManager.login(user: username,
                                    password: password)
            .flatMap { [weak self] networkResponse -> Observable<Bool> in
                self?.isNotRegistering.onNext(true)
                switch networkResponse {
                case .succcess(response: let credentials):
                    self?.persistenceManager.token = credentials.token
                    self?.persistenceManager.loggedInStatus = true
                    return Observable.just(true)
                case .failure:
                    return Observable.just(false)
                }
            }
    }
}
