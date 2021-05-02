//
//  PlaylistViewController.swift
//  Spotify
//
//  Created by Michael Chen on 2/22/21.
//

import UIKit

class PlaylistViewController: UIViewController {
    
    private let playlist: Playlist
    
    public var isOwner = false
    
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { (_, _) -> NSCollectionLayoutSection? in
            //Create Item
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                                              widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 2, bottom: 1, trailing: 2)
            
            //Put item in group
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .absolute(60)),
                subitem: item,
                count: 1)
            
            //Put group in section
            let section = NSCollectionLayoutSection(group: group)
            
            //header and footer
            section.boundarySupplementaryItems = [
                NSCollectionLayoutBoundarySupplementaryItem (layoutSize: NSCollectionLayoutSize(
                                                                widthDimension: .fractionalWidth(1),
                                                                heightDimension: .fractionalWidth(1)),
                                                             elementKind: UICollectionView.elementKindSectionHeader,
                                                             alignment: .top)

            ]
            
            
            return section
        }))
    
    private var viewModels = [RecommendedTrackCellViewModel]()
    private var tracks = [AudioTrack]()
    
    init(playlist: Playlist) {
        self.playlist = playlist
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = playlist.name
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.register(PlaylistHeaderCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier)
        collectionView.register(RecommendedTrackCollectionViewCell.self,
                                forCellWithReuseIdentifier: RecommendedTrackCollectionViewCell.identifier)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        APICaller.shared.getplaylistDetails(for: playlist) { [weak self] result in
            DispatchQueue.main.async {
                switch result{
                case .success(let model):
                    //RecommendedTrackCellViewModel
                    //creating an array of track from items array
                    self?.tracks = model.tracks.items.compactMap({$0.track})
                    self?.viewModels = model.tracks.items.compactMap({
                        //turning each tracks in items array into a RecommendedTrackCellViewModel
                        RecommendedTrackCellViewModel(name: $0.track.name,
                                                      artistName: $0.track.artists.first?.name ?? "-",
                                                      artworkURL: URL(string: $0.track.album?.images.first?.url ?? ""))
                    })
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                            target: self,
                                                            action: #selector(didTapShare))
        
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
        
        collectionView.addGestureRecognizer(gesture)
        
    }
    
    //long press for removing song from playlist
    @objc func didLongPress(_ gesture: UILongPressGestureRecognizer){
        guard gesture.state == .began else {
            return
        }
        let touchPoint = gesture.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: touchPoint) else {
            return
        }
        let trackToDelete = tracks[indexPath.row]
        
        let actionSheet = UIAlertController(title: trackToDelete.name,
                                            message: "Would you like to remove this from the playlist?",
                                            preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            APICaller.shared.removeTrackFromPlaylist(track: trackToDelete, playlist: strongSelf.playlist) { success in
                DispatchQueue.main.async {
                    if success {
                        print("Removed")
                        strongSelf.tracks.remove(at: indexPath.row)
                        strongSelf.viewModels.remove(at: indexPath.row)
                        strongSelf.collectionView.reloadData()
                    }
                    else {
                        print("Failed to remove")
                    }
                }
                
            }
        }))
        present(actionSheet, animated: true, completion: nil)
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    @objc private func didTapShare(){
        guard let url = URL(string: playlist.external_urls["spotify"] ?? "") else {
            return
        }
        
        
        //share functionality
        let vc = UIActivityViewController(activityItems: ["Check out this cool playlist I found", url],
                                          applicationActivities: [])
        //so app don't crush on ipad
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }

}



extension PlaylistViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RecommendedTrackCollectionViewCell.identifier,
            for: indexPath
        ) as? RecommendedTrackCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: viewModels[indexPath.row])
        cell.backgroundColor = .red
        return cell
    }
    
    
    //header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier,
                for: indexPath
        ) as? PlaylistHeaderCollectionReusableView,
        kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        let headerViewModel = PlaylistHeaderViewViewModel(playlistName: playlist.name,
                                                          ownerName: playlist.owner.display_name,
                                                          description: playlist.description,
                                                          artworkURL: URL(string: playlist.images.first?.url ?? ""))
        header.configure(with: headerViewModel)
        header.delegate = self
        return header
    }
    
    //when you select an cell in the collection view
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        //play song
        let index = indexPath.row
        let track = tracks[index]
        PlaybackPresenter.shared.startPlayback(from: self, track: track)
        
    }
    
    
    
}


//intern to PlaylistHeaderCollectionReusableView. When play button is pressed on PlaylistHeaderCollectionReusableView we will know
extension PlaylistViewController: PlaylistHeaderCollectionReusableViewDelegate{
    func PlaylistHeaderCollectionReusableViewDidTapPlayAll(_ header: PlaylistHeaderCollectionReusableView) {
        //start play list play in queue
        print("Playing all")
        PlaybackPresenter.shared.startPlayback(from: self, tracks: tracks)
    }
}
