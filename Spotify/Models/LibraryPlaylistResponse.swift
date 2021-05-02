//
//  LibraryPlaylistResponse.swift
//  Spotify
//
//  Created by Michael Chen on 3/14/21.
//

import Foundation

//model to the response of getting the current user's playlists
struct LibraryPlaylistResponse: Codable {
    let items: [Playlist]
}
