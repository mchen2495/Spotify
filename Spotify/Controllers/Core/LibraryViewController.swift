//
//  LibraryViewController.swift
//  Spotify
//
//  Created by Michael Chen on 2/22/21.
//

import UIKit

class LibraryViewController: UIViewController {
    
    private let playlistsVC = LibraryPlaylistsViewController()
    private let albumsVC = LibraryAlbumsViewController()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        return scrollView
    }()
    
    private let toggleView = LibraryToggleView()
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Library"
        label.font = .systemFont(ofSize: 36, weight: .bold)
        label.textColor = .systemRed
        return label
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        toggleView.delegate = self
        scrollView.delegate = self
        view.addSubview(scrollView)
        view.addSubview(toggleView)
        scrollView.contentSize = CGSize(width: view.width*2, height: scrollView.height)
        addChildren()
        updateBarButton()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = CGRect(x: 0,
                                  y: view.safeAreaInsets.top + 55,
                                  width: view.width,
                                  height: view.height-view.safeAreaInsets.top-view.safeAreaInsets.bottom-55)
        
        toggleView.frame = CGRect(x: 0,
                                  y: view.safeAreaInsets.top,
                                  width: 200,
                                  height: 50)
    }
    
    
    
    private func addChildren() {
        //allows playlistsVC life cycle to work inside of parent view (LibraryViewController)
        addChild(playlistsVC)
        scrollView.addSubview(playlistsVC.view)
        playlistsVC.view.frame = CGRect(x: 0, y: 0, width: scrollView.width, height: scrollView.height)
        //indicating that this controller is parent to playlistsVC
        playlistsVC.didMove(toParent: self)
        
        
        //same for albumsVC
        addChild(albumsVC)
        scrollView.addSubview(albumsVC.view)
        albumsVC.view.frame = CGRect(x: view.width, y: 0, width: scrollView.width, height: scrollView.height)
        albumsVC.didMove(toParent: self)
        
        
    }
    
    
    private func updateBarButton(){
        switch toggleView.state {
        case .playlist:
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self,
                                                                action: #selector(didTapAdd))
        case .album:
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    @objc private func didTapAdd(){
        playlistsVC.showCreatePlaylistAlert()
    }

    
    
    

}

//intern relationship to LibraryToggleView and other views
extension LibraryViewController: UIScrollViewDelegate, LibraryToggleViewDelegate {
   
    //when user scrolls
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //determines how much user have scrolls and to animate the indiactor of which view there are on (playlists or album)
        if scrollView.contentOffset.x >= (view.width - 100){
            toggleView.update(for: .album)
            updateBarButton()
        }
        else {
            toggleView.update(for: .playlist)
            updateBarButton()
        }
    }
    
    func LibraryToggleViewDidTapPlaylists(_ toggleView: LibraryToggleView) {
        //move to playlist view on scrollview
        scrollView.setContentOffset(.zero, animated: true)
        updateBarButton()
    }
    
    func LibraryToggleViewDidTapAlbums(_ toggleView: LibraryToggleView) {
        //move to albums view on scrollview (move one width over from .zero) since each view is width of the screen
        scrollView.setContentOffset(CGPoint(x: view.width, y: 0), animated: true)
        updateBarButton()
    }
    
    
}
