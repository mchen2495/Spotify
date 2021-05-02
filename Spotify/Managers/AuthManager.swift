//
//  AuthManager.swift
//  Spotify
//
//  Created by Michael Chen on 2/22/21.
//

import Foundation

final class AuthManager {
    //creating a singleton
    static let shared = AuthManager()
    
    private var refreshingToken = false
    
    struct Constants {
        static let tokenAPIURL = "https://accounts.spotify.com/api/token"
        static let redirectURI = "https://www.google.com/"
        static let scopes = "user-read-private%20playlist-modify-public%20playlist-read-private%20playlist-modify-private%20user-follow-read%20user-library-modify%20user-follow-read%20user-read-email%20user-library-read"
    }
    
    private init(){
        
    }
    
    
    public var signInURL: URL? {
        let base = "https://accounts.spotify.com/authorize"
        let string = "\(base)?response_type=code&client_id=\(K_CLIENT_ID)&scope=\(Constants.scopes)&redirect_uri=\(Constants.redirectURI)&show_dialog=TRUE"
        return URL(string: string)
    }
    
    var isSignedIn: Bool {
        return accessToken != nil
    }
    
    private var accessToken: String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    private var refreshToken: String? {
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    private var tokenExpirationDate: Date? {
        return UserDefaults.standard.object(forKey: "expirationDate") as? Date
    }
    
    private var shouldRefreshToken: Bool {
        guard let expirationDate = tokenExpirationDate else {
            return false
        }
        let currentDate = Date()
        let fiveMinutes: TimeInterval = 300
        //will the token expire in 5 minutes?
        return currentDate.addingTimeInterval(fiveMinutes) >= expirationDate
    }
    
    //takes in a compeltion handler that gives us back a bool
    //lets caller of exchangeCodeForToken know whether it succeed or not
    public func exchangeCodeForToken(code: String, completion: @escaping ((Bool) -> Void)){
        //get token
        guard let url = URL(string: Constants.tokenAPIURL) else {
            return
        }
        
        //Step 2 in spotify authorization-guide
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI)
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        
        let basicToken = K_CLIENT_ID+":"+K_CLIENT_SECRET
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            print("Failure to get base64")
            completion(false)
            return
        }
        
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) {[weak self] (data, _, error) in
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            
            do {
                //getting generic json back from response
                //let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.cacheToken(result: result)
                
                print("SUCCESS: \(result)")
                completion(true)
            }
            catch{
                print(error.localizedDescription)
                completion(false)
            }
            
        }
        //kicks off api call
        task.resume()
        
    }
    
    private var onRefreshBlocks = [((String) -> Void)]()
    
    ///Do we need to get a new token? if not use current access token
    ///Supplies valid token to be used with API calls
    public func withValidToken(completion: @escaping (String) -> Void) {
        //if it is currently refreshing the token append the completion
        guard !refreshingToken else {
            //Append the completion
            onRefreshBlocks.append(completion)
            return
        }
        
        if shouldRefreshToken {
            //refresh
            refreshIfNeeded { [weak self] success in
                if let token = self?.accessToken, success{
                    completion(token)
                }
            }
        }
        else if let token = accessToken{
            completion(token)
        }
    }
    
    
    /*making completion optional(removing escaping) beacuse if user is already sign in we want to refresh
      look in appDelegate
     */
    public func refreshIfNeeded(completion: ((Bool) -> Void)?){
        //checking that we are not already refreshing the token
        guard !refreshingToken else {
            return
        }
        
        //do we need to refresh?
        guard shouldRefreshToken else {
            completion?(true)
            return
        }
        
        guard let refreshToken = self.refreshToken else {
            return
        }
        
        //Refresh the token
        guard let url = URL(string: Constants.tokenAPIURL) else {
            return
        }
        
        refreshingToken = true
        
        //Step 2 in spotify authorization-guide
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken)
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        
        let basicToken = K_CLIENT_ID+":"+K_CLIENT_SECRET
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            print("Failure to get base64")
            completion?(false)
            return
        }
        
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) {[weak self] (data, _, error) in
            self?.refreshingToken = false
            guard let data = data, error == nil else {
                completion?(false)
                return
            }
            
            do {
                //getting generic json back from response
                //let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                //call each completion handler passing in access token
                self?.onRefreshBlocks.forEach{ $0(result.access_token)}
                self?.onRefreshBlocks.removeAll()
                print("Successfully refreshed")
                self?.cacheToken(result: result)
                completion?(true)
            }
            catch{
                print(error.localizedDescription)
                completion?(false)
            }
            
        }
        //kicks off api call
        task.resume()
        
        
        
        
        
    }
    
    public func cacheToken(result: AuthResponse){
        UserDefaults.standard.setValue(result.access_token, forKey: "access_token")
        
        if let refresh_token = result.refresh_token {
            UserDefaults.standard.setValue(refresh_token, forKey: "refresh_token")
        }
        
        //current time user login plus number of second token expires in
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "expirationDate")
    }
    
    
    public func signOut(completion: (Bool) -> Void) {
        //make values in user default nil so when user open app next time they will need to log in
        UserDefaults.standard.setValue(nil, forKey: "access_token")
        
        UserDefaults.standard.setValue(nil, forKey: "refresh_token")
        
        UserDefaults.standard.setValue(nil, forKey: "expirationDate")
        
        completion(true)
    }
    
    
}
