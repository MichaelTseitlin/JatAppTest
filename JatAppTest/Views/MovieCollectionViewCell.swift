//
//  MovieCollectionViewCell.swift
//  JatAppTest
//
//  Created by Michael Tseitlin on 23.06.2022.
//

import UIKit

final class MovieCollectionViewCell: UICollectionViewCell {
    
    struct Content {
        
        let title: String
        let rank: String
        
    }
    
    private lazy var infoStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [titleLabel, rankLabel])
        view.axis = .vertical
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let rankLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }
    
    override func prepareForReuse() {
        imageView.image = nil
    }
    
    func configure(_ content: Content) {
        titleLabel.text = content.title
        rankLabel.text = "Rating: \(content.rank)"
        activityIndicatorView.startAnimating()
    }
    
    func setImage(_ image: UIImage?) {
        activityIndicatorView.stopAnimating()
        imageView.image = image
    }
    
}

private typealias SetupHelper = MovieCollectionViewCell
private extension SetupHelper {
    
    func setupLayout() {
        addSubviewsForAutoLayout(imageView, activityIndicatorView, infoStackView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: infoStackView.topAnchor),
            
            activityIndicatorView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            
            infoStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            infoStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            infoStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
}
