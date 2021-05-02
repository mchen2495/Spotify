//
//  SettingsModel.swift
//  Spotify
//
//  Created by Michael Chen on 2/26/21.
//

import Foundation

struct Section {
    let title: String
    let options: [Option]
}



struct Option {
    let title: String
    let handler: () -> Void
}
