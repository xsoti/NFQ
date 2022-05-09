//
//  ProfileViewModel.swift
//  NFQ
//
//  Created by Michal Gumny on 05/05/2022.
//

import UIKit
import RxSwift

class ProfileViewModel: ViewModel {
    let name =  BehaviorSubject<String>(value: "")
    let address =  BehaviorSubject<String>(value: "")
    let phone =  BehaviorSubject<String>(value: "")
    let orientationDidChange = PublishSubject<Void>()
    let profileError = ReplaySubject<NFQError>.create(bufferSize: 1)
    let textAlignment = NSTextAlignment.center

    override func start() {
        super.start()

        networkManager.fetchProfile(token: persistenceManager.token!)
            .flatMap { [weak self] response -> Observable<String> in
                switch response {
                case .succcess(response: let user):
                    self?.name.onNext("\(user.firstName) \(user.lastName)")
                    self?.address.onNext(user.address)
                    self?.phone.onNext(user.phone)
                    return Observable.just(user.image)
                case .failure(error: let error):
                    self?.profileError.onNext(error)
                    throw error
                }
            }
            .flatMap { imageUrl -> Observable<UIImage> in
                self.fetchProfileImage(url: imageUrl)
            }
            .subscribe(onNext: { [weak self] image in
                self?.logoReplaySubject.onNext(image)

            })
            .disposed(by: disposeBag)

        handleOrientation()
    }

    private func fetchProfileImage(url: String) -> Observable<UIImage> {
        return networkManager.fetchImage(urlString: url)
            .flatMap { data -> Observable<UIImage> in
                if let image = UIImage(data: data) {
                    return Observable.just(image)
                } else {
                    throw NFQError.unknownError
                }
            }
    }

    private func handleOrientation() {
        NotificationCenter.default.rx.notification(UIDevice.orientationDidChangeNotification)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.orientationDidChange.onNext(())
            }).disposed(by: disposeBag)
    }

    func logout() {
        persistenceManager.loggedInStatus = false
    }
}
