//
//  SearchResultResponse.swift
//  Spotify
//
//  Created by Michael Chen on 3/7/21.
//

import Foundation

struct SearchResultResponse:Codable {
    let albums: SearchAlbumsResponse
    let artists: SearchArtistsResponse
    let playlists: SearchPlayistsResponse
    let tracks: SearchTracksResponse
}


struct SearchAlbumsResponse: Codable {
    let items: [Album]
}

struct SearchArtistsResponse: Codable {
    let items: [Artist]
}

struct SearchPlayistsResponse: Codable {
    let items: [Playlist]
}

struct SearchTracksResponse: Codable {
    let items: [AudioTrack]
}
/*
 albums =
 {
     href = "https://api.spotify.com/v1/search?query=All+American&type=album&offset=0&limit=10";
     items =         (
                     {
             "album_type" = album;
             artists =                 (
                                     {
                     "external_urls" =                         {
                         spotify = "https://open.spotify.com/artist/382aq8Pij5V2nE2JMHMoxl";
                     };
                     href = "https://api.spotify.com/v1/artists/382aq8Pij5V2nE2JMHMoxl";
                     id = 382aq8Pij5V2nE2JMHMoxl;
                     name = "Hoodie Allen";
                     type = artist;
                     uri = "spotify:artist:382aq8Pij5V2nE2JMHMoxl";
                 }
             );
             "available_markets" =                 (
                 AD,
                 AE,
                 AG
             );
             "external_urls" =                 {
                 spotify = "https://open.spotify.com/album/3wDPZbAEnzvMY6mlySimUY";
             };
             href = "https://api.spotify.com/v1/albums/3wDPZbAEnzvMY6mlySimUY";
             id = 3wDPZbAEnzvMY6mlySimUY;
             images =                 (
                                     {
                     height = 640;
                     url = "https://i.scdn.co/image/ab67616d0000b273b6cca3b1310bc82f0149f85d";
                     width = 640;
                 },
                                     {
                     height = 300;
                     url = "https://i.scdn.co/image/ab67616d00001e02b6cca3b1310bc82f0149f85d";
                     width = 300;
                 },
                                     {
                     height = 64;
                     url = "https://i.scdn.co/image/ab67616d00004851b6cca3b1310bc82f0149f85d";
                     width = 64;
                 }
             );
             name = "All American";
             "release_date" = "2012-04-10";
             "release_date_precision" = day;
             "total_tracks" = 8;
             type = album;
             uri = "spotify:album:3wDPZbAEnzvMY6mlySimUY";
         },
                     {
             "album_type" = album;
             artists =                 (
                                     {
                     "external_urls" =                         {
                         spotify = "https://open.spotify.com/artist/3vAaWhdBR38Q02ohXqaNHT";
                     };
                     href = "https://api.spotify.com/v1/artists/3vAaWhdBR38Q02ohXqaNHT";
                     id = 3vAaWhdBR38Q02ohXqaNHT;
                     name = "The All-American Rejects";
                     type = artist;
                     uri = "spotify:artist:3vAaWhdBR38Q02ohXqaNHT";
                 }
             );
             "available_markets" =                 (
                 CA,
                 MX,
                 US
             );
             "external_urls" =                 {
                 spotify = "https://open.spotify.com/album/3PWEGZ6CYvXRnr0JCECsDe";
             };
             href = "https://api.spotify.com/v1/albums/3PWEGZ6CYvXRnr0JCECsDe";
             id = 3PWEGZ6CYvXRnr0JCECsDe;
             images =                 (
                                     {
                     height = 640;
                     url = "https://i.scdn.co/image/ab67616d0000b273aaf8c068ffe217db825a1945";
                     width = 640;
                 },
                                     {
                     height = 300;
                     url = "https://i.scdn.co/image/ab67616d00001e02aaf8c068ffe217db825a1945";
                     width = 300;
                 },
                                     {
                     height = 64;
                     url = "https://i.scdn.co/image/ab67616d00004851aaf8c068ffe217db825a1945";
                     width = 64;
                 }
             );
             name = "Move Along";
             "release_date" = "2005-01-01";
             "release_date_precision" = day;
             "total_tracks" = 12;
             type = album;
             uri = "spotify:album:3PWEGZ6CYvXRnr0JCECsDe";
         },
     );
     limit = 10;
     next = "https://api.spotify.com/v1/search?query=All+American&type=album&offset=10&limit=10";
     offset = 0;
     previous = "<null>";
     total = 675;
 }
 
 artists =
 
 {
     href = "https://api.spotify.com/v1/search?query=All+American&type=artist&offset=0&limit=10";
     items =         (
                     {
             "external_urls" =                 {
                 spotify = "https://open.spotify.com/artist/3vAaWhdBR38Q02ohXqaNHT";
             };
             followers =                 {
                 href = "<null>";
                 total = 2041844;
             };
             genres =                 (
                 "modern rock",
                 "neo mellow",
                 "pop punk",
                 "pop rock"
             );
             href = "https://api.spotify.com/v1/artists/3vAaWhdBR38Q02ohXqaNHT";
             id = 3vAaWhdBR38Q02ohXqaNHT;
             images =                 (
                                     {
                     height = 640;
                     url = "https://i.scdn.co/image/62c79a93a1e6c795ce335996ccde270b6488f90c";
                     width = 640;
                 },
                                     {
                     height = 320;
                     url = "https://i.scdn.co/image/c3737695bf815ee96e6768e61c6fde59fb02d4c6";
                     width = 320;
                 },
                                     {
                     height = 160;
                     url = "https://i.scdn.co/image/2ef054d2ee0f09867bf107c5ae6aa01e97082438";
                     width = 160;
                 }
             );
             name = "The All-American Rejects";
             popularity = 73;
             type = artist;
             uri = "spotify:artist:3vAaWhdBR38Q02ohXqaNHT";
         },
                     {
             "external_urls" =                 {
                 spotify = "https://open.spotify.com/artist/7r39mHxFovdh37y6vV5R9S";
             };
             followers =                 {
                 href = "<null>";
                 total = 720;
             };
             genres =                 (
                 "children's choir"
             );
             href = "https://api.spotify.com/v1/artists/7r39mHxFovdh37y6vV5R9S";
             id = 7r39mHxFovdh37y6vV5R9S;
             images =                 (
                                     {
                     height = 640;
                     url = "https://i.scdn.co/image/ab67616d0000b273521c71b31eb239a46e4e7729";
                     width = 640;
                 },
                                     {
                     height = 300;
                     url = "https://i.scdn.co/image/ab67616d00001e02521c71b31eb239a46e4e7729";
                     width = 300;
                 },
                                     {
                     height = 64;
                     url = "https://i.scdn.co/image/ab67616d00004851521c71b31eb239a46e4e7729";
                     width = 64;
                 }
             );
             name = "The All-American Boys Chorus";
             popularity = 33;
             type = artist;
             uri = "spotify:artist:7r39mHxFovdh37y6vV5R9S";
         }
     );
     limit = 10;
     next = "https://api.spotify.com/v1/search?query=All+American&type=artist&offset=10&limit=10";
     offset = 0;
     previous = "<null>";
     total = 83;
 }
 
 playlists =
 
 {
     href = "https://api.spotify.com/v1/search?query=All+American&type=playlist&offset=0&limit=10";
     items =         (
                     {
             collaborative = 0;
             description = "";
             "external_urls" =                 {
                 spotify = "https://open.spotify.com/playlist/7tEdQVQppSXnWfbKrfrmCX";
             };
             href = "https://api.spotify.com/v1/playlists/7tEdQVQppSXnWfbKrfrmCX";
             id = 7tEdQVQppSXnWfbKrfrmCX;
             images =                 (
                                     {
                     height = "<null>";
                     url = "https://i.scdn.co/image/ab67706c0000bebb22964e4a3893481d6e135dc9";
                     width = "<null>";
                 }
             );
             name = "All American - Official TV Show Playlist";
             owner =                 {
                 "display_name" = "All American CW";
                 "external_urls" =                     {
                     spotify = "https://open.spotify.com/user/qre6hyypc3iousysfpw7kivha";
                 };
                 href = "https://api.spotify.com/v1/users/qre6hyypc3iousysfpw7kivha";
                 id = qre6hyypc3iousysfpw7kivha;
                 type = user;
                 uri = "spotify:user:qre6hyypc3iousysfpw7kivha";
             };
             "primary_color" = "<null>";
             public = "<null>";
             "snapshot_id" = "MzIsZjY3YjE1ZDYwODBjZjFhMWFlNTg1ZWNmYTNkODllMGFiYTYyYjgwNg==";
             tracks =                 {
                 href = "https://api.spotify.com/v1/playlists/7tEdQVQppSXnWfbKrfrmCX/tracks";
                 total = 34;
             };
             type = playlist;
             uri = "spotify:playlist:7tEdQVQppSXnWfbKrfrmCX";
         },
                     {
             collaborative = 0;
             description = "This is The All-American Rejects. The essential tracks, all in one playlist.";
             "external_urls" =                 {
                 spotify = "https://open.spotify.com/playlist/37i9dQZF1DZ06evO22rw1W";
             };
             href = "https://api.spotify.com/v1/playlists/37i9dQZF1DZ06evO22rw1W";
             id = 37i9dQZF1DZ06evO22rw1W;
             images =                 (
                                     {
                     height = "<null>";
                     url = "https://thisis-images.scdn.co/37i9dQZF1DZ06evO22rw1W-large.jpg";
                     width = "<null>";
                 }
             );
             name = "This Is The All-American Rejects";
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
             "snapshot_id" = "MjY5MTg0NDIsMDAwMDAwMDA4YTJlMTUzZjNiYzZiODFkMTU5MDliMjQ5NGE1ZDAzMA==";
             tracks =                 {
                 href = "https://api.spotify.com/v1/playlists/37i9dQZF1DZ06evO22rw1W/tracks";
                 total = 43;
             };
             type = playlist;
             uri = "spotify:playlist:37i9dQZF1DZ06evO22rw1W";
         }
     );
     limit = 10;
     next = "https://api.spotify.com/v1/search?query=All+American&type=playlist&offset=10&limit=10";
     offset = 0;
     previous = "<null>";
     total = 2885;
 }
 
 tracks =
 
 {
     href = "https://api.spotify.com/v1/search?query=All+American&type=track&offset=0&limit=10";
     items =         (
                     {
             album =                 {
                 "album_type" = album;
                 artists =                     (
                                             {
                         "external_urls" =                             {
                             spotify = "https://open.spotify.com/artist/4xFUf1FHVy696Q1JQZMTRj";
                         };
                         href = "https://api.spotify.com/v1/artists/4xFUf1FHVy696Q1JQZMTRj";
                         id = 4xFUf1FHVy696Q1JQZMTRj;
                         name = "Carrie Underwood";
                         type = artist;
                         uri = "spotify:artist:4xFUf1FHVy696Q1JQZMTRj";
                     }
                 );
                 "available_markets" =                     (
                     AD,
                     AE,
                     AG
                 );
                 "external_urls" =                     {
                     spotify = "https://open.spotify.com/album/5HwzpaqYOZABPnmvl5JYFX";
                 };
                 href = "https://api.spotify.com/v1/albums/5HwzpaqYOZABPnmvl5JYFX";
                 id = 5HwzpaqYOZABPnmvl5JYFX;
                 images =                     (
                                             {
                         height = 640;
                         url = "https://i.scdn.co/image/ab67616d0000b2738b3962e95912849e28378231";
                         width = 640;
                     },
                                             {
                         height = 300;
                         url = "https://i.scdn.co/image/ab67616d00001e028b3962e95912849e28378231";
                         width = 300;
                     },
                                             {
                         height = 64;
                         url = "https://i.scdn.co/image/ab67616d000048518b3962e95912849e28378231";
                         width = 64;
                     }
                 );
                 name = "Carnival Ride";
                 "release_date" = "2007-10-23";
                 "release_date_precision" = day;
                 "total_tracks" = 13;
                 type = album;
                 uri = "spotify:album:5HwzpaqYOZABPnmvl5JYFX";
             };
             artists =                 (
                                     {
                     "external_urls" =                         {
                         spotify = "https://open.spotify.com/artist/4xFUf1FHVy696Q1JQZMTRj";
                     };
                     href = "https://api.spotify.com/v1/artists/4xFUf1FHVy696Q1JQZMTRj";
                     id = 4xFUf1FHVy696Q1JQZMTRj;
                     name = "Carrie Underwood";
                     type = artist;
                     uri = "spotify:artist:4xFUf1FHVy696Q1JQZMTRj";
                 }
             );
             "available_markets" =                 (
                 AD,
                 AE,
                 AG
             );
             "disc_number" = 1;
             "duration_ms" = 212173;
             explicit = 0;
             "external_ids" =                 {
                 isrc = GBCTA0700252;
             };
             "external_urls" =                 {
                 spotify = "https://open.spotify.com/track/2dRPQFwPqAmc42mDRnsDQu";
             };
             href = "https://api.spotify.com/v1/tracks/2dRPQFwPqAmc42mDRnsDQu";
             id = 2dRPQFwPqAmc42mDRnsDQu;
             "is_local" = 0;
             name = "All-American Girl";
             popularity = 59;
             "preview_url" = "https://p.scdn.co/mp3-preview/7d65db8239d88915f10f1fd2af1a202e996fd4e6?cid=34a0b62f1cf54be2aabb3861e24e4fc8";
             "track_number" = 2;
             type = track;
             uri = "spotify:track:2dRPQFwPqAmc42mDRnsDQu";
         },
                     {
             album =                 {
                 "album_type" = album;
                 artists =                     (
                                             {
                         "external_urls" =                             {
                             spotify = "https://open.spotify.com/artist/3vAaWhdBR38Q02ohXqaNHT";
                         };
                         href = "https://api.spotify.com/v1/artists/3vAaWhdBR38Q02ohXqaNHT";
                         id = 3vAaWhdBR38Q02ohXqaNHT;
                         name = "The All-American Rejects";
                         type = artist;
                         uri = "spotify:artist:3vAaWhdBR38Q02ohXqaNHT";
                     }
                 );
                 "available_markets" =                     (
                     CA,
                     MX,
                     US
                 );
                 "external_urls" =                     {
                     spotify = "https://open.spotify.com/album/3BCMpDOcQlbCZpf5vnTadZ";
                 };
                 href = "https://api.spotify.com/v1/albums/3BCMpDOcQlbCZpf5vnTadZ";
                 id = 3BCMpDOcQlbCZpf5vnTadZ;
                 images =                     (
                                             {
                         height = 640;
                         url = "https://i.scdn.co/image/ab67616d0000b2738f6b4035c82eb9cf42e9d8d7";
                         width = 640;
                     },
                                             {
                         height = 300;
                         url = "https://i.scdn.co/image/ab67616d00001e028f6b4035c82eb9cf42e9d8d7";
                         width = 300;
                     },
                                             {
                         height = 64;
                         url = "https://i.scdn.co/image/ab67616d000048518f6b4035c82eb9cf42e9d8d7";
                         width = 64;
                     }
                 );
                 name = "When The World Comes Down";
                 "release_date" = "2008-01-01";
                 "release_date_precision" = day;
                 "total_tracks" = 17;
                 type = album;
                 uri = "spotify:album:3BCMpDOcQlbCZpf5vnTadZ";
             };
             artists =                 (
                                     {
                     "external_urls" =                         {
                         spotify = "https://open.spotify.com/artist/3vAaWhdBR38Q02ohXqaNHT";
                     };
                     href = "https://api.spotify.com/v1/artists/3vAaWhdBR38Q02ohXqaNHT";
                     id = 3vAaWhdBR38Q02ohXqaNHT;
                     name = "The All-American Rejects";
                     type = artist;
                     uri = "spotify:artist:3vAaWhdBR38Q02ohXqaNHT";
                 }
             );
             "available_markets" =                 (
                 CA,
                 MX,
                 US
             );
             "disc_number" = 1;
             "duration_ms" = 213106;
             explicit = 0;
             "external_ids" =                 {
                 isrc = USUM70837368;
             };
             "external_urls" =                 {
                 spotify = "https://open.spotify.com/track/6ihL9TjfRjadfEePzXXyVF";
             };
             href = "https://api.spotify.com/v1/tracks/6ihL9TjfRjadfEePzXXyVF";
             id = 6ihL9TjfRjadfEePzXXyVF;
             "is_local" = 0;
             name = "Gives You Hell";
             popularity = 73;
             "preview_url" = "<null>";
             "track_number" = 4;
             type = track;
             uri = "spotify:track:6ihL9TjfRjadfEePzXXyVF";
         }
     );
     limit = 10;
     next = "https://api.spotify.com/v1/search?query=All+American&type=track&offset=10&limit=10";
     offset = 0;
     previous = "<null>";
     total = 14054;
 }
 
 */
