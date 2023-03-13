//
//  ImageRepository.swift
//  Concurrency
//
//  Created by ChangMin on 2023/03/02.
//

import UIKit

protocol BaseImageRepository {
//    @objc optional func fetchImage(completion: @escaping (Result<UIImage?, Error>) -> Void)
    func fetchImage(url: URL) async throws -> UIImage
}

final class ImageRepository: BaseImageRepository {
//    var task: URLSessionDataTask!
//    var task: Task<Void, Error>!
    
//    func fetchImage(completion: @escaping (Result<UIImage?, Error>) -> Void) {
//        guard let url = URL(string: "https://source.unsplash.com/random")
//        else { return completion(.failure(Error.self as! Error)) }
//        let urlRequest = URLRequest(url: url)
//
//        task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
//            if let error = error {
//                guard error.localizedDescription == "cancelled" else {
//                    completion(.failure(Error.self as! Error))
//                    return
//                }
//                completion(.success(nil))
//                return
//            }
//
//            guard (response as? HTTPURLResponse)?.statusCode == 200
//            else { return completion(.failure(Error.self as! Error)) }
//
//            guard let data = data else { return completion(.failure(Error.self as! Error)) }
//
//            completion(.success(UIImage(data: data)!))
//        }
//
//        task.resume()
//    }
    
    func fetchImage(url: URL) async throws -> UIImage {
        let request = URLRequest(url: url)
        
        guard Task.isCancelled == false else {
            return UIImage(systemName: "xmark")!
        }
        let (data, response) = try await URLSession.shared.data(for: request)
        if Task.isCancelled {
            return UIImage(systemName: "xmark")!
            
        }
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode, (200...299).contains(statusCode) else { throw NSError(domain: "fetch error", code: 503) }
       
        guard let image = UIImage(data: data) else { throw NSError(domain: "image converting error", code: 999) }
        return image
    }
}
