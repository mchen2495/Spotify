//
//  PlayerViewController.swift
//  Spotify
//
//  Created by Michael Chen on 2/22/21.
//

import UIKit
import SDWebImage

//boss relationship
protocol PlayerViewControllerDelegate: AnyObject {
    func didTapPlayPause()
    func didTapNext()
    func didTapBackward()
    func didSlideSlider(_ value: Float)
}

class PlayerViewController: UIViewController {
    
    //this value is assigned when playbackPresenter playback method is used
    weak var datasource: PlayerDataSource?
    //this value is assigned when playbackPresenter playback method is used
    weak var delegate: PlayerViewControllerDelegate?
    
    private let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let controlsView = PlayerControlsView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
        view.addSubview(controlsView)
        controlsView.delegate = self
        configureBarButton()
        configure()
    }
    
    
    private func configure(){
        imageView.sd_setImage(with: datasource?.imageURL, completed: nil)
        controlsView.configure(with: PlayControlsViewViewModel(title: datasource?.songName, subtitle: datasource?.subtitle))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.width)
        controlsView.frame = CGRect(x: 10,
                                    y: imageView.bottum+10,
                                    width: view.width-20,
                                    height: view.height-imageView.height-view.safeAreaInsets.top-view.safeAreaInsets.bottom-15)
    }
    
    private func configureBarButton(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapAction))
    }
    

    @objc func didTapClose(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapAction(){
        //Actions
    }
    
    func refreshUI(){
        configure()
    }
    
    
}

//intern relationship with player controls view
extension PlayerViewController: PlayerControlsViewDelegate {
    func playerControlsView(_ playerControlsView: PlayerControlsView, didSlideSlider value: Float) {
        delegate?.didSlideSlider(value)
    }
    
    
    func playerControlsViewdidTapPlayPause(_ playerControlsView: PlayerControlsView) {
        delegate?.didTapPlayPause()
    }
    
    func playerControlsViewdidTapNextButtom(_ playerControlsView: PlayerControlsView) {
        delegate?.didTapNext()
    }
    
    func playerControlsViewdidTapBackwardButton(_ playerControlsView: PlayerControlsView) {
        delegate?.didTapBackward()
    }
    
    
    
    
    
}
