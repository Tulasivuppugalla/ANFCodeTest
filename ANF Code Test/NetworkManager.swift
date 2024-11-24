//
//  NetworkManager.swift
//  ANF Code Test
////

import Foundation

protocol DataFetchable {
    func fetchData(from url: URL, completion: @escaping (Result<Data, Error>) -> Void)
}

class NetworkManager: DataFetchable {
    var result: Result<Data, Error>?

    func fetchData(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "DataError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received."])))
                return
            }
            completion(.success(data))
        }
        task.resume()
    }
}
