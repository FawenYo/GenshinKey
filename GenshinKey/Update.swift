//
//  Update.swift
//  GenshinKey
//
//  Modified by FawenYo on 6/13/2021
//

import Foundation

class Update {
    static let url = URL(string: "https://raw.githubusercontent.com/FawenYo/GenshinKey/main/db.json")
    
    struct UpdateJson: Codable {
      let version: Double
      let download: String
    }
    
    static func checkForUpdate(completion:  @escaping (String)->()) {
        guard let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return;
        }
        
        let request = URLRequest(url: self.url!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 60.0)
        URLSession.shared.dataTask(with: request) { data, response, error in
          if let data = data {
             do {
                let res = try JSONDecoder().decode(UpdateJson.self, from: data)
                if (res.version > Double(currentVersion)!) {
                    completion(res.download)
                } else {
                    completion("")
                }
             } catch let error {
                print(error)
             }
          }
        }.resume()
        
        
    }
}
