//
//  AllCatergoriesResponse.swift
//  Spotify
//
//  Created by Michael Chen on 3/7/21.
//

import Foundation

struct AllCategoriesResponse: Codable {
    let categories: Categories
    
}

struct Categories: Codable {
    let items: [Category]
}


struct Category: Codable {
    let icons: [APIImage]
    let id: String
    let name: String
}


/*
 Response from get categories api call
 
 {
     categories =     {
         href = "https://api.spotify.com/v1/browse/categories?offset=0&limit=2";
         items =         (
                         {
                 href = "https://api.spotify.com/v1/browse/categories/toplists";
                 icons =                 (
                                         {
                         height = 275;
                         url = "https://t.scdn.co/media/derived/toplists_11160599e6a04ac5d6f2757f5511778f_0_0_275_275.jpg";
                         width = 275;
                     }
                 );
                 id = toplists;
                 name = "Top Lists";
             },
                         {
                 href = "https://api.spotify.com/v1/browse/categories/hiphop";
                 icons =                 (
                                         {
                         height = 274;
                         url = "https://t.scdn.co/media/original/hip-274_0a661854d61e29eace5fe63f73495e68_274x274.jpg";
                         width = 274;
                     }
                 );
                 id = hiphop;
                 name = "Hip Hop";
             }
         );
         limit = 2;
         next = "https://api.spotify.com/v1/browse/categories?offset=2&limit=2";
         offset = 0;
         previous = "<null>";
         total = 54;
     };
 }
 
 
 */
