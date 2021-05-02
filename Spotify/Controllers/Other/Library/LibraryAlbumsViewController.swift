//
//  LibraryAlbumsViewController.swift
//  Spotify
//
//  Created by Michael Chen on 3/14/21.
//

import UIKit

//child view controller to library view controller
class LibraryAlbumsViewController: UIViewController {

    var albums = [Album]()
    
    private let noAlbumsView = ActionLabelView()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(SearchResultSubtitleTableViewCell.self, forCellReuseIdentifier: SearchResultSubtitleTableViewCell.identifier)
        tableView.isHidden = true
        return tableView
    }()
    
    private var savedObserver: NSObjectProtocol?
    private var deletedObserver: NSObjectProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        setUpNoAlbumsView()
        fetchData()
        //observing album saved notification
        savedObserver = NotificationCenter.default.addObserver(
            forName: .albumSavedNotification,
            object: nil,
            queue: .main,
            using: { [weak self] _ in
                //what to do what we get the notification
                self?.fetchData()
            })
        //used to remove album
        addLongTapGesture()
        
        //observing album deleted notification
        deletedObserver = NotificationCenter.default.addObserver(
            forName: .albumDeletedNotification,
            object: nil,
            queue: .main,
            using: { [weak self] _ in
                //what to do what we get the notification
                self?.fetchData()
            })
    }
    
    
    @objc func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noAlbumsView.frame = CGRect(x: (view.width-150)/2, y: (view.height-150)/2, width: 150, height: 150)
        tableView.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
    }
    
    
    private func updateUI(){
        if albums.isEmpty{
            //show label
            print("show label")
            noAlbumsView.isHidden = false
            tableView.isHidden = true
        }
        else {
            //show table
            tableView.reloadData()
            tableView.isHidden = false
            noAlbumsView.isHidden = true
        }
    }
    
    
    private func setUpNoAlbumsView(){
        view.addSubview(noAlbumsView)
        noAlbumsView.delegate = self
        noAlbumsView.configure(with: ActionLabelViewViewModel(text: "You have not saved any albums yet", actionTitle: "Browse"))
    }
    
    private func fetchData(){
        //to get most update album list when notification is observed
        albums.removeAll()
        APICaller.shared.getCurrentUserAlbum { [weak self] result in
            DispatchQueue.main.async {
                switch result{
                case .success(let albums):
                    print("albums: \(albums)")
                    self?.albums = albums
                    self?.updateUI()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
        

}

//intern relationship with action label view
extension LibraryAlbumsViewController: ActionLabelViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    func actionLabelViewDidTapButton(_ actionView: ActionLabelView) {
        //when we tap action label view which will appear when there is
        //no album it brings to first tab where they are albums to choose to add
        tabBarController?.selectedIndex = 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchResultSubtitleTableViewCell.identifier,
            for: indexPath
        ) as? SearchResultSubtitleTableViewCell else {
            return UITableViewCell()
        }
        
        let album = albums[indexPath.row]
        
        cell.configure(with: SearchResultSubtitleTableViewCellViewModel(title: album.name,
                                                                        subtitle: album.artists.first?.name ?? "-",
                                                                        imageURL: URL(string: album.images.first?.url ?? "")))
        
        return cell

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        HapticsManager.shared.vibrateForSelection()
        let album = albums[indexPath.row]
        
        //go to album view
        let vc = AlbumViewController(album: album)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
    //allow users to remove album from library
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
        guard let indexPath = tableView.indexPathForRow(at: touchPoint) else {
            return
        }
        
        //for that particular section, get the result for that row
        let album = albums[indexPath.row]
        
    
            
        let actionSheet = UIAlertController(title: album.name,
                                            message: "Would you like to remove this album?",
                                            preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Remove Album", style: .default, handler: { _ in
            print("Will remove album")
            DispatchQueue.main.async {
                APICaller.shared.deleteAlbum(album: album) { (success) in
                    print("Removed album success: \(success)")
                    if success{
                        HapticsManager.shared.vibrate(for: .success)
                        //posting/sending notification, letting whoever that is listening(LibraryAlbumViewController) know
                        NotificationCenter.default.post(name: .albumDeletedNotification, object: nil)
                    }
                    else{
                        HapticsManager.shared.vibrate(for: .error)
                    }
                    
                    
                    
                }
            }
        })
        
        
        )
            
        
        
        present(actionSheet, animated: true)
        
        
    }
    


}
