//
//  BookModel.swift
//  my-books-app
//
//  Created by James Chard on 2025/4/9.
//

import Foundation

class BookSearchResponse: Codable {
    var items: [BookVolume]? = []
}

class BookVolume: Codable {
    var id: String? = ""
    var selfLink: String? = ""
    var volumeInfo: VolumeInfo?
}

class VolumeInfo: Codable {
    var title:String? = "Unknown Title"
    var subtitle:String? = ""
    var authors: [String]? = ["Unknown Author"]
    var publishedDate: String? = "Unknown"
    var description: String? = "No Description"
    var pageCount: Int? = 100
    var categories: [String]? = []
    var imageLinks: ImageLinks?
    
}

class ImageLinks: Codable {
    var thumbnail: String? = ""
}
