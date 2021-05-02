//
//  SearchResultsViewController.swift
//  Spotify
//
//  Created by Michael Chen on 2/22/21.
//

import UIKit

struct SearchSection {
    let title: String
    let results: [SearchResult]
}

//boss relationship with searchViewController
protocol SearchResultsViewControllerDelegate: AnyObject {
    func didTapResult(_ result: SearchResult)
}

class SearchResultsViewController: UIViewController {
    
    weak var delegate: SearchResultsViewControllerDelegate?

    //create a section to display each type of result (artist, tack, album, playlist)
    private var sections: [SearchSection] = []
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .systemBackground
        tableView.register(SearchResultDefaultTableViewCell.self, forCellReuseIdentifier: SearchResultDefaultTableViewCell.identifier)
        tableView.register(SearchResultSubtitleTableViewCell.self, forCellReuseIdentifier: SearchResultSubtitleTableViewCell.identifier)
        tableView.isHidden = true
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        addLongTapGesture()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    //allow users to add songs from search result
    private func addLongTapGesture(){
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress))
        tableView.isUserInteractionEnabled = true
        tableView.addGestureRecognizer(gesture)
    }
    
    @objc func didLongPress(_ gesture: UILongPressGestureRecognizer){
        guard gesture.state == .began else {
            return
        }
        
        //get touch point in a view
        let touchPoint = gesture.location(in: tableView)
        
        //determine where in the table view the item was tapped, can only add songs to playlist (which section)
        guard let indexPath = tableView.indexPathForRow(at: touchPoint),
              indexPath.section == 0 else {
            return
        }
        
        //for that particular section, get the result for that row
        let result = sections[indexPath.section].results[indexPath.row]
        
        switch result {
        case .track(let model):
            
            let actionSheet = UIAlertController(title: model.name,
                                                message: "Would you like to add this to a playlist?",
                                                preferredStyle: .actionSheet)
            
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            actionSheet.addAction(UIAlertAction(title: "Add to Playlist", style: .default, handler: { [weak self] _ in
                
                print("Will add to playlist")
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
        default:
            return
        }
        
    }
    
    
    
    func update(with results: [SearchResult]) {
        //filtering for artists
        let artists = results.filter({
            switch $0{
            case .artist:
                return true
            default:
                return false
            }
        })
        
        let albums = results.filter({
            switch $0{
            case .album:
                return true
            default:
                return false
            }
        })
        
        let tracks = results.filter({
            switch $0{
            case .track:
                return true
            default:
                return false
            }
        })
        
        let playlists = results.filter({
            switch $0{
            case .playlist:
                return true
            default:
                return false
            }
        })
        
        
        self.sections = [
            SearchSection(title: "Songs", results: tracks),
            SearchSection(title: "Artists", results: artists),
            SearchSection(title: "Playlists", results: playlists),
            SearchSection(title: "Albums", results: albums),
        ]
        tableView.reloadData()
        tableView.isHidden = results.isEmpty
    }

}



extension SearchResultsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //for that particular section, get the result for that row
        let result = sections[indexPath.section].results[indexPath.row]
        //let Acell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        switch result {
        case .artist(let artist):
            
            guard let artistCell = tableView.dequeueReusableCell(withIdentifier: SearchResultDefaultTableViewCell.identifier,
                                                           for: indexPath
            ) as? SearchResultDefaultTableViewCell else {
                return UITableViewCell()
            }
            let viewModel = SearchResultDefaultTableViewCellViewModel(title: artist.name,
                                                                      imageURL: URL(string: artist.images?.first?.url ?? ""))
            artistCell.configure(with: viewModel)
            return artistCell
            
            //cell.textLabel?.text = model.name
        case .album(let album):
            guard let albumCell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTableViewCell.identifier,
                                                           for: indexPath
            ) as? SearchResultSubtitleTableViewCell else {
                return UITableViewCell()
            }
            let viewModel = SearchResultSubtitleTableViewCellViewModel(title: album.name,
                                                                       subtitle: album.artists.first?.name ?? "-",
                                                                       imageURL: URL(string: album.images.first?.url ?? ""))
            albumCell.configure(with: viewModel)
            return albumCell
            
        case .track(let track):
            guard let trackCell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTableViewCell.identifier,
                                                           for: indexPath
            ) as? SearchResultSubtitleTableViewCell else {
                return UITableViewCell()
            }
            let viewModel = SearchResultSubtitleTableViewCellViewModel(title: track.name,
                                                                       subtitle: track.artists.first?.name ?? "-",
                                                                       imageURL: URL(string: track.album?.images.first?.url ?? ""))
            trackCell.configure(with: viewModel)
            return trackCell
            
        case .playlist(let playlist):
            guard let playlistCell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTableViewCell.identifier,
                                                                   for: indexPath
            ) as? SearchResultSubtitleTableViewCell else {
                return UITableViewCell()
            }
            let viewModel = SearchResultSubtitleTableViewCellViewModel(title: playlist.name,
                                                                       subtitle: playlist.owner.display_name,
                                                                       imageURL: URL(string: playlist.images.first?.url ?? ""))
            playlistCell.configure(with: viewModel)
            return playlistCell
        }
        
        
        //cell.textLabel?.text = "Foo"
        //return Acell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let result = sections[indexPath.section].results[indexPath.row]
        
        delegate?.didTapResult(result)
        
    }
}
