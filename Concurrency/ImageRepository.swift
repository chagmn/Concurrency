//
//  ImageRepository.swift
//  Concurrency
//
//  Created by ChangMin on 2023/03/02.
//

import UIKit

protocol BaseImageRepository {
    func fetchImage(completion: @escaping (Result<UIImage?, Error>) -> Void)
}

final class ImageRepository: BaseImageRepository {
    var task: URLSessionDataTask!
    
    func fetchImage(completion: @escaping (Result<UIImage?, Error>) -> Void) {
        guard let url = URL(string: "https://source.unsplash.com/random")
        else { return completion(.failure(Error.self as! Error)) }
        let urlRequest = URLRequest(url: url)
        
        task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                guard error.localizedDescription == "cancelled" else {
                    completion(.failure(Error.self as! Error))
                    return
                }
                completion(.success(nil))
                return
            }
            
            guard (response as? HTTPURLResponse)?.statusCode == 200
            else { return completion(.failure(Error.self as! Error)) }
            
            guard let data = data else { return completion(.failure(Error.self as! Error)) }
            
            completion(.success(UIImage(data: data)!))  
        }
        
        task.resume()
    }
}
