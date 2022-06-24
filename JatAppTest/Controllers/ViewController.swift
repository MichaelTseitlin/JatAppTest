//
//  ViewController.swift
//  JatAppTest
//
//  Created by Michael Tseitlin on 22.06.2022.
//

import UIKit

final class ViewController: UICollectionViewController {
    
    private enum Section {
        
        case main
        
    }
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, ItemModel>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, ItemModel>
    
    private var dataSource: DataSource?
    
    private var items: [ItemModel] = [] {
        didSet { apply(items, animatingDifferences: false) }
    }
    private var searchItems: [ItemModel] = [] {
        didSet { apply(searchItems) }
    }
    
    private let refreshControl = UIRefreshControl()
    private let cacheStore: CacheStoreProtocol = CacheStore()
    private lazy var imageWorker: ImageWorkerProtocol = ImageWorker(cacheStore)
    private let topMoviesLoader: MoviesWorkerProtocol = MoviesWorker()
    
    init() {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(.defaultMargin)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = .defaultMargin
        section.contentInsets = .init(top: .halfOfdefaultMargin, leading: .defaultMargin, bottom: .halfOfdefaultMargin, trailing: .defaultMargin)
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [header]
        super.init(collectionViewLayout: UICollectionViewCompositionalLayout(section: section))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDataSource()
        loadData()
    }
    
}

// MARK: - UICollectionViewDelegate

extension ViewController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource?.itemIdentifier(for: indexPath) else { return }
        navigationController?.pushViewController(DetailViewController(item, cacheStore: cacheStore), animated: true)
    }
    
}

// MARK: - UISearchBarDelegate

extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchItems = searchText.isEmpty ? items : items.filter { $0.title.lowercased().contains(searchText.lowercased()) }
    }
    
}

private typealias ActionHelper = ViewController
private extension ActionHelper {
    
    @objc func didPullToRefresh(_ sender: Any) {
        loadData()
    }
    
}

private typealias DiffableHelper = ViewController
private extension DiffableHelper {
    
    func setupDataSource() {
        dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MovieCollectionViewCell.self), for: indexPath) as? MovieCollectionViewCell
            cell?.configure(MovieCollectionViewCell.Content(title: item.title, rank: item.rank))
            self.imageWorker.getImage(by: item.id, url: URL(string: item.image)) { cell?.setImage(try? $0.get()) }
            return cell
        }
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: SearchCollectionReusableView.self), for: indexPath) as? SearchCollectionReusableView
            header?.searchBar.delegate = self
            return header
        }
    }
    
    func apply(_ items: [ItemModel], animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        DispatchQueue.main.async { self.dataSource?.apply(snapshot, animatingDifferences: animatingDifferences) }
    }
    
}

private typealias HelperMethods = ViewController
private extension HelperMethods {
    
    func setupUI() {
        title = "Top 250 movies" 
        navigationController?.navigationBar.prefersLargeTitles = true
        refreshControl.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: MovieCollectionViewCell.self))
        collectionView.register(SearchCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: SearchCollectionReusableView.self))
    }
    
    func loadData() {
        topMoviesLoader.getTopMovies { [weak self] response in
            DispatchQueue.main.async { self?.refreshControl.endRefreshing() }
            switch response {
            case let .success(model):
                let items = Array(model.items.prefix(10))
                self?.items = items
            case let .failure(error):
                print(error)
            }
        }
    }
    
}
