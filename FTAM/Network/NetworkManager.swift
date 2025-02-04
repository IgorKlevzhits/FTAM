//
//  NetworkManager.swift
//  FTAM
//
//  Created by Игорь Клевжиц on 03.02.2025.
//

import Foundation

final class NetworkManager {
    
    init() {}
    
    static let shared = NetworkManager()
    
    var memes = [Meme]()
    
    func fetchMemes() {
        
        guard let url = URL(string: "https://api.imgflip.com/get_memes") else { return }
        let fetchRequest = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: fetchRequest) {[weak self] (data, response, error) -> Void in
            if error != nil {
                print("error")
            } else {
                guard let safeData = data else { return }
                
                if let decodeQuery = try? JSONDecoder().decode(Query.self, from: safeData) {
                    self?.memes = decodeQuery.data.memes
                }
            }
        }.resume()
    }
}
