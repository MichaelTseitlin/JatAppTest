//
//  ImageWorker.swift
//  JatAppTest
//
//  Created by Michael Tseitlin on 23.06.2022.
//

import UIKit

protocol ImageWorkerProtocol {
    func getImage(by id: String, url: URL?, completion: @escaping CompletionResultHandler<UIImage>)
}

final class ImageWorker: ImageWorkerProtocol {
    
    private enum ImageError: Error {
        
        case invalidURL
        case failedData
        case unsupportedImage
        
    }
    
    private let cacheStore: CacheStoreProtocol
    
    init(_ cacheStore: CacheStoreProtocol) {
        self.cacheStore = cacheStore
    }
    
    func getImage(by id: String, url: URL?, completion: @escaping CompletionResultHandler<UIImage>) {
        if let cachedImage = cacheStore.getImage(id) {
            completion(.success(cachedImage))
        } else {
            guard let url = url else {
                completion(.failure(ImageError.invalidURL))
                return
            }
            DispatchQueue.global(qos: .utility).async {
                guard let data = try? Data(contentsOf: url) else {
                    completion(.failure(ImageError.failedData))
                    return
                }
                
                guard let image = UIImage(data: data) else {
                    completion(.failure(ImageError.unsupportedImage))
                    return
                }
                
                self.cacheStore.saveImage(image, id: id)
                
                DispatchQueue.main.async {
                    completion(.success(image))
                }
                
            }
        }
    }
    
}
