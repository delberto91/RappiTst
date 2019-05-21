//
//  APIManager.swift
//  Rappi
//
//  Created by Delberto Martinez on 5/17/19.
//  Copyright © 2019 Delberto Martinez. All rights reserved.
//

import Foundation
class APIManager: NSObject {
    
    //Enum Cases of request.
    enum Result <T>{
        case Success(T)
        case Error(String)
    }

    //Declare it as a sharedInstance.
    static let sharedInstance = APIManager()

    let posterURL = "http://image.tmdb.org/t/p/w185//"
    
    //Call the API to retrieve movie info 
    func getMovieInfo(method: String, completion: @escaping (Result<[[String: AnyObject]]>) -> Void) {
        let movieResponse : MovieDataResponse = MovieDataResponse()
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(method)?api_key=\(apiKey)&language=en-US&page=1") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else { return }
            guard let data = data else { return }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [String: AnyObject] {
                    DispatchQueue.main.async {
                        
                        guard let results = json["results"] as? [[String:AnyObject]] else {return}
                       
                        for elements in results {
                            let movieData : MovieData = MovieData()
                            
                            if let title = elements["title"] as? String {
                                
                                movieData.title.append(title)
                            }
                            if let overview = elements["overview"] as? String {
                                movieData.overview.append(overview)
                                
                            }
                            if let poster_path = elements["poster_path"] as? String {
                                movieData.poster_path.append(poster_path)
                            }
                            if let original_language = elements["original_language"] as? String {
                                movieData.original_language.append(original_language)
                            }
                            if let release_date = elements["release_date"] as? String {
                               
                                movieData.release_date.append(release_date)
                            }
                            
                            movieResponse.data.append(movieData)
                        }
                        completion(.Success(results))
                    }
                }
            } catch let error {
                return completion(.Error(error.localizedDescription))
            }
            }.resume()
    }
    
}

