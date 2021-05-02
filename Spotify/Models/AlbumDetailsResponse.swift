//
//  AlbumDetailsResponse.swift
//  Spotify
//
//  Created by Michael Chen on 3/3/21.
//

import Foundation

struct AlbumDetailsResponse: Codable {
    let album_type: String
    let artists: [Artist]
    let available_markets: [String]
    let external_urls: [String: String]
    let id: String
    let images: [APIImage]
    let label: String
    let name: String
    let tracks: TracksResponse
}


struct TracksResponse: Codable {
    let items: [AudioTrack]
}



/*
{
    "album_type" = single;
    artists =     (
                {
            "external_urls" =             {
                spotify = "https://open.spotify.com/artist/246dkjvS1zLTtiykXe5h60";
            };
            href = "https://api.spotify.com/v1/artists/246dkjvS1zLTtiykXe5h60";
            id = 246dkjvS1zLTtiykXe5h60;
            name = "Post Malone";
            type = artist;
            uri = "spotify:artist:246dkjvS1zLTtiykXe5h60";
        }
    );
    "available_markets" =     (
        AD,
        AE,
        AG
    );
    copyrights =     (
                {
            text = "\U00a9 2021 Republic Records, a division of UMG Recordings, Inc.";
            type = C;
        },
                {
            text = "\U2117 2021 Republic Records, a division of UMG Recordings, Inc.";
            type = P;
        }
    );
    "external_ids" =     {
        upc = 00602435887791;
    };
    "external_urls" =     {
        spotify = "https://open.spotify.com/album/2xZhidR4y5OPpCRYF09XB4";
    };
    genres =     (
    );
    href = "https://api.spotify.com/v1/albums/2xZhidR4y5OPpCRYF09XB4";
    id = 2xZhidR4y5OPpCRYF09XB4;
    images =     (
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
    label = "Republic Records";
    name = "Only Wanna Be With You (Pok\U00e9mon 25 Version)";
    popularity = 73;
    "release_date" = "2021-02-25";
    "release_date_precision" = day;
    "total_tracks" = 1;
    tracks =     {
        href = "https://api.spotify.com/v1/albums/2xZhidR4y5OPpCRYF09XB4/tracks?offset=0&limit=50";
        items =         (
                        {
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
                "disc_number" = 1;
                "duration_ms" = 241360;
                explicit = 0;
                "external_urls" =                 {
                    spotify = "https://open.spotify.com/track/3SawmGBjjq8EOYZJV11cJm";
                };
                href = "https://api.spotify.com/v1/tracks/3SawmGBjjq8EOYZJV11cJm";
                id = 3SawmGBjjq8EOYZJV11cJm;
                "is_local" = 0;
                name = "Only Wanna Be With You - Pok\U00e9mon 25 Version";
                "preview_url" = "https://p.scdn.co/mp3-preview/0f72d09f75c2b36e8684b0f9a631d874cdc441a4?cid=34a0b62f1cf54be2aabb3861e24e4fc8";
                "track_number" = 1;
                type = track;
                uri = "spotify:track:3SawmGBjjq8EOYZJV11cJm";
            }
        );
        limit = 50;
        next = "<null>";
        offset = 0;
        previous = "<null>";
        total = 1;
    };
    type = album;
    uri = "spotify:album:2xZhidR4y5OPpCRYF09XB4";
}
*/
