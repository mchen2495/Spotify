//
//  PlaybackPresenter.swift
//  Spotify
//
//  Created by Michael Chen on 3/9/21.
//

import Foundation
import UIKit
import AVFoundation

//playerQueue songs is out of sync with tracks for play all


//boss relationship 
protocol PlayerDataSource: AnyObject {
    var songName: String? {get}
    var subtitle: String? {get}
    var imageURL: URL? {get}
}

final class PlaybackPresenter {
    static let shared = PlaybackPresenter()
    
    private var track: AudioTrack?
    private var tracks = [AudioTrack]()
    
    var currentIndex = 0
    
    var currentTrack: AudioTrack? {
        if let track = track, tracks.isEmpty {
            return track
        }
        else if let player = self.playerQueue, !tracks.isEmpty {
//            let item = player.currentItem
//            let items = player.items()
//            guard let index = items.firstIndex(where: {$0 == item}) else {
//                return nil
//            }
            return tracks[currentIndex]
            
        }
        return nil
        
    }
    
    var playerVC: PlayerViewController?
    
    var player: AVPlayer?
    var playerQueue: AVQueuePlayer?
    
    //playback for a song
    func startPlayback(from viewController: UIViewController,
                              track: AudioTrack
    ){
        guard let url = URL(string: track.preview_url ?? "") else {
            return
        }
        player = AVPlayer(url: url)
        player?.volume = 0.5
        //APICaller.shared.playback()
        
        self.track = track
        self.tracks = []
        let vc = PlayerViewController()
        vc.title = track.name
        vc.datasource = self
        vc.delegate = self
        
        viewController.present(UINavigationController(rootViewController: vc), animated: true) { [weak self] in
            self?.player?.play()
        }
        
        self.playerVC = vc
        
    }
    
    //playback for a list of songs such as album or playlist
    func startPlayback(from viewController: UIViewController,
                              tracks: [AudioTrack]
    ){
        self.tracks = tracks
        self.track = nil

        //turning each item in tracks to a AVPlayerItem
        let items: [AVPlayerItem] = tracks.compactMap {
            guard let url = URL(string: $0.preview_url ?? "https://p.scdn.co/mp3-preview/e599739fbf3447e92ae720737a7f5d5df05423a6?cid=34a0b62f1cf54be2aabb3861e24e4fc8") else {
                return nil
            }
            return AVPlayerItem(url: url)
        }

        self.playerQueue = AVQueuePlayer(items: items)
        self.playerQueue?.volume = 0.5
        self.playerQueue?.play()

        let vc = PlayerViewController()
        vc.datasource = self
        vc.delegate = self

        viewController.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
        self.playerVC = vc
    }
    
}


//intern relationship playerviewController
extension PlaybackPresenter: PlayerDataSource, PlayerViewControllerDelegate {
    
    func didTapPlayPause() {
        if let player = player {
            //if the player is playing make it pause, if it is paused make it play
            if player.timeControlStatus == .playing {
                player.pause()
            }
            else if player.timeControlStatus == .paused {
                player.play()
            }
        }
        
        //playing an album/aplaylist
        if let playerQueue = playerQueue {
            //if the player is playing make it pause, if it is paused make it play
            if playerQueue.timeControlStatus == .playing {
                playerQueue.pause()
            }
            else if playerQueue.timeControlStatus == .paused {
                playerQueue.play()
            }
        }
        
    }
    
    func didTapNext() {
        //not playlist or album
        if tracks.isEmpty{
            player?.pause()
        }
        else if let player = playerQueue {
            player.advanceToNextItem()
            currentIndex += 1

            playerVC?.refreshUI()
        }
    }
    
    func didTapBackward() {
        //not playlist or album
        if tracks.isEmpty{
            player?.pause()
            player?.play()
        }
        else if let firstItem = playerQueue?.items().first {
            playerQueue?.pause()
            playerQueue?.removeAllItems()
            playerQueue = AVQueuePlayer(items: [firstItem])
            playerQueue?.play()
            playerQueue?.volume = 0.5
        }
    }
    
    func didSlideSlider(_ value: Float) {
        player?.volume = value
    }
    
    var songName: String? {
        return currentTrack?.name
    }
    
    var subtitle: String? {
        return currentTrack?.artists.first?.name
    }
    
    var imageURL: URL? {
        return URL(string: currentTrack?.album?.images.first?.url ?? "")
    }
}
