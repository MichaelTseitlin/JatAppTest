//
//  CacheStore.swift
//  JatAppTest
//
//  Created by Michael Tseitlin on 23.06.2022.
//

import UIKit

protocol CacheStoreProtocol {
    func getImage(_ id: String) -> UIImage?
    func saveImage(_ image: UIImage, id: String)
}

final class CacheStore: CacheStoreProtocol {
    
    private let cache = NSCache<AnyObject, UIImage>()
    
    func getImage(_ id: String) -> UIImage? {
        return cache.object(forKey: NSString(string: id))
    }
    
    func saveImage(_ image: UIImage, id: String) {
        cache.setObject(image, forKey: NSString(string: id))
    }
    
}
