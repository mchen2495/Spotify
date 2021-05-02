//
//  AudioTrack.swift
//  Spotify
//
//  Created by Michael Chen on 2/22/21.
//

import Foundation

struct AudioTrack: Codable {
    //album is optional beacuse AlbumDetail response dont have "album" item
    //album is var beacuse we want to give each track an reference to the album to get the artwork
    var album: Album?
    let artists: [Artist]
    let available_markets: [String]
    let disc_number: Int
    let duration_ms: Int
    let explicit: Bool
    let external_urls: [String: String]
    let id: String
    let name: String
    let preview_url:String?
    let uri: String?
    //let href: String?
    //let popularity: Int
    
}
