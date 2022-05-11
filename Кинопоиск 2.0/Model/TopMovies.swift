//
//  TopMovies.swift
//  TopMovies
//
//  Created by Roman Kiruxin on 09.05.2022.
//

import Foundation

struct SearchMovies: Decodable {
    var docs: [Movies?]
    let total: Int?
    let limit: Int?
    var page: Int?
    let pages: Int?
}

struct Movies: Decodable {
    let poster: Poster?
    let rating: Rating?
    let name: String?
    let year: Int?
    let description: String?
}

struct Poster: Decodable {
    let url: String?
}

struct Rating: Decodable {
    let imdb: Double?
}
