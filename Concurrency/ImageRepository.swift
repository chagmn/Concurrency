//
//  ImageRepository.swift
//  Concurrency
//
//  Created by ChangMin on 2023/03/02.
//

import UIKit

protocol BaseImageRepository {
    func fetchImage(completion: @escaping (Result<UIImage, Error>) -> Void)
}

final class ImageRepository: BaseImageRepository {
    func fetchImage(completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let url = URL(string: "https://source.unsplash.com/random")
        else { return completion(.failure(Error.self as! Error)) }
        let urlRequest = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard (response as? HTTPURLResponse)?.statusCode == 200
            else { return completion(.failure(Error.self as! Error)) }
            
            guard error == nil else { return completion(.failure(Error.self as! Error)) }
            guard let data = data else { return completion(.failure(Error.self as! Error)) }
            
            completion(.success(UIImage(data: data)!))
            
        }.resume()
    }
}
