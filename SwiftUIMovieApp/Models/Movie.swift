//
//  Movie.swift
//  SwiftUIMovieApp
//
//  Created by Saujan Bindukar on 11/05/2024.
//

import Foundation

struct Movie: Decodable {
    let results: [Movie]
    
}

struct MovieResponse: Decodable{
    let id: Int
    let title: String
    let backdropPath: String?
    let posterPath: String?
    let overview: String
    let voteAverage: Double
    let voteCount: Int
    let runtime: Int?
    
    
}
