//
//  AuthResponse.swift
//  Spotify
//
//  Created by Michael Chen on 2/24/21.
//

import Foundation

/*
 {
     "access_token" = "BQA2s7Dro1SWABNlpvS5LJFAy4yEHU4ZjXjDxILhT55vLorHGXGC2XWsdwJ3ZcVPf5uUHQfDdNBUebf9Z5_vkFgNmxA3YG3koRbM-sxlnRLl-fOwhzDNwi4_4fjwWXgHNvtk3i9g7FSweG5ux9dh9llf2n5tLhwMRmjxn6MGFepUKC31Dyk";
     "expires_in" = 3600;
     "refresh_token" = "AQAmViURHGMedHbH9-lVgkRmT8jJ2snuxHkHjDJSlXqIeGJDcQaWW0U2kgD-SqDvtBPzSYbyCHHy_oQZTL_oCv65tNu4n8M1i8jXSUQ_Viygw4Z5CvWMLh-BdUmPwUrPoEU";
     scope = "user-read-private";
     "token_type" = Bearer;
 }
 */

///Model for authorization repsone for access_token for us to use codable to for serialization(convert json into the object)
struct AuthResponse: Codable {
    //these property names matches the ones from the response
    let access_token: String
    let expires_in: Int
    let refresh_token: String?
    let scope: String
    let token_type: String
}

/*
 refresh_token is optional beacuse the first call to get access_token comes back with a refresh_token, but
 the call to refresh the token does not come back with refresh_token

*/
