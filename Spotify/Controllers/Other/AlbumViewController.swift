//
//  AlbumViewController.swift
//  Spotify
//
//  Created by Michael Chen on 3/3/21.
//

import UIKit

class AlbumViewController: UIViewController {
    
    private let album: Album
    
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
    
    private var viewModels = [AlbumCollectionViewCellViewModel]()
    private var tracks = [AudioTrack]()

    
    init(album: Album) {
        self.album = album
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = album.name
        view.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
        collectionView.register(PlaylistHeaderCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier)
        collectionView.register(AlbumTrackCollectionViewCell.self,
                                forCellWithReuseIdentifier: AlbumTrackCollectionViewCell.identifier)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        
        fetchData()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                            target: self,
                                                            action: #selector(didTapActions))
    }
    
    @objc func didTapActions(){
        let actionSheet = UIAlertController(title: album.name,
                                            message: "Actions",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Save Album", style: .default, handler: { [weak self] _ in
            guard let strongSelf = self else { return }
            APICaller.shared.saveAlbum(album: strongSelf.album) { success in
                print("Saved: \(success)")
                if success {
                    HapticsManager.shared.vibrate(for: .success)
                    //posting/sending notification, letting whoever that is listening(LibraryAlbumViewController) know
                    NotificationCenter.default.post(name: .albumSavedNotification, object: nil)
                }
                else{
                    HapticsManager.shared.vibrate(for: .error)
                }
            }
        }))
        present(actionSheet, animated: true, completion: nil)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    private func fetchData(){
        APICaller.shared.getAlbumDetails(for: album){ [weak self] result in
            DispatchQueue.main.async {
                switch result{
                case .success(let model):
                    //storing an array of AudioTrack from items array
                    self?.tracks = model.tracks.items
                    self?.viewModels = model.tracks.items.compactMap({
                        //turning each tracks in items array into a AlbumCollectionViewCellViewModel
                        AlbumCollectionViewCellViewModel(name: $0.name,
                                                         artistName: $0.artists.first?.name ?? "-")
                    })
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
}



extension AlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: AlbumTrackCollectionViewCell.identifier,
            for: indexPath
        ) as? AlbumTrackCollectionViewCell else {
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
        let headerViewModel = PlaylistHeaderViewViewModel(
            playlistName: album.name,
            ownerName: album.artists.first?.name,
            description: "Release Date: \(String.formattedDate(string: album.release_date))",
            artworkURL: URL(string: album.images.first?.url ?? "")
        )
        header.configure(with: headerViewModel)
        header.delegate = self
        return header
    }
    
    //when you select an cell in the collection view
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        //play song
        var track = tracks[indexPath.row]
        track.album = self.album //give tracks of album a reference to the album so we can get the image of the album
        PlaybackPresenter.shared.startPlayback(from: self, track: track)
    }
    
    
}


//intern to PlaylistHeaderCollectionReusableView. When play button is pressed on PlaylistHeaderCollectionReusableView we will know
extension AlbumViewController: PlaylistHeaderCollectionReusableViewDelegate{
    func PlaylistHeaderCollectionReusableViewDidTapPlayAll(_ header: PlaylistHeaderCollectionReusableView) {
        //start play list play in queue
        print("Playing all")
        //give tracks of album a reference to the album so we can get the image of the album
        let tracksWithAlbum: [AudioTrack] = tracks.compactMap({
            var track = $0
            track.album = self.album
            return track
        })
        PlaybackPresenter.shared.startPlayback(from: self, tracks: tracksWithAlbum)
    }


}


