//
//  ItemModel.swift
//  JatAppTest
//
//  Created by Michael Tseitlin on 23.06.2022.
//

import Foundation

struct ItemModel: Decodable {
    
    let id: String
    let rank: String
    let title: String
    let fullTitle: String
    let year: String
    let image: String
    let crew: String
    let imDbRating: String
    let imDbRatingCount: String
    
}

extension ItemModel: Hashable {}
