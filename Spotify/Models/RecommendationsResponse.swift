//
//  RecommendationsResponse.swift
//  Spotify
//
//  Created by Michael Chen on 2/28/21.
//

import Foundation

struct RecommendationsResponse: Codable {
    let tracks : [AudioTrack]
}

/*
 MOVED TO AUDIOTRACK FILE
struct AudioTrack: Codable {
    let album: Album
    let artists: [Artist]
    let available_markets: String
    let disc_number: Int
    let duration_ms: Int
    let explicit: Bool
    let external_urls: [String: String]
    let id: String
    let name: String
    let popularity: Int
    
}
*/




/*
//response from get recommendations spotifiy api call
{
    seeds =     (
                {
            afterFilteringSize = 251;
            afterRelinkingSize = 251;
            href = "<null>";
            id = "show-tunes";
            initialPoolSize = 1000;
            type = GENRE;
        },
                {
            afterFilteringSize = 251;
            afterRelinkingSize = 251;
            href = "<null>";
            id = "minimal-techno";
            initialPoolSize = 1000;
            type = GENRE;
        },
                {
            afterFilteringSize = 251;
            afterRelinkingSize = 251;
            href = "<null>";
            id = happy;
            initialPoolSize = 1000;
            type = GENRE;
        },
                {
            afterFilteringSize = 251;
            afterRelinkingSize = 251;
            href = "<null>";
            id = romance;
            initialPoolSize = 1000;
            type = GENRE;
        },
                {
            afterFilteringSize = 50;
            afterRelinkingSize = 50;
            href = "<null>";
            id = "new-release";
            initialPoolSize = 50;
            type = GENRE;
        }
    );
    tracks =     (
                {
            album =             {
                "album_type" = COMPILATION;
                artists =                 (
                                        {
                        "external_urls" =                         {
                            spotify = "https://open.spotify.com/artist/0LyfQWJT6nXafLPZqxe9Of";
                        };
                        href = "https://api.spotify.com/v1/artists/0LyfQWJT6nXafLPZqxe9Of";
                        id = 0LyfQWJT6nXafLPZqxe9Of;
                        name = "Various Artists";
                        type = artist;
                        uri = "spotify:artist:0LyfQWJT6nXafLPZqxe9Of";
                    }
                );
                "available_markets" =                 (
                );
                "external_urls" =                 {
                    spotify = "https://open.spotify.com/album/3upWDUZL9GwmHXC3y2vHUy";
                };
                href = "https://api.spotify.com/v1/albums/3upWDUZL9GwmHXC3y2vHUy";
                id = 3upWDUZL9GwmHXC3y2vHUy;
                images =                 (
                                        {
                        height = 640;
                        url = "https://i.scdn.co/image/ab67616d0000b273f2e4af41e0ffc6ebc7a0034a";
                        width = 640;
                    },
                                        {
                        height = 300;
                        url = "https://i.scdn.co/image/ab67616d00001e02f2e4af41e0ffc6ebc7a0034a";
                        width = 300;
                    },
                                        {
                        height = 64;
                        url = "https://i.scdn.co/image/ab67616d00004851f2e4af41e0ffc6ebc7a0034a";
                        width = 64;
                    }
                );
                name = "Berlin Afterhour 2 - From Minimal to Techno - From Electro to House";
                "release_date" = "2010-10-15";
                "release_date_precision" = day;
                "total_tracks" = 40;
                type = album;
                uri = "spotify:album:3upWDUZL9GwmHXC3y2vHUy";
            };
            artists =             (
                                {
                    "external_urls" =                     {
                        spotify = "https://open.spotify.com/artist/3A8XSMPreJlCBlpSZVHU5J";
                    };
                    href = "https://api.spotify.com/v1/artists/3A8XSMPreJlCBlpSZVHU5J";
                    id = 3A8XSMPreJlCBlpSZVHU5J;
                    name = "Shlomi Aber";
                    type = artist;
                    uri = "spotify:artist:3A8XSMPreJlCBlpSZVHU5J";
                }
            );
            "available_markets" =             (
            );
            "disc_number" = 1;
            "duration_ms" = 453080;
            explicit = 0;
            "external_ids" =             {
                isrc = US4LK1002041;
            };
            "external_urls" =             {
                spotify = "https://open.spotify.com/track/6ZB5EGf3qYqLrj94npde84";
            };
            href = "https://api.spotify.com/v1/tracks/6ZB5EGf3qYqLrj94npde84";
            id = 6ZB5EGf3qYqLrj94npde84;
            "is_local" = 0;
            name = "Slow Dancer";
            popularity = 0;
            "preview_url" = "<null>";
            "track_number" = 10;
            type = track;
            uri = "spotify:track:6ZB5EGf3qYqLrj94npde84";
        }
    );
}
*/
