//
//  Meme.swift
//  FTAM
//
//  Created by Игорь Клевжиц on 03.02.2025.
//

import Foundation

struct Meme: Decodable {
    let url: String
}

struct MemeData: Decodable {
    let memes: [Meme]
}

struct Query: Decodable {
    let data: MemeData
}
