//
//  SearchCollectionReusableView.swift
//  JatAppTest
//
//  Created by Michael Tseitlin on 23.06.2022.
//

import UIKit

final class SearchCollectionReusableView: UICollectionReusableView {
    
    let searchBar = UISearchBar()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }
    
}

private typealias SetupHelper = SearchCollectionReusableView
private extension SetupHelper {
    
    func setupLayout() {
        addSubviewsForAutoLayout(searchBar)
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchBar.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
}
