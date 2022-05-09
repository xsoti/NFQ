//
//  ViewModel.swift
//  NFQ
//
//  Created by Michal Gumny on 05/05/2022.
//

import UIKit
import RxSwift

class ViewModel {
    let disposeBag = DisposeBag()
    let networkManager: NetworkManager
    var persistenceManager: PersistenceManager
    let logoReplaySubject = ReplaySubject<UIImage>.create(bufferSize: 1)
    let backgroundColor = UIColor.black
    let textColor = UIColor.white

    init(networkManager: NetworkManager,
         persistenceManager: PersistenceManager) {
        self.networkManager = networkManager
        self.persistenceManager = persistenceManager
        start()
    }

    func start() {}
}
