//
//  User.swift
//  NFQ
//
//  Created by Michal Gumny on 05/05/2022.
//

import UIKit

struct User: Codable {
    let uuid: String
    let image: String
    let firstName: String
    let lastName: String
    let address: String
    let phone: String
}
