//
//  SearchResult.swift
//  Spotify
//
//  Created by Michael Chen on 3/7/21.
//

import Foundation

enum SearchResult {
    case artist(model: Artist)
    case album(model: Album)
    case track(model: AudioTrack)
    case playlist(model: Playlist)
}
