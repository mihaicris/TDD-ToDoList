//
//  APIClient.swift
//  ToDo
//
//  Created by Mihai Cristescu on 02/04/2017.
//  Copyright © 2017 Mihai Cristescu. All rights reserved.
//

import Foundation

protocol SessionProtocol {
    func dataTask(with url: URL,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: SessionProtocol {}

enum WebserviceError: Error {
    case DataEmptyError
    case ResponseError
}

class APIClient {

    lazy var session: SessionProtocol = URLSession.shared

    func loginUser(withName username: String, password: String, completion: @escaping (Token?, Error?) -> Void) {

        let query = "username=\(username)&password=\(password)"

        guard let url = URL(string: "https://awesometodos.com/login?\(query)") else {
            fatalError()
        }

        session.dataTask(with: url) { data, _, error in

            guard error == nil else {
                completion(nil, WebserviceError.ResponseError)
                return
            }

            guard let data = data else {
                completion(nil, WebserviceError.DataEmptyError)
                return
            }
            do {
                let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String]

                let token: Token?

                if let tokenString = dict?["token"] {
                    token = Token(id: tokenString)
                } else {
                    token = nil
                }

                completion(token, nil)

            } catch {
                completion(nil, error)
            }
        }.resume()
    }

}
