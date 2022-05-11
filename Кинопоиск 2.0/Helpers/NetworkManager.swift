//
//  NetworkManager.swift
//  NetworkManager
//
//  Created by Roman Kiruxin on 08.05.2022.
//

import Foundation

class JSONUrl {
    static let shared = JSONUrl()
    
    var jsonUrlTopMovies = "https://api.kinopoisk.dev/movie?field=rating.kp&search=9-10&field=year&search=1990-2022&field=typeNumber&search=1&sortField=year&sortType=1&sortField=votes.imdb&sortType=-1&token=ZQQ8GMN-TN54SGK-NB3MKEC-ZKB8V06"
    
    var jsonUrlSeachingMovies = "https://api.kinopoisk.dev/movie?isStrict=false&field=typeNumber&search=1&sortField=year&sortType=1&sortField=votes.imdb&sortType=-1&token=WF67ETQ-0PNMW3S-N7SY01J-VEGXRJX&field=name&search="
}

class NetworkManager {

    static func fetchDataMovies(jsonUrl: String, page: Int, completion: @escaping (SearchMovies) -> ()) {

        let newJsonUrl = jsonUrl + "&page=\(page)"
        
        guard let url = URL(string: newJsonUrl) else { return }
        
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = [
            "Content-Type": "application/json"
        ]

        URLSession.shared.dataTask(with: url) { (data, response, error) in

            if let error = error {
                print(error.localizedDescription)
                return
            }

            guard let data = data else { return }
            
            print(data)

            do {
                let movies = try JSONDecoder().decode(SearchMovies.self, from: data)

                DispatchQueue.main.async {
                    completion(movies)
                }

                print(movies)
            } catch let error {
                print(error)
            }
        }.resume()
    }
}
