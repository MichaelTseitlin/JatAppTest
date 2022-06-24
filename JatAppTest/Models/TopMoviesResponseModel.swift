//
//  TopMoviesResponseModel.swift
//  JatAppTest
//
//  Created by Michael Tseitlin on 23.06.2022.
//

import Foundation

struct TopMoviesResponseModel: Decodable {
    
    let items: [ItemModel]
    
}
