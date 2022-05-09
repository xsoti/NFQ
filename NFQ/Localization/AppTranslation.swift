//
//  AppTranslation.swift
//  NFQ
//
//  Created by Michal Gumny on 03/05/2022.
//

import UIKit

protocol XIBLocalizable {
    var xibLocKey: String? { get set }
}

protocol LocalizableDelegate {
    var rawValue: String { get }
    var localized: String { get }
}

extension LocalizableDelegate {
    var localized: String {
        return Bundle.main.localizedString(forKey: rawValue, value: nil, table: nil)
    }
}

extension UILabel: XIBLocalizable {
    @IBInspectable var xibLocKey: String? {
        get { return nil }
        set(key) {
            text = Bundle.main.localizedString(forKey: key ?? "unknown", value: nil, table: nil)
        }
    }
}

extension UIButton: XIBLocalizable {
    @IBInspectable var xibLocKey: String? {
        get { return nil }
        set(key) {
            let translated = Bundle.main.localizedString(forKey: key ?? "unknown", value: nil, table: nil)
            setTitle(translated, for: .normal)
        }
    }
}

extension UITextField: XIBLocalizable {
    @IBInspectable var xibLocKey: String? {
        get { return nil }
        set(key) {
            placeholder = Bundle.main.localizedString(forKey: key ?? "unknown", value: nil, table: nil)
        }
    }
}

enum Localizable {

    enum Login: String, LocalizableDelegate {
        case username
        case password
        case submit
        case errorTitle
        case errorMessage
        case buttonTitle
        case logout
    }

    enum Profile: String, LocalizableDelegate {
        case logout = "Logout"
    }
}
