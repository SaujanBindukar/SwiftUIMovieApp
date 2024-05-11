//
//  Utils.swift
//  SwiftUIMovieApp
//
//  Created by Saujan Bindukar on 11/05/2024.
//

import Foundation


class Utils {
    
    static let jsonDecoder: JSONDecoder = {
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
//        jsonDecoder.dataDecodingStrategy = formatted(dateFormatter)
        return jsonDecoder
    }()
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        return dateFormatter
    }()
}
