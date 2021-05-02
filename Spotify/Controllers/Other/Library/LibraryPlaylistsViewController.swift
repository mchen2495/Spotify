//
//  LibraryPlaylistsViewController.swift
//  Spotify
//
//  Created by Michael Chen on 3/14/21.
//

import UIKit

//child view controller to library view controller
class LibraryPlaylistsViewController: UIViewController {
    
    var playlists = [Playlist]()
    
    public var selectionHandler: ((Playlist) -> Void)?
    
    private let noPlaylistsView = ActionLabelView()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(SearchResultSubtitleTableViewCell.self, forCellReuseIdentifier: SearchResultSubtitleTableViewCell.identifier)
        tableView.isHidden = true
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        setUpNoPlaylistsView()
        fetchData()
        
        if selectionHandler != nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
        }
    }
    
    @objc func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noPlaylistsView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        noPlaylistsView.center = view.center
        tableView.frame = view.bounds
    }
    
    
    private func updateUI(){
        if playlists.isEmpty{
            //show label
            noPlaylistsView.isHidden = false
            tableView.isHidden = true
        }
        else {
            //show table
            tableView.reloadData()
            tableView.isHidden = false
            noPlaylistsView.isHidden = true
        }
    }
    
    
    private func setUpNoPlaylistsView(){
        view.addSubview(noPlaylistsView)
        noPlaylistsView.delegate = self
        noPlaylistsView.configure(with: ActionLabelViewViewModel(text: "You don't have any playlists yet", actionTitle: "Create"))
    }
    
    private func fetchData(){
        APICaller.shared.getCurrentUserPlaylist { [weak self] result in
            DispatchQueue.main.async {
                switch result{
                case .success(let playlists):
                    self?.playlists = playlists
                    self?.updateUI()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        }
    }
    

    public func showCreatePlaylistAlert() {
        let alert = UIAlertController(title: "New Playlist",
                                      message: "Enter playlist name",
                                      preferredStyle: .alert)
        alert.addTextField { textfield in
            textfield.placeholder = "Playlist..."
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { _ in
            //checking that text is entered and that it is not empty spaces
            guard let field = alert.textFields?.first,
                  let text = field.text,
                  !text.trimmingCharacters(in: .whitespaces).isEmpty else{
                return
            }
            APICaller.shared.createPlaylist(with: text) { [weak self] success in
                if success {
                    HapticsManager.shared.vibrate(for: .success)
                    //refresh list of playlist, fetch data again beacuse we have added a playlist
                    self?.fetchData()
                }
                else {
                    HapticsManager.shared.vibrate(for: .error)
                    print("Failed to create playlist")
                }
            }
        }))
        
        present(alert, animated: true)
    }
    

}

//intern relationship with action label view
extension LibraryPlaylistsViewController: ActionLabelViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    func actionLabelViewDidTapButton(_ actionView: ActionLabelView) {
        //when we tap action label view which will appear when there is
        //no album it brings to first tab where they are albums to choose to add
        showCreatePlaylistAlert()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchResultSubtitleTableViewCell.identifier,
            for: indexPath
        ) as? SearchResultSubtitleTableViewCell else {
            return UITableViewCell()
        }
        
        let playlist = playlists[indexPath.row]
        
        cell.configure(with: SearchResultSubtitleTableViewCellViewModel(title: playlist.name,
                                                                        subtitle: playlist.owner.display_name,
                                                                        imageURL: URL(string: playlist.images.first?.url ?? "")))
        
        return cell

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        HapticsManager.shared.vibrateForSelection()
        let playlist = playlists[indexPath.row]
        
        //check whether we are selecting playlist to go to playlist view or select it to add a song to it
        guard selectionHandler == nil else {
            //adding song to playlist
            selectionHandler?(playlist)
            dismiss(animated: true, completion: nil)
            return
        }
        
        //go to playlist view
        let vc = PlaylistViewController(playlist: playlist)
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.isOwner = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
}
