//
//  MovieStore.swift
//  SwiftUIMovieApp
//
//  Created by Saujan Bindukar on 11/05/2024.
//

import Foundation

class MovieStore: MovieService {
    
    static let shared = MovieStore()
    private init(){}
    
    private let apiKey = "8b64a757db3ca10e01db9a717db9b331"
    private let baseAPIUrl = "https://api.themoviedb.org/3"
    private let urlSession = URLSession.shared
    private let jsonDecoder = Utils.jsonDecoder
    
    func fetchMovies(from endpoint: MovieListEndpoint, completion: @escaping (Result<MovieResponse, MovieError>) -> ()) {
        guard let url = URL(string: "\(baseAPIUrl)/movie/\(endpoint.rawValue)") else{
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecode(url: url, completion: completion)
    }
    
    func fetchMovie(id: Int, completion: @escaping (Result<Movie, MovieError>) -> ()) {
        guard let url = URL(string: "\(baseAPIUrl)/\(id)") else{
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecode(url: url, params: [
            "append_to_response": "videos, credits"
        ], completion: completion)
    }
    
    func searchMovie(query: String, completion: @escaping (Result<MovieResponse, MovieError>) -> ()) {
        guard let url = URL(string: "\(baseAPIUrl)/search/movie/") else{
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecode(url: url, params: [
            "language": "en-US",
            "include_adult": "false",
            "region": "US",
            "query": query
        ],completion: completion)
    }
    
    private func loadURLAndDecode<D: Decodable>(url: URL, params:[String: String]? = nil, completion: @escaping (Result<D, MovieError>) ->()){
        guard var urlComponents = URLComponents(url: <#T##URL#>, resolvingAgainstBaseURL: false)else{
            completion(.failure(.invalidEndpoint))
        }
        
        var queryItems = [URLQueryItem(name: "api_value", value: apiKey)]
        if let params = params {
            queryItems.append(contentsOf: params.map{URLQueryItem(name: $0.key, value: $0.value)})
        }
        urlComponents.queryItems = queryItems
        
        guard let finalUrl = urlComponents.url else {
            completion(.failure(.invalidEndpoint))
        }
        
        urlSession.dataTask(with: finalUrl){
          [weak self]  (data,response,error) in
            guard let self = self else { return }
            if error != nil{
                self.executeCompletionHandlerInMainThread(with: .failure(.apiError), completion: completion)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                self.executeCompletionHandlerInMainThread(with: .failure(.invalidResponse), completion: completion)
                return
            }
            
            guard let data = data else{
                self.executeCompletionHandlerInMainThread(with: .failure(.noData), completion: completion)
            }
            
            do{
                let decodeResponse =  try self.jsonDecoder.decode(D.self, from: data)
                self.executeCompletionHandlerInMainThread(with: .success(decodeResponse), completion: completion)
            
            }catch{
                self.executeCompletionHandlerInMainThread(with: .failure(.serializationError), completion: completion)
                
            }
            
            
        }.resume()
        
        
    }
    
    private func executeCompletionHandlerInMainThread<D: Decodable>(with result: Result<D, MovieError>, completion: @escaping (Result<D, MovieError>)-> ()){
        DispatchQueue.main.async {
            completion(result)
        }
    }
}

