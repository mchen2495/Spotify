//
//  UserProfile.swift
//  Spotify
//
//  Created by Michael Chen on 2/22/21.
//

import Foundation

/*

 response from get current user info spotifiy api call
 {
     country = US;
     "display_name" = fsfsfsfsdf;
     email = "dsffsfsfs@gmail.com";
     "explicit_content" =     {
         "filter_enabled" = 0;
         "filter_locked" = 0;
     };
     "external_urls" =     {
         spotify = "https://open.spotify.com/user/...";
     };
     followers =     {
         href = "<null>";
         total = 0;
     };
     href = "https://api.spotify.com/v1/users/...";
     id = ...;
     images =     (
     );
     product = premium;
     type = user;
     uri = "spotify:user:...";
 }
 */



struct UserProfile: Codable {
    let country: String
    let display_name: String
    let email: String
    let explicit_content: [String: Bool]
    let external_urls: [String: String]
    //let followers:[String: Codable?]
    let id: String
    let product: String
    let images: [APIImage]
    
}



//struct UserImage: Codable {
//    let url: String
//}
