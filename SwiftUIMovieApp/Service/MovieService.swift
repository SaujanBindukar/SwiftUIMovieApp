//
//  MovieService.swift
//  SwiftUIMovieApp
//
//  Created by Saujan Bindukar on 11/05/2024.
//

import Foundation

//same like abstract class in Flutter
protocol MovieService {
    
    func fetchMovies(from endpoint: MovieListEndpoint, completion: @escaping (Result<MovieResponse, MovieError>) -> ())
    
    func fetchMovie(id: Int, completion: @escaping (Result<Movie, MovieError>) -> ())
    
    func searchMovie(query: String, completion: @escaping (Result<MovieResponse, MovieError>)->())

}


enum MovieListEndpoint: String{
    
    case nowPlaying = "now_playing"
    case upcoming
    case topRated = "top_rated"
    case popular
    
    var description : String{
        switch self {
        case .nowPlaying:  return "Now Playing"
        case .upcoming: return "Upcoming"
        case .topRated: return "Top Rated"
        case .popular: return "Popular"
        }
    }
}


enum MovieError: Error, CustomNSError{
    
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case serializationError
    
    var localozardDescription: String{
        
        switch self{
        case .apiError: return "Failed to fetch data"
        case .invalidEndpoint: return "Invalid Endpoint"
        case .invalidResponse: return "Invalid Response"
        case .noData: return "No data"
        case .serializationError: return "Failed to decode data"
        }
    }
    
    var errorUserInfo: [String : Any]{
        [NSLocalizedDescriptionKey: localizedDescription]
        
    }
       
}
