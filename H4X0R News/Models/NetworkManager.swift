//
//  NetworkManager.swift
//  H4X0R News
//
//  Created by Marcin Habzda on 15/04/2021.
//

import Foundation

class NetworkManager: ObservableObject {
    
    @Published var posts = [Post]()
    
    func fetchData() {
        if let url = URL(string: "http://hn.algolia.com/api/v1/search?tags=front_page") {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error == nil {
                    self.decodeData(data)
                }
            }
            
            task.resume()
        }
    }
    
    private func decodeData(_ data: Data?) {
        let decoder = JSONDecoder()
        if let safeData = data {
            do {
                let results = try decoder.decode(Results.self, from: safeData)
                DispatchQueue.main.async {
                    self.posts = results.hits
                }
            } catch {
                print(error)
            }
        }
    }
 }
