//
//  SearchViewController.swift
//  Spotify
//
//  Created by Michael Chen on 2/22/21.
//

import UIKit
import SafariServices

class SearchViewController: UIViewController {
    
    let searchController: UISearchController = {
        //will display the search results in the SearchResultsViewController view
        let vc = UISearchController(searchResultsController: SearchResultsViewController())
        vc.searchBar.placeholder = "Songs, Artists, Albums"
        vc.searchBar.searchBarStyle = .minimal
        vc.definesPresentationContext = true
        return vc
    }()
    
    //will only have one section
    private let collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { (_, _) -> NSCollectionLayoutSection? in
            
            //Create Item
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                                 heightDimension: .fractionalHeight(1)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 8, bottom: 2, trailing: 8)
            
            //Put item in group
            //Two items side by side
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                                              heightDimension: .absolute(150)),
                                                           subitem: item,
                                                           count: 2)
            
            group.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
            
            //Put group in section
            return NSCollectionLayoutSection(group: group)
        }))
    
    
    private var categories = [Category]()
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Search"
        label.font = .systemFont(ofSize: 36, weight: .bold)
        label.textColor = .systemRed
        return label
        
    }()
    
    
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        //to get the text that user type in the serach bar
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        view.addSubview(collectionView)
        collectionView.register(CategoryCollectionViewCell.self,
                                forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground           ///////////////
        
        APICaller.shared.getCatergories { [weak self] result in
            DispatchQueue.main.async {
                switch result{
                case .success(let categories):
                    self?.categories = categories
                    self?.collectionView.reloadData()
//                    let first = models.first!
//                    APICaller.shared.getCatergoryPlaylist(catergory: first) { _ in
//
//                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    break
                }
            }
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }


}



extension SearchViewController: UISearchResultsUpdating, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate, SearchResultsViewControllerDelegate {
    
    //UISearchResultsUpdating delegate method, used to retrieving every letter a user types
    //T
    //TE
    //TES
    //TEST
    //TESTI
    func updateSearchResults(for searchController: UISearchController) {
        //print(query)
    }
    
    //when the searchbar search button is clicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //get the SearchResultsViewController, checking that the text is not empty and not whitespaces
        guard let resultController = searchController.searchResultsController as? SearchResultsViewController,
              let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        resultController.delegate = self
        
        APICaller.shared.search(with: query) { result in
            DispatchQueue.main.async {
                switch result{
                case .success(let results):
                    resultController.update(with: results)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath
        ) as? CategoryCollectionViewCell else {
            return UICollectionViewCell()
        }
        let category = categories[indexPath.row]
        cell.configure(with: CategoryCollectionViewCellViewModel(title: category.name,
                                                                 artWorkURL: URL(string: category.icons.first?.url ?? "")))
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        HapticsManager.shared.vibrateForSelection()
        let category = categories[indexPath.row]
        let vc = CategoryViewController(category: category)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /*intern releationship with SearchResultController acting as boss
     when user taps a artist bring them to a Safari view controller(built in) for the external url for that artist
     when user taps a album bring them to the album view controller for that album
     when user taps a song bring them to the playback view controller to play the song
     when user taps a playlist bring them to the playlist view controller for that playlist
     */
    func didTapResult(_ result: SearchResult) {
        switch result {
        case .artist(let model):
            guard let url = URL(string: model.external_urls["spotify"] ?? "") else {
                return
            }
            let vc = SFSafariViewController(url: url)
            //use present instead of push to navigation controller since that is how Safari view controller behaves
            present(vc, animated: true)
        
        case .album(let model):
            let vc = AlbumViewController(album: model)
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        case .track(let model):
            PlaybackPresenter.shared.startPlayback(from: self, track: model)
        case .playlist(let model):
            let vc = PlaylistViewController(playlist: model)
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
