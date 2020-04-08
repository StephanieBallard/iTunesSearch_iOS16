//
//  SearchResultController.swift
//  iTunesSearch_iOS16
//
//  Created by Stephanie Ballard on 4/6/20.
//  Copyright © 2020 Stephanie Ballard. All rights reserved.
//

import Foundation

class SearchResultController {
    
    enum HTTPMethod: String {
        case get = "GET"
        case put = "PUT"
        case post = "POST"
        case delete = "DELETE"
    }
    
    var searchResults: [SearchResult] = []
    
    private let baseURL = URL(string: "https://itunes.apple.com/search")!
    //private lazy var searchResultsURL = URL(string: "/search", relativeTo: baseURL)!
    private var task: URLSessionTask?
    
    func performSearch(searchTerm: String, resultType: ResultType, completion: @escaping () -> Void) {
        task?.cancel()
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        let titleQueryItem = URLQueryItem(name: "term", value: searchTerm)
//        let creatorQueryItem = URLQueryItem(name: "artistName", value: searchTerm)
//
        
        urlComponents?.queryItems = [titleQueryItem]
        
        guard let requestURL = urlComponents?.url else {
            print("Request URL is nil")
            completion()
            return
        }
        var request = URLRequest(url: requestURL)
        print(request)
        request.httpMethod = HTTPMethod.get.rawValue
        
        task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                return
            }
            
            guard let self = self else { return }
            guard let data = data else {
                print("No data returned from dataTask")
                return
            }
            
            let jsonDecoder = JSONDecoder()
            do {
                let itunesSearch = try jsonDecoder.decode(SearchResults.self, from: data)
                self.searchResults = itunesSearch.results
            } catch {
                print("Unable to decode data into instance of itunesSearch: \(error.localizedDescription)")
            }
            completion()
        }
        task?.resume()
        
    }
}
