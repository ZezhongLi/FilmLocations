//
//  MovieClient.swift
//  FilmLoctions
//
//  Created by Neil Li on 12/12/17.
//  Copyright © 2017 Li Zezhong. All rights reserved.
//
//  MovieClient Sending request to download data.
//

import UIKit

class MovieClient: NSObject {
    private let urlString = "https://data.sfgov.org/api/views/yitu-d5am/rows.json?accessType=DOWNLOAD"
    func fetchMovies(completion: @escaping (Array<Any>?) -> ()) {
        let session = URLSession(configuration: URLSessionConfiguration.default)
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                completion(nil)
                return
            }
            // check status
            guard let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? Dictionary<String, Any>,
                json != nil,
                let array = json!["data"] as? Array<Any>
            else {
                completion(nil)
                print("data corrupted")
                return
            }
            DispatchQueue.main.async {
                completion(array)
            }
        }
        task.resume()
    }
}
