//
//  DetailViewController.swift
//  JatAppTest
//
//  Created by Michael Tseitlin on 23.06.2022.
//

import UIKit

final class DetailViewController: UIViewController {
    
    private let item: ItemModel
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.addSubviewsForAutoLayout(contentStackView)
        view.showsVerticalScrollIndicator = false
        return view
    }()
    private lazy var contentStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [imageView, fullTitleLabel, rankLabel, crewLabel, imDbRatingLabel])
        view.axis = .vertical
        view.isLayoutMarginsRelativeArrangement = true
        view.spacing = .halfOfdefaultMargin
        view.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: .defaultMargin, bottom: .defaultMargin, trailing: .defaultMargin)
        return view
    }()
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        return imageView
    }()
    private let fullTitleLabel = UILabel()
    private let rankLabel = UILabel()
    private let crewLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        return label
    }()
    private let imDbRatingLabel = UILabel()
    
    private let imageWorker: ImageWorkerProtocol
    
    init(_ item: ItemModel, cacheStore: CacheStoreProtocol) {
        self.item = item
        imageWorker = ImageWorker(cacheStore)
        super.init(nibName: nil, bundle: nil)
        setupLayout()
    }
    
    deinit { print("deinit") }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
}

private typealias SetupHelper = DetailViewController
private extension SetupHelper {
    
    func setupLayout() {
        view.addSubviewsForAutoLayout(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    func setupUI() {
        title = "Details"
        view.backgroundColor = .white
        imageWorker.getImage(by: item.id, url: URL(string: item.image)) { [weak self] in self?.imageView.image = try? $0.get() }
        fullTitleLabel.text = item.fullTitle
        rankLabel.text = "Rank: \(item.rank)"
        crewLabel.text = "Crew: \(item.crew)"
        imDbRatingLabel.text = "IMDb Rating: \(item.imDbRating)"
    }
    
}
