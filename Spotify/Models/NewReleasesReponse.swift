//
//  NewReleasesReponse.swift
//  Spotify
//
//  Created by Michael Chen on 2/28/21.
//

import Foundation

//each property inside of the belew structs matches to a field from the new release api reponse
struct NewReleasesResponse: Codable {
    let albums: AlbumsResponse
}




struct AlbumsResponse: Codable {
    let items: [Album]
}

//images is var beacuse we want to give each track an reference to the album's artwork
struct Album: Codable {
    let album_type: String
    let available_markets: [String]
    let id: String
    var images: [APIImage]
    let name: String
    let release_date: String
    let total_tracks: Int
    let artists: [Artist]
    
}





/*
//response from new release spotifiy api call
{
    albums =     {
        href = "https://api.spotify.com/v1/browse/new-releases?offset=0&limit=2";
        items =         (
                        {
                "album_type" = single;
                artists =                 (
                                        {
                        "external_urls" =                         {
                            spotify = "https://open.spotify.com/artist/246dkjvS1zLTtiykXe5h60";
                        };
                        href = "https://api.spotify.com/v1/artists/246dkjvS1zLTtiykXe5h60";
                        id = 246dkjvS1zLTtiykXe5h60;
                        name = "Post Malone";
                        type = artist;
                        uri = "spotify:artist:246dkjvS1zLTtiykXe5h60";
                    }
                );
                "available_markets" =                 (
                    AD,
                    AE,
                    AG
                );
                "external_urls" =                 {
                    spotify = "https://open.spotify.com/album/2xZhidR4y5OPpCRYF09XB4";
                };
                href = "https://api.spotify.com/v1/albums/2xZhidR4y5OPpCRYF09XB4";
                id = 2xZhidR4y5OPpCRYF09XB4;
                images =                 (
                                        {
                        height = 640;
                        url = "https://i.scdn.co/image/ab67616d0000b273d06b152b24e9357e81c460fe";
                        width = 640;
                    },
                                        {
                        height = 300;
                        url = "https://i.scdn.co/image/ab67616d00001e02d06b152b24e9357e81c460fe";
                        width = 300;
                    },
                                        {
                        height = 64;
                        url = "https://i.scdn.co/image/ab67616d00004851d06b152b24e9357e81c460fe";
                        width = 64;
                    }
                );
                name = "Only Wanna Be With You (Pok\U00e9mon 25 Version)";
                "release_date" = "2021-02-25";
                "release_date_precision" = day;
                "total_tracks" = 1;
                type = album;
                uri = "spotify:album:2xZhidR4y5OPpCRYF09XB4";
            },
                        
        limit = 2;
        next = "https://api.spotify.com/v1/browse/new-releases?offset=2&limit=2";
        offset = 0;
        previous = "<null>";
        total = 100;
    };
}

*/
