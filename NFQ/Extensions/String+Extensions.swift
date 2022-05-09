//
//  String+Extensions.swift
//  NFQ
//
//  Created by Michal Gumny on 05/05/2022.
//

import Foundation

let firstpart = "[A-Z0-9a-z]([A-Z0-9a-z._%+-]{0,30}[A-Z0-9a-z])?"
let serverpart = "([A-Z0-9a-z]([A-Z0-9a-z-]{0,30}[A-Z0-9a-z])?\\.){1,5}"
let emailRegex = firstpart + "@" + serverpart + "[A-Za-z]{2,8}"
let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)

extension String {
    var isValidEmail: Bool {
        return emailPredicate.evaluate(with: self)
    }
}
