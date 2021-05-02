//
//  LibraryToggleView.swift
//  Spotify
//
//  Created by Michael Chen on 3/14/21.
//

import UIKit

//boss relationship with library view controller
protocol LibraryToggleViewDelegate: AnyObject {
    func LibraryToggleViewDidTapPlaylists(_ toggleView: LibraryToggleView)
    func LibraryToggleViewDidTapAlbums(_ toggleView: LibraryToggleView)
}

class LibraryToggleView: UIView {
    
    enum State {
        case playlist
        case album
    }
    
    var state: State = .playlist
    
    weak var delegate: LibraryToggleViewDelegate?
    
    private let playlistButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setTitle("Playlists", for: .normal)
        return button
    }()
    
    private let albumsButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setTitle("Albums", for: .normal)
        return button
    }()
    
    private let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGreen
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 4
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(playlistButton)
        addSubview(albumsButton)
        addSubview(indicatorView)
        playlistButton.addTarget(self, action: #selector(didTapPlaylists), for: .touchUpInside)
        
        albumsButton.addTarget(self, action: #selector(didTapAlbums), for: .touchUpInside)
    }
    
    @objc func didTapPlaylists(){
        state = .playlist
        UIView.animate(withDuration: 0.2) {
            self.layoutIndicator()
        }
        delegate?.LibraryToggleViewDidTapPlaylists(self)
    }
    
    @objc func didTapAlbums(){
        state = .album
        UIView.animate(withDuration: 0.2) {
            self.layoutIndicator()
        }
        delegate?.LibraryToggleViewDidTapAlbums(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playlistButton.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        albumsButton.frame = CGRect(x: playlistButton.right, y: 0, width: 100, height: 40)
        layoutIndicator()
    }
    
    //determines where the indcator need to be under to show which view user is on (playlist or album)
    func layoutIndicator(){
        switch state {
        case .playlist:
            indicatorView.frame = CGRect(x: 0, y: playlistButton.bottum, width: 100, height: 3)
        case .album:
            indicatorView.frame = CGRect(x: 100, y: albumsButton.bottum, width: 100, height: 3)
        }
    }
    
    
    func update(for state: State){
        self.state = state
        UIView.animate(withDuration: 0.2) {
            self.layoutIndicator()
        }
    }
    

}
