//
//  FeaturePlaylistsResponse.swift
//  Spotify
//
//  Created by Michael Chen on 2/28/21.
//

import Foundation

struct FeaturePlaylistsResponse: Codable {
    let playlists: PlaylistResponse
}

struct CategoryPlaylistsResponse: Codable {
    let playlists: PlaylistResponse
}

struct PlaylistResponse: Codable {
    let items: [Playlist]
}

/*
MOVED TO PLAYLIST FILE
struct Playlist: Codable {
    let description: String
    let external_urls: [String: String]
    let id : String
    let images: [APIImage]
    let name: String
    let owner: User
    
    
}
*/

struct User: Codable {
    let display_name : String
    let external_urls : [String: String]
    let id : String
}

/*
//response from feature playlist spotifiy api call
{
    message = "Selecci\U00f3n del editor";
    playlists =     {
        href = "https://api.spotify.com/v1/browse/featured-playlists?timestamp=2021-02-28T21%3A05%3A53&offset=0&limit=2";
        items =         (
                        {
                collaborative = 0;
                description = "A mega mix of 75 of your favorite songs from the last few years! Cover: Justin Bieber";
                "external_urls" =                 {
                    spotify = "https://open.spotify.com/playlist/37i9dQZF1DXbYM3nMM0oPk";
                };
                href = "https://api.spotify.com/v1/playlists/37i9dQZF1DXbYM3nMM0oPk";
                id = 37i9dQZF1DXbYM3nMM0oPk;
                images =                 (
                                        {
                        height = "<null>";
                        url = "https://i.scdn.co/image/ab67706f00000003db11b346997ff5cc78298028";
                        width = "<null>";
                    }
                );
                name = "Mega Hit Mix";
                owner =                 {
                    "display_name" = Spotify;
                    "external_urls" =                     {
                        spotify = "https://open.spotify.com/user/spotify";
                    };
                    href = "https://api.spotify.com/v1/users/spotify";
                    id = spotify;
                    type = user;
                    uri = "spotify:user:spotify";
                };
                "primary_color" = "<null>";
                public = "<null>";
                "snapshot_id" = MTYxNDU0NjM1MywwMDAwMDAwMGQ0MWQ4Y2Q5OGYwMGIyMDRlOTgwMDk5OGVjZjg0Mjdl;
                tracks =                 {
                    href = "https://api.spotify.com/v1/playlists/37i9dQZF1DXbYM3nMM0oPk/tracks";
                    total = 75;
                };
                type = playlist;
                uri = "spotify:playlist:37i9dQZF1DXbYM3nMM0oPk";
            }
            
        );
        limit = 2;
        next = "https://api.spotify.com/v1/browse/featured-playlists?timestamp=2021-02-28T21%3A05%3A53&offset=2&limit=2";
        offset = 0;
        previous = "<null>";
        total = 12;
    };
}
*/





/*
 Samr response model
 
 Response from get playlist for a category
 
 {
     playlists =     {
         href = "https://api.spotify.com/v1/browse/categories/toplists/playlists?offset=0&limit=2";
         items =         (
                         {
                 collaborative = 0;
                 description = "Selena Gomez is on top of the Hottest 50!";
                 "external_urls" =                 {
                     spotify = "https://open.spotify.com/playlist/37i9dQZF1DXcBWIGoYBM5M";
                 };
                 href = "https://api.spotify.com/v1/playlists/37i9dQZF1DXcBWIGoYBM5M";
                 id = 37i9dQZF1DXcBWIGoYBM5M;
                 images =                 (
                                         {
                         height = "<null>";
                         url = "https://i.scdn.co/image/ab67706f000000039668ab2e9ba81a94e5f24b51";
                         width = "<null>";
                     }
                 );
                 name = "Today's Top Hits";
                 owner =                 {
                     "display_name" = Spotify;
                     "external_urls" =                     {
                         spotify = "https://open.spotify.com/user/spotify";
                     };
                     href = "https://api.spotify.com/v1/users/spotify";
                     id = spotify;
                     type = user;
                     uri = "spotify:user:spotify";
                 };
                 "primary_color" = "<null>";
                 public = "<null>";
                 "snapshot_id" = MTYxNDkyMDQ4OCwwMDAwMDQ4NDAwMDAwMTc4MDBjMzE3ZWEwMDAwMDE3N2ZmYzg5NGIy;
                 tracks =                 {
                     href = "https://api.spotify.com/v1/playlists/37i9dQZF1DXcBWIGoYBM5M/tracks";
                     total = 50;
                 };
                 type = playlist;
                 uri = "spotify:playlist:37i9dQZF1DXcBWIGoYBM5M";
             },
                         {
                 collaborative = 0;
                 description = "New music from Drake, Lil Baby and YNW Melly.";
                 "external_urls" =                 {
                     spotify = "https://open.spotify.com/playlist/37i9dQZF1DX0XUsuxWHRQd";
                 };
                 href = "https://api.spotify.com/v1/playlists/37i9dQZF1DX0XUsuxWHRQd";
                 id = 37i9dQZF1DX0XUsuxWHRQd;
                 images =                 (
                                         {
                         height = "<null>";
                         url = "https://i.scdn.co/image/ab67706f0000000302e9f41c49c2a8e1512e2077";
                         width = "<null>";
                     }
                 );
                 name = RapCaviar;
                 owner =                 {
                     "display_name" = Spotify;
                     "external_urls" =                     {
                         spotify = "https://open.spotify.com/user/spotify";
                     };
                     href = "https://api.spotify.com/v1/users/spotify";
                     id = spotify;
                     type = user;
                     uri = "spotify:user:spotify";
                 };
                 "primary_color" = "<null>";
                 public = "<null>";
                 "snapshot_id" = MTYxNDkyMDQwMCwwMDAwMDU1NTAwMDAwMTc4MDBjMWJkOGYwMDAwMDE3ODAwYjI5ZjQx;
                 tracks =                 {
                     href = "https://api.spotify.com/v1/playlists/37i9dQZF1DX0XUsuxWHRQd/tracks";
                     total = 50;
                 };
                 type = playlist;
                 uri = "spotify:playlist:37i9dQZF1DX0XUsuxWHRQd";
             }
         );
         limit = 2;
         next = "https://api.spotify.com/v1/browse/categories/toplists/playlists?offset=2&limit=2";
         offset = 0;
         previous = "<null>";
         total = 12;
     };
 }
 
 
 
 
 
 
 */
