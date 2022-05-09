//
//  PersistenceManager.swift
//  NFQ
//
//  Created by Michal Gumny on 06/05/2022.
//

import Valet

class PersistenceManager {

    private let valet = Valet.valet(with: Identifier(nonEmpty: "NFQValet")!, accessibility: .afterFirstUnlock)
    private let tokenKey = "tokenKey"
    private let loggedInKey = "loggedInKey"

    var token: String? {
        get {
            try? valet.string(forKey: tokenKey)
        }

        set {
            try? valet.setString(newValue ?? "", forKey: tokenKey)
        }
    }

    var loggedInStatus: Bool {
        get {
            UserDefaults.standard.bool(forKey: loggedInKey)
        }

        set {
            UserDefaults.standard.set(newValue, forKey: loggedInKey)
        }
    }
}
