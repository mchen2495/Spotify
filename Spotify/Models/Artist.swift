//
//  Artist.swift
//  Spotify
//
//  Created by Michael Chen on 2/22/21.
//

import Foundation

struct Artist: Codable {
    let id: String
    let name: String
    let type: String
    let images: [APIImage]?
    let external_urls: [String: String]
}
