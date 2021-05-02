//
//  ViewController.swift
//  Spotify
//
//  Created by Michael Chen on 2/22/21.
//

import UIKit

enum BrowseSectionType {
    //associated values for enums
    case newReleases(viewModels: [NewReleasesCellViewModel]) //1
    case featurePlaylists(viewModels: [FeaturePlaylistCellViewModel])  //2
    case recommendedTracks(viewModels: [RecommendedTrackCellViewModel]) //3
    
    
    var title: String {
        switch self{
        case .newReleases:
            return "New Released Albums"
        case .featurePlaylists:
            return "Featured Playlists"
        case .recommendedTracks:
            return "Recommended"
        }
    }
    
    
    
}

class HomeViewController: UIViewController {
    
    private var newAlbums: [Album] = []
    private var playlists: [Playlist] = []
    private var tracks: [AudioTrack] = []
    
    private var collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
            return HomeViewController.createSectionLayout(section: sectionIndex)
            
        }
    )
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.tintColor = .label
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    private var sections = [BrowseSectionType]()
    
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Browse"
        label.font = .systemFont(ofSize: 36, weight: .bold)
        label.textColor = .systemRed
        return label
        
    }()
    
    private let color: UIColor = .systemBackground
    
    
    override func viewDidLoad() {
        print("Color is -------------------\(color)")
        super.viewDidLoad()
        //title = "Browse"
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "gear"),
            style: .done,
            target: self,
            action: #selector(didTapSettings))
        
        configureCollectionView()
        view.addSubview(spinner)
        fetchData()
        addLongTapGesture()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //label.frame = CGRect(x: 15, y: 90, width: 200, height: 50)
        collectionView.frame = view.bounds
    }
    
    
    private func addLongTapGesture(){
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress))
        collectionView.isUserInteractionEnabled = true
        collectionView.addGestureRecognizer(gesture)
    }
    
    @objc func didLongPress(_ gesture: UILongPressGestureRecognizer){
        guard gesture.state == .began else {
            return
        }
        
        //get touch point in a view
        let touchPoint = gesture.location(in: collectionView)
        
        //determine where in the collection view the item was tapped, can only add songs to playlist (which section)
        guard let indexPath = collectionView.indexPathForItem(at: touchPoint),
              indexPath.section == 2 else {
            return
        }
        
        let model = tracks[indexPath.row]
        
        let actionSheet = UIAlertController(title: model.name,
                                            message: "Would you like to add this to a playlist?",
                                            preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Add to Playlist", style: .default, handler: { [weak self] _ in
            DispatchQueue.main.async {
                let vc = LibraryPlaylistsViewController()
                vc.selectionHandler = {playlist in
                    APICaller.shared.addTrackToPlaylist(track: model, playlist: playlist) { success in
                        print("Added to playlist success: \(success)")
                    }
                }
                vc.title = "Select Playlist"
                self?.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
            }
        }))
        present(actionSheet, animated: true)
        
        
        
        
    }
    
    private func configureCollectionView(){
        view.addSubview(collectionView)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(NewReleaseCollectionViewCell.self,
                                forCellWithReuseIdentifier: NewReleaseCollectionViewCell.identifier)
        collectionView.register(FeaturePlaylistCollectionViewCell.self,
                                forCellWithReuseIdentifier: FeaturePlaylistCollectionViewCell.identifier)
        collectionView.register(RecommendedTrackCollectionViewCell.self,
                                forCellWithReuseIdentifier: RecommendedTrackCollectionViewCell.identifier)
        collectionView.register(TitleHeaderCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: TitleHeaderCollectionReusableView.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground   /////////////////
        collectionView.backgroundColor = UIColor(named: "appBackgroundColor")
    }
    
    
    
    ///Getting New Releases, Getting Featured Playlists, Getting Recommended Tracks
    private func fetchData(){
        //use to make sure all api call finishes before we configure the models
        let group = DispatchGroup()
        group.enter()
        group.enter()
        group.enter()
        
        var newReleases: NewReleasesResponse?
        var featurePlaylist: FeaturePlaylistsResponse?
        var recommendations: RecommendationsResponse?
        
        //Getting New Releases
        APICaller.shared.getNewReleases { result in
            defer{
                //decremet group entries, we made 3 at the top
                group.leave()
            }
            switch result{
            case .success(let model):
                newReleases = model
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        //Getting Featured Playlists
        APICaller.shared.getFeaturedPlayList { result in
            defer{
                //decremet group entries, we made 3 at the top
                group.leave()
            }
            switch result{
            case .success(let model):
                featurePlaylist = model
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        //Getting Recommended Tracks
        APICaller.shared.getRecommendedGenres { result in
            switch result {
            case .success(let model):
                let genres = model.genres
                var seeds = Set<String>()
                while seeds.count < 5 {
                    if let rand = genres.randomElement(){
                        seeds.insert(rand)
                    }
                }
                
                APICaller.shared.getRecommendations(genres: seeds) { recommendedResults in
                    defer{
                        //decremet group entries, we made 3 at the top
                        group.leave()
                    }
                    switch recommendedResults{
                    case .success(let model):
                        recommendations = model
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        //notify main thread that the API calls are done
        group.notify(queue: .main) {
            guard let newAlbums = newReleases?.albums.items,
                  let playlists = featurePlaylist?.playlists.items,
                  let tracks = recommendations?.tracks else {
                return
            }
            
            //Configure Models
            self.configureModels(newAlbums: newAlbums,
                                 playlists: playlists,
                                 tracks: tracks)
            
        }
    }
    
    
    
    
    
    private func configureModels(newAlbums: [Album], playlists: [Playlist], tracks: [AudioTrack] ) {
        //Configure Models
        print(newAlbums.count)
        print(playlists.count)
        print(tracks.count)
        
        self.newAlbums = newAlbums
        self.playlists = playlists
        self.tracks = tracks
        
        sections.append(.newReleases(viewModels: newAlbums.compactMap({
            //turning each album in newAlbums array into a NewReleasesCellViewModel
            return NewReleasesCellViewModel(name: $0.name,
                                            artworkURL: URL(string: $0.images.first?.url ?? ""),
                                            numberOfTracks: $0.total_tracks,
                                            artistName: $0.artists.first?.name ?? "-")
        })))
        
        sections.append(.featurePlaylists(viewModels: playlists.compactMap({
            //turning each playlist in playlists array into a FeaturePlaylistCellViewModel
            return FeaturePlaylistCellViewModel(name: $0.name,
                                                artworkURL: URL(string: $0.images.first?.url ?? "") ,
                                                creatorName: $0.owner.display_name)
        })))
        
        sections.append(.recommendedTracks(viewModels: tracks.compactMap({
            //turning each track in tracks array into a RecommendedTrackCellViewModel
            return RecommendedTrackCellViewModel(name: $0.name,
                                                 artistName: $0.artists.first?.name ?? "-",
                                                 artworkURL: URL(string: $0.album?.images.first?.url ?? ""))
        })))
        
        collectionView.reloadData()
    }
    
    @objc func didTapSettings() {
        let vc = SettingsViewController()
        vc.title = "Settings"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }


}




extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let type = sections[section]
        
        switch type {
        case .newReleases(let viewModels):
            return viewModels.count
        case .featurePlaylists(let viewModels):
            return viewModels.count
        case .recommendedTracks(let viewModels):
            return viewModels.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let type = sections[indexPath.section]
        
        switch type {
        case .newReleases(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NewReleaseCollectionViewCell.identifier,
                for: indexPath
            ) as? NewReleaseCollectionViewCell else {
                return UICollectionViewCell()
            }
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell
            
        case .featurePlaylists(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: FeaturePlaylistCollectionViewCell.identifier,
                for: indexPath
            ) as? FeaturePlaylistCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            //cell.backgroundColor = .systemBlue
            cell.configure(with: viewModels[indexPath.row])
            return cell
            
        case .recommendedTracks(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RecommendedTrackCollectionViewCell.identifier,
                for: indexPath
            ) as? RecommendedTrackCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.configure(with: viewModels[indexPath.row])
            return cell
            
        }
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        HapticsManager.shared.vibrateForSelection()
        let section = sections[indexPath.section]
        switch section {
        case .featurePlaylists:
            let playlist = playlists[indexPath.row]
            let vc = PlaylistViewController(playlist: playlist)
            vc.title = playlist.name
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        case .newReleases:
            let album = newAlbums[indexPath.row]
            let vc = AlbumViewController(album: album)
            vc.title = album.name
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        case .recommendedTracks:
            let track = tracks[indexPath.row]
            PlaybackPresenter.shared.startPlayback(from: self, track: track)
            break
        }
    }
    
    
    
    //adding header for each section
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: TitleHeaderCollectionReusableView.identifier,
            for: indexPath
        ) as? TitleHeaderCollectionReusableView, kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        
        let section = indexPath.section
        let title = sections[section].title
        header.configure(with: title)
        return header
    }
    
    

    
    ///create the section for the compositional layout
    private static func createSectionLayout(section: Int) -> NSCollectionLayoutSection {
        
        //header for each section
        let supplementaryViews = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(50)),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)
        ]
        
        switch section{
        //zero base index
        case 0:
            //Create Item
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                                                widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .fractionalHeight(1.0)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            //Put item in group
            //vertical group inside of horizontal group
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(390)),
                subitem: item,
                count: 3)
            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9),
                                                                                            heightDimension: .absolute(390)),
                                                         subitem: verticalGroup,
                                                         count: 1)
            
            //Put group in section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .continuous
            section.boundarySupplementaryItems = supplementaryViews
            return section
            
        case 1:
            //Create Item
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                                                widthDimension: .absolute(200),
                                                heightDimension: .absolute(400)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            //Put item in group
            //vertical group inside of horizontal group
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(200),
                                                   heightDimension: .absolute(400)),
                subitem: item,
                count: 2)
            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(200),
                                                   heightDimension: .absolute(400)),
                subitem: verticalGroup,
                count: 1)
            
            //Put group in section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .continuous
            section.boundarySupplementaryItems = supplementaryViews
            return section
            
        case 2:
            //Create Item
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                                                widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .fractionalHeight(1.0)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            //Put item in group
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .absolute(80)),
                subitem: item,
                count: 1)
            
            //Put group in section
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = supplementaryViews
            return section
            
        default:
            //Create Item
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                                                widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .fractionalHeight(1.0)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            //Put item in group
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(390)),
                subitem: item,
                count: 1)
            
            //Put group in section
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = supplementaryViews
            return section
        }
    }
    
    
}
