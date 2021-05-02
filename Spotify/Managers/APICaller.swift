//
//  APICaller.swift
//  Spotify
//
//  Created by Michael Chen on 2/22/21.
//

import Foundation

final class APICaller {
    
    static let shared = APICaller()
    
    private init() {
    
    }
    
    
    struct Constants {
        static let baseAPIURL = "https://api.spotify.com/v1"
    }
    
    enum APIError: Error {
        case failedToGetData
    }
    
    
    // MARK: - get albums info
    public func getAlbumDetails(for album:Album, completion: @escaping (Result<AlbumDetailsResponse, Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/albums/" + album.id),
                      type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
                guard let data = data, error == nil else{
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    //let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    let result = try JSONDecoder().decode(AlbumDetailsResponse.self, from: data)
                    print(result)
                    completion(.success(result))
                } catch {
                    print(error)
                    completion(.failure(error))
                }
                
            }
            task.resume()
        }
    }
    
    
    //MARK: - get current user's albums
    public func getCurrentUserAlbum(completion: @escaping (Result<[Album],Error>) -> Void){
        createRequest(with: URL(string: Constants.baseAPIURL + "/me/albums"),
                      type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
                guard let data = data, error == nil else{
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    //let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    let result = try JSONDecoder().decode(LibraryAlbumsResponse.self, from: data)
                    print(result)
                    //getting back the albums in the items array
                    completion(.success(result.items.compactMap({ $0.album })))
                } catch {
                    print(error)
                    completion(.failure(error))
                }
                
            }
            task.resume()
        }
    }
    
    
    //MARK: - Add album to library
    
    public func saveAlbum(album: Album, completion: @escaping (Bool) -> Void){
        createRequest(with: URL(string: Constants.baseAPIURL + "/me/albums?ids=\(album.id)"),
                      type: .PUT
        ) { baseRequest in
            var request = baseRequest
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            print("Adding...")
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data,
                      let code = (response as? HTTPURLResponse)?.statusCode,
                      error == nil else {
                    completion(false)
                    return
                }
                
                print(code)
                completion(code == 200)
            }
            task.resume()
        }
    }
    
    
    
    
    
    //MARK: - Delete album from library
    
    public func deleteAlbum(album: Album, completion: @escaping (Bool) -> Void){
        createRequest(with: URL(string: Constants.baseAPIURL + "/me/albums?ids=\(album.id)"),
                      type: .DELETE
        ) { baseRequest in
            var request = baseRequest
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            print("Deleting...")
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let code = (response as? HTTPURLResponse)?.statusCode,
                      error == nil else {
                    completion(false)
                    return
                }
                
                print(code)
                completion(code == 200)
            }
            task.resume()
        }
    }
    
    
    // MARK: - get playlist info
    public func getplaylistDetails(for playlist:Playlist, completion: @escaping (Result<PlaylistDetailsResponse, Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/playlists/" + playlist.id),
                      type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
                guard let data = data, error == nil else{
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    //let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    let result = try JSONDecoder().decode(PlaylistDetailsResponse.self, from: data)
                    print(result)
                    completion(.success(result))
                } catch {
                    print(error)
                    completion(.failure(error))
                }
                
            }
            task.resume()
        }
    }
    
    
    
    //MARK: - getting current user playlist
    
    public func getCurrentUserPlaylist(completion: @escaping (Result<[Playlist], Error>) -> Void){
        createRequest(with: URL(string: Constants.baseAPIURL + "/me/playlists?limit=50"),
                      type: .GET
        ){ request in
            let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    //let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    let result = try JSONDecoder().decode(LibraryPlaylistResponse.self, from: data)
                    print(result)
                    completion(.success(result.items))
                } catch {
                    print(error)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    
    //MARK: - creating a playlist
    public func createPlaylist(with name: String, completion: @escaping (Bool) -> Void){
        
        getCurrentUserProfile { result in
            switch result{
            case .success(let profile):
                let urlString =  Constants.baseAPIURL + "/users/\(profile.id)/playlists"
                print(urlString)
                
                self.createRequest(with: URL(string: urlString), type: .POST) { baseRequest in
                    var request = baseRequest
                    let json = ["name": name]
                    request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
                    
                    let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
                        guard let data = data, error == nil else {
                            completion(false)
                            return
                        }
                        
                        do {
                            let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                            //let result = try JSONDecoder().decode(Playlist.self, from: data)
                            if let response = result as? [String: Any], response["id"] as? String != nil {
                                print("Created: \(result)")
                                completion(true)
                            }
                            else {
                                print("Failed to get id")
                                completion(false)
                            }
                            
                        } catch {
                            print(error.localizedDescription)
                            completion(false)
                        }
                    }
                    task.resume()
                }
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
        
        ///users/{user_id}/playlists
    }
    
    
    //MARK: - Add Track to playlist
    public func addTrackToPlaylist(track: AudioTrack, playlist: Playlist, completion: @escaping (Bool) -> Void){
        createRequest(with: URL(string: Constants.baseAPIURL + "/playlists/\(playlist.id)/tracks" ), type: .POST
        ) { baseRequest in
            var request = baseRequest
            let json = [
                "uris": ["spotify:track:\(track.id)"]
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            print("Adding...")
            let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
                guard let data = data, error == nil else {
                    completion(false)
                    return
                }
                
                do {
                    let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    if let response = result as? [String: Any], response["snapshot_id"] as? String != nil {
                        print(result)
                        completion(true)
                    }
                    else {
                        print(result)
                        completion(false)
                    }
                    
                } catch {
                    print(error.localizedDescription)
                    completion(false)
                }
                
            }
            task.resume()
        }
    }
    
    
    //MARK: - Remove Track from playlist
    public func removeTrackFromPlaylist(track: AudioTrack, playlist: Playlist, completion: @escaping (Bool) -> Void){
        createRequest(with: URL(string: Constants.baseAPIURL + "/playlists/\(playlist.id)/tracks" ), type: .DELETE
        ) { baseRequest in
            var request = baseRequest
            let json = [
                "tracks": [
                    [
                        "uri" : "spotify:track:\(track.id)"
                    ]
                    
                ]
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            print("Removing...")
            let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
                guard let data = data, error == nil else {
                    completion(false)
                    return
                }
                
                do {
                    let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    if let response = result as? [String: Any], response["snapshot_id"] as? String != nil {
                        print(result)
                        completion(true)
                    }
                    else {
                        print(result)
                        completion(false)
                    }
                    
                } catch {
                    print(error.localizedDescription)
                    completion(false)
                }
                
            }
            task.resume()
        }
    }
    
    
    // MARK: - get current user info
    ///Calling Spotify's api to get current user info
    public func getCurrentUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void){
        createRequest(with: URL(string: Constants.baseAPIURL + "/me"),
                      type: .GET
        ) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { (data, _, error) in
                guard let data = data, error == nil else {
                    //this completion handler passes back a result type
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    //let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    let result = try JSONDecoder().decode(UserProfile.self, from: data)
                    print(result)
                    completion(.success(result))
                }
                catch{
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    
    // MARK: - get new release
    ///Caling Spotify's api to get new releases
    public func getNewReleases(completion: @escaping ((Result<NewReleasesResponse, Error>)) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/browse/new-releases?limit=50"),
                      type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
                guard let data = data, error == nil else{
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    //let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    let result = try JSONDecoder().decode(NewReleasesResponse.self, from: data)
                    //print(result)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            
            task.resume()
        }
    }
    
    
    // MARK: - get feature playlist
    ///Calling Spotify's api to get featured playlist
    public func getFeaturedPlayList(completion: @escaping ((Result<FeaturePlaylistsResponse,Error>) -> Void)){
        createRequest(with: URL(string: Constants.baseAPIURL + "/browse/featured-playlists?limit=20"),
                      type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
                guard let data = data, error == nil else{
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    //let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    let result = try JSONDecoder().decode(FeaturePlaylistsResponse.self, from: data)
                    //print(result)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            
            task.resume()
        }
    }
    
    // MARK: - get recommendations
    ///Calling Spotify's api to get recommendations
    public func getRecommendations(genres: Set<String>, completion: @escaping ((Result<RecommendationsResponse,Error>) -> Void)){
        
        //create a comma sperated list
        let seeds = genres.joined(separator: ",")
        //print("seeds--------------> \(seeds)")
        
        createRequest(with: URL(string: Constants.baseAPIURL + "/recommendations?limit=40&seed_genres=\(seeds)"),
                      type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
                guard let data = data, error == nil else{
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    //let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    let result = try JSONDecoder().decode(RecommendationsResponse.self, from: data)
                    //print(result)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            
            task.resume()
        }
    }
    
    
    
    ///Calling Spotify's api to get recommended genres
    public func getRecommendedGenres(completion: @escaping ((Result<RecommendedGenresResponse,Error>) -> Void)) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/recommendations/available-genre-seeds"),
                      type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
                guard let data = data, error == nil else{
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    //let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    let result = try JSONDecoder().decode(RecommendedGenresResponse.self, from: data)
                    //print(result)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            
            task.resume()
        }
    }
    
    
    //MARK: - Get categories
    ///Calling Spotify's api to get all categories
    public func getCatergories(completion: @escaping (Result<[Category],Error>) -> Void ) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/browse/categories?limit=50"),
                      type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    //let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    let result = try JSONDecoder().decode(AllCategoriesResponse.self, from: data)
                    //print(result.categories.items)
                    completion(.success(result.categories.items))
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    
    
    //MARK: - Get playlist for category
    ///Calling Spotify's api to get playlist for a category
    public func getCatergoryPlaylist(catergory: Category, completion: @escaping (Result<[Playlist],Error>) -> Void ) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/browse/categories/\(catergory.id)/playlists?limit=50"),
                      type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    //let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    let result = try JSONDecoder().decode(CategoryPlaylistsResponse.self, from: data)
                    let playlists = result.playlists.items
                    //print(playlists)
                    completion(.success(playlists))
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    
    //MARK: -  Search api
    ///Calling Spotify's api to perform a search
    
    //query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) will handles things like turn spaces into %20
    public func search(with query:String, completion: @escaping (Result<[SearchResult], Error>) -> Void){
        createRequest(with: URL(string: Constants.baseAPIURL + "/search?limit=10&type=album,artist,playlist,track&q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"),
                      type: .GET
        ) { request in
            print(request.url?.absoluteURL ?? "none")
            let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    //let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    let result = try JSONDecoder().decode(SearchResultResponse.self, from: data)
                    var searchResults: [SearchResult] = []
                    //convert each item in tracks, albums, artists, and playlists into a SearchResult
                    searchResults.append(contentsOf: result.tracks.items.compactMap ({ .track(model: $0)}))
                    searchResults.append(contentsOf: result.albums.items.compactMap ({ .album(model: $0)}))
                    searchResults.append(contentsOf: result.artists.items.compactMap ({ .artist(model: $0)}))
                    searchResults.append(contentsOf: result.playlists.items.compactMap ({ .playlist(model: $0)}))
                        
                    print(result)
                    completion(.success(searchResults))
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }

            }
            task.resume()
        }
    }
    
    
    //MARK: - Play a song
    ///Calling Spotify's api to perform playback for a song
    public func playback(song: String, completion: @escaping (Result<[Playlist],Error>) -> Void ) {
        
        createPlayBackRequest(with: URL(string: Constants.baseAPIURL + "/me/player/play"),
                              type: .POST,
                              song: song
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
//                guard let data = data, error == nil else {
//                    completion(.failure(APIError.failedToGetData))
//                    return
//                }
//                
//                do {
//                    //let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
//                    let result = try JSONDecoder().decode(CategoryPlaylistsResponse.self, from: data)
//                    let playlists = result.playlists.items
//                    //print(playlists)
//                    completion(.success(playlists))
//                } catch {
//                    print(error.localizedDescription)
//                    completion(.failure(error))
//                }
            }
            task.resume()
        }
    }
    
    
    //MARK: - private
    
    enum HTTPMethod: String {
        case GET
        case POST
        case DELETE
        case PUT
    }
    
    
    private func createRequest(with url: URL?,
                               type: HTTPMethod,
                               completion: @escaping(URLRequest) -> Void) {
        
        AuthManager.shared.withValidToken { token in
            guard let apiURL = url else {
                return
            }
            var request = URLRequest(url: apiURL)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30   //30 secs time out
            completion(request)
        }
    }
    
    
    private func createPlayBackRequest(with url: URL?,
                               type: HTTPMethod,
                               song: String,
                               completion: @escaping(URLRequest) -> Void) {
        
        AuthManager.shared.withValidToken { token in
            guard let apiURL = url else {
                return
            }
            var request = URLRequest(url: apiURL)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30   //30 secs time out
            
            
            do {
                let dictionary = ["uris": ["\(song)"]]
                request.httpBody = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
            }
            catch{
                print(error.localizedDescription)
            }
            completion(request)
        }
    }
    
}
