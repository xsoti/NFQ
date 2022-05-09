//
//  NetworkManager.swift
//  NFQ
//
//  Created by Michal Gumny on 03/05/2022.
//

import UIKit
import RxSwift
import RxCocoa

struct CredentialTokens: Decodable {
    let token: String
    let refreshToken: String
}

enum NetworkResponse<T> {
    case succcess(response: T)
    case failure(error: NFQError)
}

final class NetworkManager {

    private let serverUrl = "https://vidqjclbhmef.herokuapp.com"
    private let imageURL = "https://placeimg.com/640/640/tech"

    func fetchLogo() -> Observable<Data> {
        return fetchImage(urlString: imageURL)
    }

    func fetchImage(urlString: String) -> Observable<Data> {
        let request = URLRequest(url: URL(string: urlString)!)

        return URLSession.shared.rx.response(request: request)
            .retry()
            .flatMap { _, data -> Observable<Data> in
                return Observable.just(data)
            }
    }

    func login(user: String,
               password: String) -> Observable<NetworkResponse<CredentialTokens>> {
        var request = URLRequest(url: URL(string: "\(serverUrl)/credentials")!)

        let postData = Data("username=\(user)&password=\(password)".data(using: String.Encoding.utf8)!)

        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField:
                            "Content-Type")
        request.httpBody = postData

        return handleGenericRequest(request: request)
    }

    func fetchProfile(token: String) -> Observable<NetworkResponse<User>> {
        var request = URLRequest(url: URL(string: "\(serverUrl)/user")!)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"

        return handleGenericRequest(request: request)
    }

    private func handleGenericRequest<T: Decodable>(request: URLRequest) -> Observable<NetworkResponse<T>> {
        return URLSession.shared.rx.response(request: request)
            .retry(3)
            .flatMap { response, data -> Observable<NetworkResponse> in
                if response.statusCode == 200 {
                    do {
                        let json = try JSONDecoder().decode(T.self, from: data)
                        return Observable.just(NetworkResponse.succcess(response: json))
                    } catch {
                        return Observable.just(NetworkResponse.failure(error: NFQError.wrongDataFormat))
                    }
                } else {
                    return Observable.just(NetworkResponse.failure(error: NFQError.unknownError))
                }
            }
    }
}
